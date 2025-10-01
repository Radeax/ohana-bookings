# Clarifications

## Quick Clarifications

### Backend: NestJS instead of AdonisJS

**I'm curious - what's driving this switch?**

- Resume building (NestJS more common in enterprise)?
    - *Yes*
- Prefer the modular architecture?
    - *No preference, but I’d like to implement what employers are looking for*
- Better ecosystem for your needs?
    - *I feel like I’ll eventually need to get familiar with NestJS in the future regardless if I learn AdonisJS today. However, if I learn NestJS I don’t think I’ll ever have to use AdonisJS.*

Understanding your reasoning will help me write a better ADR. Both are excellent choices, but for different reasons:

**NestJS pros:**

- Better job market visibility
- Modular/testable architecture
- Huge ecosystem
- TypeScript-first

**NestJS cons:**

- More boilerplate (modules, providers, decorators)
- Steeper learning curve for solo dev
- Slower initial velocity

**What's your main reason for preferring NestJS?**

- *More boiler plate but I suspect it becomes less of a hassle as features mature and there’s more copy/pasting.*
- Steeper learning curve but AI might be able to offset this
- *For the initial velocity , I have a past NestJS project I may be able to reference. AdonisJS I’d be learning everything from scratch.*

---

### Architecture: Monorepo vs Polyrepo

Great question! Here's my take:

### **Recommended Structure:**

`Option A: Focused Monorepo (MY RECOMMENDATION)
ohana/
├── apps/
│   ├── api/           # NestJS backend
│   └── admin/         # Vue SPA (booking admin dashboard)
├── packages/
│   ├── types/         # Shared TypeScript types
│   └── config/        # Shared configs (ESLint, Tailwind)
└── turbo.json

ohana-marketing/       # SEPARATE REPO
└── Marketing website (Astro/Nuxt/whatever)`

**Why separate the marketing site?**

- ✅ **Different update cadence** - Marketing site changes for campaigns, booking app changes for features
- ✅ **Different stakeholders** - Marketing site might be handed to a designer/agency later
- ✅ **Different tech needs** - Marketing needs SEO/static generation, booking app doesn't
- ✅ **Deployment isolation** - Marketing site can be on Cloudflare Pages, booking app on Railway
- ✅ **Smaller repo** - Faster clones, easier to navigate

**Why keep API + Admin in monorepo?**

- ✅ **Shared types** - API contract types used by both
- ✅ **Atomic changes** - Change API endpoint + frontend consumer in same PR
- ✅ **Single source of truth** - No version mismatches
- ✅ **Same developer** - You're building both, so coordination is easy

### Alternative: Full Monorepo

`Option B: Kitchen Sink Monorepo
ohana/
├── apps/
│   ├── api/           # NestJS
│   ├── admin/         # Vue admin dashboard
│   └── marketing/     # Marketing site
└── packages/
    └── types/`

**Pros:**

- Everything in one place
- Shared UI components between admin + marketing

**Cons:**

- Marketing site creates noise (different concerns)
- Harder to hand off marketing site later
- Bigger repo to clone/navigate

**My strong recommendation: Option A (separate marketing site).**

**Does this make sense to you?**

- *Yes. Should I call the frontend of the booking app “admin” or is there a better name? “web”, “ui”, “admin”, or another name?*

---

### Deployment Strategy

Hybrid is fine, but let me clarify:

**For your MVP, I'd actually recommend SIMPLER:**

**Phase 1:**

- Everything on Railway (API + Postgres)
- Admin UI on Cloudflare Pages
- Marketing site on Cloudflare Pages (separate repo)

**Phase 1.5+:** Add serverless

- Scheduled jobs → Railway cron (built-in)
- Email sending → Background jobs in NestJS (Bull queue)

**Phase 2+:** If you need it

- Heavy async work → AWS Lambda
- Webhooks → Serverless functions

**Don't overcomplicate Phase 1.** NestJS + Bull queue handles async jobs fine. Add serverless only when you have specific needs (image processing, webhooks at scale, etc.).

