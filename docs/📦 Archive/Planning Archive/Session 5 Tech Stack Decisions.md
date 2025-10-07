# Session 5: Tech Stack Decisions

# Session 5: Tech Stack Decisions

Now let's finalize your technology choices. You've already made some decisions in your ohana-docs ADRs, so let's build on those and fill in the gaps.

## What You've Already Decided (from ohana-docs)

✅ **Backend:** AdonisJS v6

- _I’ll Ues_

✅ **Architecture:** Monorepo (pnpm + Turborepo)

✅ **Deployment Strategy:** Hybrid (containers for API, serverless for jobs)

Let's finalize the rest!

---

## 1. Frontend Framework

You mentioned Vue/Nuxt/React/Next as options. Let's decide.

**For a solo dev building an admin dashboard, here's my take:**

### **Option A: Nuxt 3 (Vue)**

**Pros:**

- You know Vue from your professional experience
- Nuxt gives you SSR/SSG out of the box
- Great DX with auto-imports and file-based routing
- Smaller bundle sizes than React equivalents
- TanStack Query works great with Vue

**Cons:**

- Slightly smaller ecosystem than React
- Fewer admin dashboard templates

### **Option B: Next.js (React)**

**Pros:**

- Largest ecosystem and job market relevance
- Tons of admin dashboard templates (shadcn/ui, etc.)
- Your resume shows React experience
- More third-party integrations

**Cons:**

- Larger bundles
- React's complexity (useEffect, memo, etc.)
- App Router still maturing

### **Option C: Vite + Vue 3 SPA**

**Pros:**

