# Ohana Bookings Monorepo

Booking management system for Ohana of Polynesia.

## What's inside?

### Apps and Packages

    .
    ├── apps
    │   ├── api                       # NestJS backend API
    │   └── web                       # Vue 3 + Vite frontend
    └── packages
        ├── @repo/api                 # Shared NestJS resources & types
        ├── @repo/eslint-config       # ESLint configurations (includes Prettier)
        ├── @repo/jest-config         # Jest configurations
        └── @repo/typescript-config   # TypeScript configurations

Each package and application is 100% [TypeScript](https://www.typescriptlang.org/) safe.

### Tech Stack

**Backend:**
- NestJS - Node.js framework
- PostgreSQL - Database
- Redis - Cache & sessions
- Drizzle ORM - Type-safe database queries

**Frontend:**
- Vue 3 - UI framework
- Vite - Build tool & dev server
- Pinia Colada - State management & data fetching
- PrimeVue - UI component library
- Vue Router - Client-side routing

**Development:**
- TypeScript - Static type-safety
- ESLint - Code linting
- Prettier - Code formatting
- Jest - Testing framework
- pnpm - Package manager
- Turborepo - Monorepo build system

**Deployment:**
- Docker - Containerization
- Railway - API hosting
- Cloudflare Pages - Frontend hosting

## Commands

### Build

```bash
# Build all apps & packages
pnpm run build

# ℹ️ If you plan to only build apps individually,
# please make sure you've built the packages first.
```

### Develop

```bash
# Run development servers for all apps & packages
pnpm run dev
```

### Test

```bash
# Launch test suites for all apps & packages
pnpm run test

# Run e2e tests
pnpm run test:e2e
```

### Lint

```bash
# Lint all apps & packages
pnpm run lint
```

### Format

```bash
# Format all supported files
pnpm format
```

## Development Setup

### Prerequisites

- Node.js 18+
- pnpm 8+
- Docker & Docker Compose

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ohana-bookings
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start Docker services**
   ```bash
   docker compose -f compose.dev.yaml up -d
   ```

5. **Run development servers**
   ```bash
   pnpm dev
   ```

   Access your apps:
   - Frontend: http://localhost:5173
   - API: http://localhost:3000
   - Database: localhost:5432
   - Redis: localhost:6379

## Project Structure

```
ohana-bookings/
├── apps/
│   ├── api/                  # NestJS backend
│   │   ├── src/
│   │   ├── test/
│   │   └── package.json
│   └── web/                  # Vue 3 frontend
│       ├── src/
│       ├── public/
│       └── package.json
├── packages/
│   ├── api/                  # Shared backend code
│   ├── eslint-config/        # Shared ESLint configs
│   ├── jest-config/          # Shared Jest configs
│   └── typescript-config/    # Shared TypeScript configs
├── compose.yaml              # Production Docker setup
├── compose.dev.yaml          # Development Docker setup
├── Dockerfile                # Production Dockerfile
├── Dockerfile.dev            # Development Dockerfile
├── nginx.conf                # Nginx config for Vue SPA
├── turbo.json                # Turborepo configuration
├── pnpm-workspace.yaml       # pnpm workspace configuration
└── package.json              # Root package.json
```

## Docker Commands

### Development

```bash
# Start all services
docker compose -f compose.dev.yaml up -d

# View logs
docker compose -f compose.dev.yaml logs -f

# Stop services
docker compose -f compose.dev.yaml down

# Rebuild after changes
docker compose -f compose.dev.yaml up -d --build
```

### Production

```bash
# Build and start
docker compose up --build

# Run in background
docker compose up -d
```

## Useful Links

**Frameworks & Tools:**
- [Turborepo](https://turborepo.com/docs) - Monorepo build system
- [NestJS](https://docs.nestjs.com) - Backend framework
- [Vue 3](https://vuejs.org/guide/introduction.html) - Frontend framework
- [Vite](https://vite.dev/guide/) - Build tool
- [Pinia](https://pinia.vuejs.org/) - State management
- [PrimeVue](https://primevue.org/) - UI component library
- [pnpm](https://pnpm.io/) - Package manager

**Development:**
- [Drizzle ORM](https://orm.drizzle.team/docs/overview) - Database ORM
- [Vue Router](https://router.vuejs.org/) - Routing

## Remote Caching

Turborepo can use [Remote Caching](https://turborepo.com/docs/core-concepts/remote-caching) to share cache artifacts across machines, enabling faster builds across your team and CI/CD.

To enable Remote Caching:

```bash
npx turbo login
npx turbo link
```

## License

UNLICENSED