**Agree?**

- *Agree*

---

## State Management: Pinia Colada vs TanStack Query

**Great catch!** Pinia Colada is Eduardo's new library that combines Pinia + data fetching. It's essentially TanStack Query for Vue, but integrated with Pinia.

**Here's my take:**

### **Option A: Pinia Colada for everything**

typescript

`*// Pinia Colada handles both server state AND global UI state*
import { useQuery } from '@pinia/colada'

const { data, isLoading } = useQuery({
  key: ['bookings'],
  query: () => api.getBookings()
})`

**Pros:**

- One library for all state
- Built by Eduardo (Pinia creator)
- Simpler mental model

**Cons:**

- Newer, smaller ecosystem than TanStack Query
- Less mature (but Eduardo is solid)

### **Option B: TanStack Query + Pinia**

- TanStack Query for server state
- Pinia for UI state (current user, sidebar open, etc.)

**Pros:**

- TanStack Query is battle-tested
- Larger community

**Cons:**

- Two libraries

**My recommendation: Pinia Colada.** Since you're already in Vue ecosystem and it's a newer, cleaner API. Eduardo knows what he's doing.

- *Pinia Colada*

---

## XState: Now or Later?

**Critical question: Do you actually NEED XState for Phase 1?**

Let me map your workflows:

### Simple State (NO XState needed):

- List bookings → Select booking → Edit booking
- Create inquiry → Save
- Record payment

### Complex State (XState MIGHT help):

- **Inquiry → Quoted → Confirmed → Booking** with validations at each step
- Multi-step booking creation wizard (if you build one)

**Here's my honest advice:**

**Option A: NO XState in Phase 1**

- Use simple reactive state (Pinia/Pinia Colada)
- Add XState in Phase 2 IF you find yourself with spaghetti state logic

**Why?**

- You won't need to convert - XState is additive, not replacement
- You'd only use XState for specific complex flows, not everything
- Most CRUD operations don't need state machines

**Option B: XState from Day 1 for inquiry flow**

- Model inquiry → booking pipeline as state machine
- Forces you to think through all transitions
- Prevents invalid states

**Why?**

- The inquiry → booking flow IS complex (you have guards, validations)
- Doing it upfront prevents bugs later

**My recommendation: Start without XState, add it when you build the inquiry → booking conversion if you feel the complexity.**

**Converting later is NOT hard** - you'd wrap existing logic in XState, not rewrite everything.

**Your gut feeling?**

- *Ok, let’s add XState later*

---

## Industry-Standard ADR Order

Let's create ADRs in this order:

1. **ADR-001: Backend Framework (NestJS vs AdonisJS vs other)**
2. **ADR-002: Repository Structure (Monorepo vs Polyrepo)**
3. **ADR-003: Frontend Framework (Vue SPA vs Nuxt vs React)**
4. **ADR-004: Database (PostgreSQL vs other)**
5. **ADR-005: Authentication Strategy (JWT vs Sessions)**
6. **ADR-006: State Management (Pinia Colada vs TanStack Query + Pinia)**
7. **ADR-007: Deployment Strategy (Railway + Cloudflare vs alternatives)**
8. **ADR-008: UI Component Library (PrimeVue vs alternatives)**

**Before I start writing these, please answer:**

1. **Why NestJS over AdonisJS?** (I need your reasoning for ADR-001)
    1. *We can discuss this further if you recommend it. I initially picked AdonisJS to stick to a standard but NestJS might be ok.*
2. **Do you agree with separate marketing site repo?** (for ADR-002)
    1. *Yes*
3. **Do you want to start with XState for inquiry flow, or add it later?** (for ADR-006)
    1. *Later*
4. **Are you building a multi-step wizard for booking creation, or simple forms?** (affects XState decision)
    1. *Initially, no*

Once you answer these, I'll write proper ADRs with:

- Context (why we need to decide)
- Options considered (with pros/cons)
- Decision (what we chose)
- Consequences (tradeoffs we accept)
- Status (Proposed/Accepted)