- Simplest, fastest dev experience
- No SSR complexity for admin dashboard (doesn't need SEO)
- Lightweight and fast
- Full control

**Cons:**

- No file-based routing out of the box (use vue-router)
- Manual setup for things Nuxt gives you free

**My Recommendation for Phase 1:Vite + Vue 3 SPA** - Since this is an admin dashboard (not a public site), you don't need SSR. Keep it simple, ship fast. Add Nuxt later if you build a public marketing site.

**What's your preference?**

---

## 2. UI Component Library

Since you want to ship fast and have a good-looking UI:

### **Option A: Tailwind CSS + shadcn/ui (Vue port)**

**Pros:**

- Beautiful, modern components
- Copy/paste components (you own the code)
- Highly customizable
- Works with Vue via [shadcn-vue](https://www.shadcn-vue.com/)

**Cons:**

- Some assembly required

### **Option B: PrimeVue**

**Pros:**

- Comprehensive component library
- Built for Vue specifically
- Data tables, calendars, forms all included
- Free and open source

**Cons:**

- Less trendy aesthetic
- More opinionated styling

### **Option C: Vuetify 3**

**Pros:**

- Material Design out of the box
- Huge component library
- Very mature

**Cons:**

- Heavy framework
- Less flexible styling

**My Recommendation:** **PrimeVue** for Phase 1. It has calendar, data tables, and forms out of the box - perfect for admin dashboards. You can always switch to shadcn-vue later if you want a different aesthetic.

**Your preference?**

---

## 3. Database

For Phase 1, what's your dev → production path?

### **Option A: SQLite (dev) → PostgreSQL (prod)**

**Pros:**

- SQLite for local dev (no Docker needed)
- Postgres for production (better performance, jsonb, full-text search)
- AdonisJS Lucid ORM supports both seamlessly

**Cons:**

- Slight differences in SQL dialect
- Need to test both

### **Option B: PostgreSQL everywhere**

**Pros:**

- Consistency across dev/prod
- No surprises
- Use Docker locally or Railway/Supabase free tier

**Cons:**

- Slightly more setup for local dev

**My Recommendation:** **PostgreSQL everywhere**. Use Docker Compose locally, Railway/Supabase for production. Keep it consistent.

**Your preference?**

---

## 4. Authentication

AdonisJS has built-in auth, but you need to decide the approach:

### **Option A: Session-based (cookies)**

**Pros:**

- Traditional, secure
- Built into AdonisJS
- Easy to implement

**Cons:**

- CORS complexity if frontend/backend on different domains
- Harder to scale horizontally

### **Option B: JWT tokens**

**Pros:**

- Stateless
- Works great with separate frontend/backend
- Easy to scale

**Cons:**

- Need refresh token strategy
- Token management complexity

### **Option C: AdonisJS Auth + Lucia Auth (modern approach)**

**Pros:**

- Type-safe
- Session management
- Multi-provider support (future OAuth)

**Cons:**

- Newer library

**My Recommendation:** **JWT with refresh tokens** - Since you're doing monorepo with separate frontend/backend, this is cleanest. Use AdonisJS's built-in JWT support.

**Your preference?**

---

## 5. State Management (Frontend)

For your admin dashboard:

### **Option A: TanStack Query (Vue Query) only**

**Pros:**

- Handles all server state automatically
- Caching, refetching, mutations
- Most of your state IS server state

**Cons:**

- Need something else for UI state (modals, forms)

### **Option B: TanStack Query + Pinia (Vue's Zustand)**

**Pros:**

- TanStack Query for server state
- Pinia for UI state (current user, sidebar open, etc.)
- Clean separation

**Cons:**

- Two libraries to learn

### **Option C: XState for complex workflows**

**Pros:**

- Great for inquiry → booking workflow
- Predictable state transitions

**Cons:**

- Overkill for most of your app
- Steep learning curve

**My Recommendation:** **TanStack Query + Pinia**. You mentioned in ohana-docs to use XState "only where flows are complex" - save that for Phase 2. Keep it simple now.

**Your preference?**

---

## 6. Deployment

### **Backend (AdonisJS)**

**Option A: RailwayPros:**

- Dead simple
- Built-in Postgres
- $5/month hobby tier
- One-click deploy from GitHub

**Cons:**

- Can get expensive at scale

**Option B: Fly.ioPros:**

- Good free tier
- Edge network
- More control

**Cons:**

- Slightly more config

**Option C: AWS Fargate (from your ADR)Pros:**

- Enterprise-grade
- Full control

**Cons:**

- Complex setup
- Cost management

**My Recommendation for MVP:** **Railway**. Ship fast, migrate to AWS later if needed.

### **Frontend (Vue SPA)**

**Option A: VercelPros:**

- Free for personal projects
- Instant deploys
- Great DX

**Option B: Cloudflare PagesPros:**

- Free forever
- Edge network
- Fast

**Option C: NetlifyPros:**

- Similar to Vercel
- Good free tier

**My Recommendation:** **Cloudflare Pages** - Free, fast, great for SPAs.

**Your preferences?**

---

## 7. Additional Tools

Here's what I'd add:

**Email (Phase 1.5):**

- Resend (modern, great DX) or SendGrid

**File Storage (future):**

- Cloudflare R2 (S3-compatible, cheap) or Supabase Storage

**Monitoring:**

- Sentry for errors
- Plausible/Fathom for analytics (privacy-friendly)

**Development:**

- ESLint + Prettier
- Vitest for testing
- GitHub Actions for CI/CD

---

## Your Turn!

Please answer:

1. **Frontend:** Nuxt 3, Next.js, or Vite + Vue 3?
2. **UI Library:** PrimeVue, shadcn-vue, or Vuetify?
3. **Database:** Postgres everywhere or SQLite → Postgres?
4. **Auth:** Sessions or JWT?
5. **State:** TanStack Query + Pinia?
6. **Deployment:** Railway + Cloudflare Pages, or different?
7. **Anything else** you have strong opinions about?

Once you answer, I'll create your final tech stack ADR for Notion!

Retry

[Claude can make mistakes. Please double-check responses.](https://support.anthropic.com/en/articles/8525154-claude-is-providing-incorrect-or-misleading-responses-what-s-going-on)

Research
Ohana of Polynesia Booking App Sonnet 4.5
