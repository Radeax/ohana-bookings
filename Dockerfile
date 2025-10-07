# Dockerfile for the entire Turborepo monorepo
# Multi-stage build for optimal image size

# Base stage
FROM node:22-alpine AS base
RUN apk add --no-cache libc6-compat
RUN corepack enable && corepack prepare pnpm@8.15.5 --activate

# Create non-root user (consistent with Dockerfile.dev)
RUN addgroup -g 1001 nodejs && \
    adduser -D -u 1001 -G nodejs nodejs

WORKDIR /app
RUN chown -R nodejs:nodejs /app

# Pruner stage
FROM base AS pruner
USER nodejs
COPY --chown=nodejs:nodejs . .
RUN pnpm dlx turbo prune --scope=api --scope=web --docker

# Dependencies stage
FROM base AS deps
USER nodejs
COPY --chown=nodejs:nodejs --from=pruner /app/out/json/ .
COPY --chown=nodejs:nodejs --from=pruner /app/out/pnpm-lock.yaml ./pnpm-lock.yaml
COPY --chown=nodejs:nodejs --from=pruner /app/out/pnpm-workspace.yaml ./pnpm-workspace.yaml
RUN pnpm install --frozen-lockfile --prod

# Builder stage
FROM base AS builder
USER nodejs
COPY --chown=nodejs:nodejs --from=pruner /app/out/full/ .
COPY --chown=nodejs:nodejs --from=deps /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs --from=deps /app/apps/api/node_modules ./apps/api/node_modules
COPY --chown=nodejs:nodejs --from=deps /app/apps/web/node_modules ./apps/web/node_modules
RUN pnpm turbo run build --filter=api --filter=web

# API Production
FROM node:22-alpine AS api
RUN apk add --no-cache libc6-compat

# Create non-root user
RUN addgroup -g 1001 nodejs && \
    adduser -D -u 1001 -G nodejs nodejs

WORKDIR /app
RUN chown -R nodejs:nodejs /app

USER nodejs

# Copy built API
COPY --chown=nodejs:nodejs --from=builder /app/apps/api/dist ./dist
COPY --chown=nodejs:nodejs --from=builder /app/apps/api/package.json ./package.json
COPY --chown=nodejs:nodejs --from=deps /app/apps/api/node_modules ./node_modules

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "dist/main.js"]

# Web Production - Nginx
FROM nginx:alpine AS web
WORKDIR /usr/share/nginx/html

# Copy built frontend
RUN rm -rf ./*
COPY --from=builder /app/apps/web/dist .
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]