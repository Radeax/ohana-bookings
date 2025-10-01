# Project Context

## Business Overview

**Ohana of Polynesia** is a Polynesian entertainment company providing cultural dance performances for events in the Washington DC metro area.

### Services

- Polynesian variety shows featuring dances from Hawaii, Tahiti, New Zealand, Fiji, and Samoa
- Typical performance duration: 45-60 minutes
- Optional fire performance (budget and venue dependent)
- Customizable packages for different event types

### Current Scale

- **Bookings:** ~40-60 per year (rebuilding phase after dormancy)
- **Performers:** 3-4 active contractors
- **Clients:** 1 repeat client currently, seasonal inquiries increasing
- **Team:** Solo operator (admin/coordinator), planning to add 1 additional coordinator

### Event Types

- Weddings, corporate events, festivals
- Birthdays, retirement homes, anniversaries
- Annual gatherings, special occasions

---

## The Problem

**Current State:** Operations managed through fragmented systems

- Google Sheets (booking tracking)
- Email and text messages (performer coordination)
- GigSalad/The Bash inboxes (inquiry management)
- PayPal invoicing (payments)

**Pain Points:**

1. **Forgetting inquiries** - No centralized tracking, inquiries stay in original inboxes
2. **Time-consuming bookkeeping** - Manual financial tracking in spreadsheets
3. **Manual performer coordination** - Texting individuals to check availability
4. **Risk of double-booking** - No conflict detection
5. **Scattered data** - No single source of truth

**Business Impact:**

- Lost opportunities from missed follow-ups
- Administrative overhead reduces time for business growth
- Potential scheduling conflicts
- Difficult to see financial performance

---

## The Solution

**Vision:** A centralized booking management system that serves as the single source of truth for inquiries, bookings, performers, and financials.

### Primary Goals

1. **Never miss an inquiry** - Centralized tracking with notifications
2. **Streamline bookings** - Simple workflow from inquiry to confirmed event
3. **Financial clarity** - Track payments, payouts, revenue, and profit automatically
4. **Efficient coordination** - Digital performer assignment and availability

### Success Metrics (6 months)

- ✅ All bookings managed through the app (zero Google Sheets reliance)
- ✅ Zero double-bookings or missed performer assignments
- ✅ Improved inquiry response time (< 24 hours)
- ✅ Clear financial visibility without manual spreadsheet work
- ✅ Positive feedback from admin users and performers

---

## User Roles

### Phase 1

- **Admin** - Full access (manage everything, view financials)
- **Coordinator** - Booking management (no financial access)

### Phase 1.5

- **Performer** - View schedule, mark availability, see assigned gigs

---

## Key Workflows

### Inquiry to Booking

1. Inquiry received (manual entry from any source)
2. Admin quotes client (can use standard package)
3. **Check performer availability** (critical: must confirm before taking deposit)
4. Performers confirm availability
5. Client pays deposit → Booking created
6. Event details sent to performers
7. Event occurs
8. Final payment collected

### Financial Tracking

**Business Level (Admin View):**

- **Revenue:** Client deposits + final payments
- **Business Expenses:**
    - Performer payouts (what you pay out to all performers)
    - Overhead expenses (costumes, equipment, subscriptions, marketing)
- **Business Profit:** Revenue - Business Expenses

**Performer Level (Personal View):**

- **Gross Pay:** Total payouts received from gigs
- **Personal Expenses:** Gas, food, parking (own costs for gigs)
- **Net Take-Home:** Gross Pay - Personal Expenses

**Key Insight:** Performer expenses are NOT business reimbursements. They are personal costs that performers track to understand their true profit from gigs.

**Example:**

- You perform at a wedding, get paid $200 (payout)
- You spend $75 on gas and dinner (personal expense)
- Your net take-home is $125
- The business paid out $200 (business expense)

### Financial Tracking

**Business Level (Admin View):**

- **Revenue:** Client deposits + final payments
- **Business Expenses:**
    - Performer payouts (what you pay out to all performers)
    - Overhead expenses (costumes, equipment, subscriptions, marketing)
- **Business Profit:** Revenue - Business Expenses

**Performer Level (Personal View):**

- **Gross Pay:** Total payouts received from gigs
- **Personal Expenses:** Gas, food, parking (own costs for gigs)
- **Net Take-Home:** Gross Pay - Personal Expenses

**Key Insight:** Performer expenses are NOT business reimbursements. They are personal costs that performers track to understand their true profit from gigs.

**Example:**

- You perform at a wedding, get paid $200 (payout)
- You spend $75 on gas and dinner (personal expense)
- Your net take-home is $125
- The business paid out $200 (business expense)

---

## Technical Context

### Why We're Building This

1. **Resume building** - Modern tech stack demonstrates current skills
2. **Solve real problem** - Actual business need, not a toy project
3. **Solo developer showcase** - Full-stack capability demonstration
4. **Scalable foundation** - Can grow with business

### Tech Stack

**Backend:**

- NestJS (TypeScript)
- Drizzle ORM
- PostgreSQL
- JWT authentication (Passport)
- BullMQ (job queues)

**Frontend:**

- Vite + Vue 3 SPA
- PrimeVue (UI components)
- Pinia (global UI state)
- Pinia Colada (server state/data fetching)
- TypeScript

**Infrastructure:**

- Railway (API + Database)
- Cloudflare Pages (Frontend)

**Repository:**

- Monorepo: `ohana-bookings` (API + Frontend + shared packages)
- Separate: `ohana-marketing` (future public website)

---

## Project Timeline

**Phase 1: Admin Foundation** (4 weeks)

- Core CRUD operations
- Inquiry → Booking workflow
- Payment tracking
- Dashboard and calendar
- Manual performer coordination

**Phase 1.5: Performer Portal** (2 weeks)

- Performer logins
- Availability calendar
- Gig assignments
- Email notifications

**Phase 2+: Future Enhancements**

- Website inquiry form integration
- GigSalad/The Bash API integration
- Automated quote generation
- SMS notifications
- Advanced reporting

---

## Reference Documents

- [MVP Feature List](./MVP-Feature-List.md) - Detailed feature breakdown
- [Database Schema](./Complete-Database-Schema.md) - Full data model
- [API Specification](./Complete-API-Specification.md) - All endpoints
- [Architecture Decision Records](./Architecture-Decision-Records-ADRs/) - Technical decisions

---

## Business Context

**Why Ohana is Rebuilding:**

The business went dormant for several years (owner disregarded inquiries). Now actively rebuilding with:

- 1 repeat client
- Seasonal inquiries returning
- Focused effort on professional operations
- Investment in proper systems

**Market Position:**

- Compete on GigSalad/The Bash (competitive bidding platforms)
- 20% conversion on platform leads
- 60% conversion on direct inquiries
- Differentiation through professional service and reliability