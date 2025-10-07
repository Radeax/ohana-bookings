# Meeting Notes #6: Development Plan

**Date:** September 30, 2025

**Attendees:** Joven Poblete

**Purpose:** Create detailed week-by-week implementation roadmap

---

## Phase 1 Overview

**Duration:** 4 weeks

**Hours/Week:** 30-40 hours

**Approach:** Backend-first (complete API, then build frontend)

**Goal:** Ship production-ready admin MVP

---

## Key Decisions

### Backend-First Strategy

**Rationale:**

- Solid foundation - API fully tested before UI
- No context switching - focus on one layer at a time
- Better testing - can use Postman/Thunder Client
- Clear contracts - API shapes finalized before frontend
- Confidence - know everything works before building UI

### Timeline Breakdown

- **Weeks 1-2:** Complete backend (API + database)
- **Week 2.5:** API polish + frontend setup
- **Week 3:** Frontend core features
- **Week 4:** Frontend polish + production deployment

---

## Updated Schema Requirements

### User/Performer Relationship (CRITICAL)

**Discovery:** Owner is both admin AND performer

- Users can have MULTIPLE roles via array
- Example: `roles: ['admin', 'coordinator', 'performer']`
- Users can be linked to performer records via `performer_id`
- Performers can be linked to users via `user_id` (bidirectional)

**Phase 1:**

- Owner: User with all roles + linked to performer record
- External performers: Performer records without user accounts

**Phase 1.5:**

- Create user accounts for performers
- Link via `user_id`
- Enable performer portal

### Financial Model (REVISED)

**Two-Level Tracking:**

1. **Business Level (Admin View)**

   ```
   Revenue = Client payments
   Business Expenses = Performer payouts + Overhead
   Business Profit = Revenue - Expenses
   ```

2. **Performer Level (Personal View)**

   ```
   Gross Pay = Payouts received
   Personal Expenses = Gas, food, parking (own costs)
   Net Take-Home = Gross Pay - Personal Expenses
   ```

**Key Insight:** Performer expenses are NOT reimbursements. They are personal costs performers track for their own profit calculation.

### New Tables Added

1. **performer_expenses** (NEW)
   - Tracks performer personal gig costs
   - Separate from payouts
   - Phase 1: Admin can log for anyone
   - Phase 1.5: Performers log their own
2. **overhead_expenses** (BACK IN SCOPE)
   - Business-level costs (costumes, equipment, subscriptions)
   - Admin only
   - Categories: costumes, equipment, subscriptions, marketing, props, other

---

## Week-by-Week Plan

### Week 1: Backend Foundation

**Mon-Tue:** Project setup (monorepo, Docker, Drizzle)

**Wed-Thu:** Auth system (JWT, multi-role support)

**Fri-Sun:** Core CRUD (clients, packages, performers, inquiries, users)

**Milestone:** ✅ Auth + basic CRUD working, tested with Postman

---

### Week 2: Backend Workflow Logic

**Mon-Tue:** Bookings core + payments

**Wed-Thu:** Performer assignments + expenses

**Fri-Sun:** Business logic + reports

**Key Features:**

- Inquiry → Booking conversion
- Performer assignment with conflict detection
- Payment tracking (client payments)
- Payout tracking (performer payments)
- Performer expenses (personal costs)
- Overhead expenses (business costs)
- Financial reports (3 types: business, personal, all performers)
- Dashboard aggregations
- Calendar view
- Global search
- Notifications
- Audit log

**Milestone:** ✅ Complete API working, all endpoints tested

---

### Week 2.5: API Polish + Frontend Setup

**Mon-Tue:** API refinements (filters, pagination, export, Swagger, deploy to staging)

**Wed-Thu:** Frontend scaffolding (Vite, Vue, PrimeVue, router, stores, API client)

**Milestone:** ✅ API deployed to staging, Frontend ready to build

---

### Week 3: Frontend Core Features

**Mon-Tue:** Auth + Dashboard

**Wed-Thu:** Inquiries + Bookings

**Fri-Sun:** Performers, Expenses, Other Entities

**Key Screens:**

- Login
- Dashboard (widgets + stats)
- Inquiries list + forms
- Bookings list + forms
- Assign performers (with conflict warnings)
- Performer payouts
- Log performer expenses
- Overhead expenses
- Clients, Packages, Users CRUD

