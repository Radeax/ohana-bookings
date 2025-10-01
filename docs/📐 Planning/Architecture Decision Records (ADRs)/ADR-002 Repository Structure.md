# ADR-002: Repository Structure

## Status

Accepted

## Context

The Ohana Booking System consists of multiple applications:

- **API** (NestJS backend)
- **Frontend** (Vue 3 SPA for admin/coordinator/performer users)
- **Marketing Website** (future: public-facing site with inquiry form)

We need to decide how to organize these codebases: single monorepo, multiple repos, or hybrid approach.

## Decision Drivers

- **Code sharing**: API types need to be shared with frontend
- **Development velocity**: Solo developer needs simple, fast workflow
- **Deployment isolation**: Different apps have different deploy cadences
- **Stakeholder separation**: Marketing site may be handed to agency later
- **Technical requirements**: Marketing needs SEO/SSG, booking app doesn't
- **Repository size**: Keep clone/navigation manageable

## Options Considered

### Option A: Focused Monorepo (API + Frontend only)

**Structure:**

```
ohana-bookings/
├── apps/
│   ├── api/           # NestJS backend
│   └── frontend/      # Vue 3 SPA
├── packages/
│   ├── types/         # Shared TypeScript types
│   └── config/        # Shared ESLint/Tailwind configs
├── turbo.json
└── package.json       # Workspace root

ohana-marketing/       # SEPARATE REPO
└── Marketing website
```

**Pros:**

- ✅ **Shared types** - API contracts synced automatically between backend/frontend
- ✅ **Atomic commits** - change API endpoint + frontend consumer in same PR
- ✅ **Single source of truth** - no version mismatches
- ✅ **Simple coordination** - solo developer owns both apps
- ✅ **Fast local dev** - turborepo caching, parallel builds
- ✅ **Marketing isolation** - different tech, different stakeholders, different cadence
- ✅ **Smaller repo** - faster clones, easier navigation

**Cons:**

- ⚠️ **Two repos to maintain** - marketing site is separate
- ⚠️ **Can't share UI components** (between booking app and marketing)

### Option B: Full Monorepo (Everything)

**Structure:**

```
ohana/
├── apps/
│   ├── api/
│   ├── frontend/
│   └── marketing/     # Marketing site included
└── packages/
    ├── types/
    └── ui/            # Shared components
```

**Pros:**

- ✅ **Everything in one place**
- ✅ **Could share UI components** between apps

**Cons:**

- ❌ **Marketing creates noise** - different concerns mixed
- ❌ **Harder to hand off** - can't give agency just marketing repo
- ❌ **Different deploy needs** - marketing wants static gen, booking app doesn't
- ❌ **Bigger repo** - slower to clone/navigate
- ❌ **Shared UI unlikely** - booking app and marketing have very different needs

### Option C: Polyrepo (Separate Everything)

**Structure:**

```
ohana-api/
ohana-frontend/
ohana-marketing/
ohana-types/        # Shared types as npm package
```

**Pros:**

- ✅ **Complete isolation**
- ✅ **Independent versioning**

**Cons:**

- ❌ **Type sharing pain** - need to publish/version shared types
- ❌ **Coordination overhead** - syncing API changes across repos
- ❌ **Multiple PR workflow** - change API = PRs in 2+ repos
- ❌ **Overkill for solo dev**

## Decision

**We will use a Focused Monorepo (Option A) for the booking system, with the marketing website in a separate repository.**

### Repository Names

- `ohana-bookings` - Monorepo containing API + Frontend
- `ohana-marketing` - Separate repo for marketing site (when built)

### Rationale

1. **API + Frontend are tightly coupled** - they change together, deploy together
2. **Marketing site is loosely coupled** - different tech, different purpose, different timeline
3. **Solo developer efficiency** - atomic commits for API + frontend changes
4. **Future flexibility** - easy to hand marketing site to agency
5. **Type safety** - shared types package ensures contract compliance

## Consequences

### Positive

- Faster development: change API + frontend in single PR
- Type-safe contracts: compiler catches API/frontend mismatches
- Simpler local dev: single clone, single install, turborepo caching
- Marketing site flexibility: can use different framework, hand off later
- Cleaner organization: booking system concerns stay focused

### Negative

- Two repos to deploy (but different cadences anyway)
- Can't easily share UI components with marketing (unlikely need)
- Initial monorepo setup overhead (turborepo config)

### Risks

- **Monorepo complexity**: Could become unwieldy if many apps added
    - *Mitigation*: Only API + Frontend in monorepo; everything else separate
- **Marketing site duplication**: Might recreate components
    - *Mitigation*: Acceptable tradeoff; marketing and booking app are very different

## Follow-up Actions

- [ ]  Initialize `ohana-bookings` monorepo with pnpm workspaces
- [ ]  Configure Turborepo for caching and parallel execution
- [ ]  Create `packages/types` for shared API types
- [ ]  Create `packages/config` for shared ESLint/Tailwind/TS configs
- [ ]  Set up GitHub Actions CI for monorepo
- [ ]  Document local development setup in README