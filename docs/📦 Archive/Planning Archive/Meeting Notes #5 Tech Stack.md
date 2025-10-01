# Meeting Notes #5: Tech Stack

# Planning Meeting #5: Tech Stack Decisions

**Date:** September 30, 2025

**Attendees:** Joven Poblete

**Purpose:** Lock in all technology choices

---

## Final Tech Stack

### Backend

- **Framework:** NestJS (TypeScript)
- **ORM:** Drizzle
- **Database:** PostgreSQL (dev + prod)
- **Authentication:** JWT with refresh tokens (Passport)
- **Job Queue:** BullMQ + Redis
- **Validation:** class-validator + class-transformer
- **API Docs:** Swagger (OpenAPI)
- **Testing:** Jest

### Frontend

- **Build Tool:** Vite
- **Framework:** Vue 3 (Composition API)
- **UI Library:** PrimeVue
- **State Management:**
    - Pinia (global UI state: auth, sidebar, modals)
    - Pinia Colada (server state: API data fetching)
- **HTTP Client:** Axios
- **Routing:** Vue Router
- **Styling:** Tailwind CSS + PrimeVue themes
- **Type Safety:** TypeScript

### Infrastructure

- **Backend Hosting:** Railway (API + PostgreSQL + Redis)
- **Frontend Hosting:** Cloudflare Pages
- **Repository:** Monorepo (`ohana-bookings`)
    - `/apps/api` - NestJS
    - `/apps/frontend` - Vue 3
    - `/packages/types` - Shared TypeScript types
    - `/packages/config` - Shared configs
- **Monorepo Tool:** Turborepo + pnpm workspaces
- **CI/CD:** GitHub Actions

### Marketing Website

- **Separate Repo:** `ohana-marketing` (future)
- **Tech:** TBD (likely Astro or Nuxt for SSR/SSG)

---

## Key Decisions & Rationale

### Why NestJS?

✅ Resume building - enterprise relevance

✅ Developer has past NestJS project to reference

✅ AI assistance offsets boilerplate pain

✅ Transferable skills for future work

✅ Huge ecosystem

**Trade-off accepted:** Slower initial velocity vs. AdonisJS, but long-term career value

### Why Drizzle ORM?

✅ Lightweight, type-safe, SQL-first

✅ Modern tooling (2025 best practice)

✅ Resume value (shows current tech awareness)

✅ Full control for complex financial queries

**Trade-off accepted:** Smaller ecosystem than Prisma, manual NestJS integration

### Why PostgreSQL Everywhere?

✅ Consistency between dev and prod

✅ Rich features (jsonb, full-text search)

✅ No migration surprises

✅ Wide hosting options

**Trade-off accepted:** Requires Docker locally (or Railway dev database)

### Why Vite + Vue 3 SPA?

✅ Fast DX (Vite HMR)

✅ No SSR complexity (admin tool doesn't need SEO)

✅ Lightweight bundle

✅ Developer's strength is Vue

**Trade-off accepted:** No file-based routing (manual vue-router)

### Why JWT?

✅ Stateless, scalable

✅ Works across domains

✅ Mobile-ready for future

✅ NestJS native support

**Security:**

- Access token: 15 minutes (in memory)
- Refresh token: 7 days (httpOnly cookie)
- Token rotation on refresh

### Why Pinia + Pinia Colada?

✅ Vue-native state management

✅ Pinia for UI state (auth, modals)

✅ Pinia Colada for server state (API fetching)

✅ Simpler than TanStack Query + Pinia

✅ Created by Eduardo (Pinia author)

**XState deferred to Phase 2:** Start simple, add state machines only if workflow complexity requires it

### Why Railway + Cloudflare?

✅ Railway: Dead simple NestJS + PostgreSQL deployment

✅ Cloudflare Pages: Free, fast CDN for Vue SPA

✅ Minimal DevOps overhead

✅ Cost: ~$5-10/month

**Background Jobs:**

- Phase 1: BullMQ on Railway (Redis required)
- Phase 2+: Offload heavy work to serverless if needed

### Why PrimeVue?

✅ Complete component library (90+ components)

✅ Excellent DataTable (sorting, filtering, pagination)

✅ Built-in Calendar components

✅ Charts included (financial reports)

✅ Free, Vue-native, TypeScript support

**Trade-off accepted:** Less trendy than shadcn-vue, but perfect for admin dashboards

---

## Repository Structure

```
ohana-bookings/                    # Monorepo
├── apps/
│   ├── api/                      # NestJS backend
│   └── frontend/                 # Vue 3 SPA
├── packages/
│   ├── types/                    # Shared TS types
│   └── config/                   # Shared configs
├── turbo.json
└── package.json

ohana-marketing/                   # Separate repo (future)
└── Marketing website
```

**Why Separate Marketing Site?**

- Different tech requirements (SEO, static gen)
- Different update cadence
- Can hand off to agency later
- Keeps booking repo focused

---

## Architecture Decision Records (ADRs)

9 ADRs created to document all decisions:

1. **ADR-001:** Backend Framework (NestJS)
2. **ADR-002:** Repository Structure (Monorepo)
3. **ADR-003:** ORM Selection (Drizzle)
4. **ADR-004:** Database (PostgreSQL)
5. **ADR-005:** Frontend Framework (Vue 3 SPA)
6. **ADR-006:** Authentication (JWT)
7. **ADR-007:** State Management (Pinia + Pinia Colada)
8. **ADR-008:** Deployment (Railway + Cloudflare)
9. **ADR-009:** UI Components (PrimeVue)

---

## Development Environment

**Local Setup:**

```bash
# Backend
Docker Compose: PostgreSQL + Redis
NestJS dev server: port 3000

# Frontend  
Vite dev server: port 5173

# Monorepo
Turborepo for parallel builds and caching
pnpm workspaces
```

**IDE Setup:**

- VSCode with Vue, ESLint, Prettier extensions
- TypeScript strict mode

---

## Success Metrics

✅ Ship Phase 1 MVP in 4 weeks

✅ Type-safe contracts between frontend/backend

✅ Modern, resume-worthy tech stack

✅ Maintainable codebase for solo developer

✅ Clear path to Phase 1.5 (performer portal)

---

## Next Steps

- Create development plan with week-by-week tasks → Session 6
- Set up project scaffolding
- Begin Week 1: Database + Auth implementation