**Milestone:** ✅ All main screens working, can complete full workflow

---

### Week 4: Frontend Polish + Deployment

**Mon-Tue:** Calendar + Search

**Wed-Thu:** UX polish (loading, errors, confirmations, responsive)

**Fri:** Export + Testing

**Sat-Sun:** Production deployment (Railway + Cloudflare)

**Milestone:** 🚀 Production MVP live

---

## Financial Reporting (3 Types)

### 1. Business Financials (Admin Only)

```
Revenue: $12,500
  Deposits: $5,000
  Final Payments: $7,500

Business Expenses: $7,500
  Performer Payouts: $6,000
  Overhead Expenses: $1,500
    - Costumes: $800
    - Subscriptions: $400
    - Marketing: $300

Business Profit: $5,000
```

### 2. Performer Earnings (Per Performer)

```
Joven Poblete - October 2025

Gross Pay: $2,400 (12 gigs)
Personal Expenses: $650
  - Gas: $540
  - Food: $110
Net Take-Home: $1,750
```

### 3. All Performers Overview (Admin Only)

```
All Performers - October 2025

Joven Poblete
  Gross: $2,400
  Expenses: $650
  Net: $1,750

Alice Smith
  Gross: $1,800
  Expenses: $0 (not logged)
  Net: $1,800

Bob Johnson
  Gross: $1,600
  Expenses: $425
  Net: $1,175

Total Payouts: $6,000
Total Expenses Logged: $1,200
```

---

## Permissions Matrix

| Feature                   | Admin        | Coordinator | Performer (Phase 1.5) |
| ------------------------- | ------------ | ----------- | --------------------- |
| Manage Inquiries          | ✅           | ✅          | ❌                    |
| Manage Bookings           | ✅           | ✅          | ❌                    |
| Assign Performers         | ✅           | ✅          | ❌                    |
| View All Financials       | ✅           | ❌          | ❌                    |
| Log Overhead Expenses     | ✅           | ❌          | ❌                    |
| Log Any Performer Expense | ✅ (Phase 1) | ❌          | ❌                    |
| Log Own Performer Expense | ✅           | ❌          | ✅ (Phase 1.5)        |
| View Own Payouts/Expenses | ✅           | ❌          | ✅ (Phase 1.5)        |
| View Own Schedule         | ✅           | ❌          | ✅ (Phase 1.5)        |
| Manage Users              | ✅           | ❌          | ❌                    |

---

## Success Criteria

**End of Week 4:**

✅ Can log in with your account (admin + coordinator + performer)

✅ Can create inquiry → quote → booking

✅ Can assign performers (conflict detection works)

✅ Can record client payments

✅ Can track performer payouts

✅ Can log performer expenses (personal gig costs)

✅ Can log overhead expenses (business costs)

✅ Dashboard shows business profit

✅ Can view personal take-home

✅ Calendar shows bookings

✅ Search and filter work

✅ Can export to CSV

✅ Notifications work

✅ Deployed to production

✅ Accessible from any device

---

## Tech Stack (Finalized)

**Backend:**

- NestJS + TypeScript
- Drizzle ORM
- PostgreSQL
- Passport JWT
- BullMQ (job queues)

**Frontend:**

- Vite + Vue 3 SPA
- PrimeVue (UI components)
- Pinia (global UI state)
- Pinia Colada (server state/data fetching)
- TypeScript

**Infrastructure:**

- Railway (API + Database + Redis)
- Cloudflare Pages (Frontend)
- GitHub Actions (CI/CD)

**Repository:**

- Monorepo: `ohana-bookings` (API + Frontend)
- Turborepo + pnpm workspaces

---

## Risk Mitigation

**Potential Risks:**

1. **Scope creep** - Adding features during development
   - _Mitigation:_ Stick to the plan, document Phase 2 ideas
2. **Backend taking longer than 2 weeks**
   - _Mitigation:_ Use AI copilot, reference past NestJS project
3. **Complexity in financial calculations**
   - _Mitigation:_ Write tests for calc logic, validate with real scenarios
4. **Deployment issues**
   - _Mitigation:_ Deploy to staging early (Week 2.5), fix issues before production

---

## Next Actions

1. Set up development environment (Docker, monorepo)
2. Start Week 1: Project setup
3. Create GitHub repo
4. Begin backend implementation

---

**Status:** Ready to begin development 🚀
