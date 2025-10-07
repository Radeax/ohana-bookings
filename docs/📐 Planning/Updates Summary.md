# Updates Summary

## What Changed

Based on our Session 6 discussion, the following updates were made to reflect the correct user/performer model and expense tracking:

---

## Key Discovery

**Critical Insight:** The business owner (you) is BOTH an admin AND a performer.

This changes:

- User role model (can have multiple roles)
- Expense tracking model (need to track personal gig costs)
- Financial reporting (two levels: business + personal)

---

## Schema Changes

### 1. Users Table ✅ UPDATED

**Change:** `role` (single) → `roles` (array)

```sql
users
├── roles (text[], required)         -- Can have multiple: ['admin', 'coordinator', 'performer']
└── performer_id (uuid, nullable)  -- Link to performer record if user performs
```

**Examples:**

- You: `roles: ['admin', 'coordinator', 'performer']` + `performer_id` link
- Future coordinator: `roles: ['coordinator']`, `performer_id: null`
- Performer with login: `roles: ['performer']` + `performer_id` link

### 2. Performers Table ✅ UPDATED

**Change:** Added `user_id` for bidirectional link

```sql
performers
└── user_id (uuid, nullable)  -- Link to user account (Phase 1.5)
```

### 3. Booking_Performers Table ✅ SIMPLIFIED

**Change:** Removed expense fields (moved to separate table)

```sql
booking_performers
├── payout_amount (decimal)      -- What performer gets paid
├── paid (boolean)
├── paid_date (date, nullable)
└── payment_method (enum)
```

### 4. Performer_Expenses Table ✅ NEW

**Change:** New table for personal gig costs

```sql
performer_expenses
├── id (uuid, pk)
├── booking_performer_id (fk)   -- Which gig?
├── performer_id (fk)            -- Which performer?
├── amount (decimal)             -- Total expenses
├── description (text)           -- "Gas $45, dinner $30"
├── expense_date (date)
├── receipt_photo_url (Phase 2)
└── created_by (fk → users)
```

**Purpose:** Track performer personal costs (NOT business reimbursements)

**Permissions:**

- Phase 1: Admins can log for any performer
- Phase 1.5: Performers can log their own only

### 5. Overhead_Expenses Table ✅ BACK IN SCOPE

**Change:** Was removed, now back in

```sql
overhead_expenses
├── id (uuid, pk)
├── description (required)       -- "New costume", "GigSalad subscription"
├── amount (decimal)
├── category (enum)              -- costumes, equipment, subscriptions, marketing, props, other
├── expense_date (date)
├── payment_method (enum)
└── created_by (fk → users)
```

**Purpose:** Business-level costs (not per-gig)

---

## API Changes

### New Endpoints ✅ ADDED

**Performer Expenses:**

```
GET    /api/performer-expenses
GET    /api/performer-expenses/:id
POST   /api/performer-expenses
PATCH  /api/performer-expenses/:id
DELETE /api/performer-expenses/:id
```

**Overhead Expenses:**

```
GET    /api/overhead-expenses
GET    /api/overhead-expenses/:id
POST   /api/overhead-expenses
PATCH  /api/overhead-expenses/:id
DELETE /api/overhead-expenses/:id
```

### Updated Endpoints ✅ MODIFIED

**Financial Reports (3 types now):**

```
GET /api/reports/business-financials
  Returns: revenue, business expenses, business profit

GET /api/reports/performer-earnings/:performerId
  Returns: gross pay, personal expenses, net take-home

GET /api/reports/all-performers-earnings
  Returns: all performers summary (admin only)
```

---

## Financial Model Changes

### Old Model ❌

```
Revenue - Expenses = Profit
```

### New Model ✅

**Business Level (Admin View):**

```
Revenue = Client payments (deposits + finals)

Business Expenses =
  - Performer payouts (what you pay out)
  - Overhead expenses (costumes, equipment, subscriptions)

Business Profit = Revenue - Business Expenses
```

**Performer Level (Personal View):**

```
Gross Pay = Sum of payouts from bookings

Personal Expenses = Gas, food, parking (own costs)

Net Take-Home = Gross Pay - Personal Expenses
```

**Key Difference:** Performer expenses are personal costs (for their own tracking), NOT business reimbursements.

---

## Use Cases

### Use Case 1: You Perform at a Wedding

1. Admin assigns you to booking
2. Set `payout_amount = $200`
3. After the gig, you log expense: "Gas $45, dinner $30" = $75
4. Your dashboard shows:
   - Gross: $200
   - Expenses: $75
   - Net: $125
5. Business sees: Payout expense = $200

### Use Case 2: External Performer (Phase 1)

1. Admin assigns Alice to booking
2. Set `payout_amount = $200`
3. Alice performs, you pay her $200
4. Alice doesn't log expenses (no login yet)
5. Business sees: Payout expense = $200

### Use Case 3: Buy New Costumes

1. You buy costumes for $800
2. Log overhead expense: "New Polynesian costumes" = $800
3. Business expenses increase by $800
4. This affects business profit, not performer take-home

---

## Documents Updated

✅ **Complete Database Schema** - Updated all tables, added new ones

✅ **Complete API Specification** - Added new endpoints, updated reports

✅ **MVP Feature List** - Fixed duplicate content, clarified multi-role support

✅ **Session 6: Development Plan** - Created with backend-first approach

✅ **Meeting Notes #6** - Professional summary of Session 6

✅ **Planning Archive** - Moved Session 1-5 documents, organized meeting notes

✅ **Project Context** - Updated with correct tech stack and financial model

---

## Ready to Start

**Next Steps:**

1. Review Session 6: Development Plan
2. Set up development environment
3. Begin Week 1: Backend foundation

**You now have:**

- ✅ Complete database schema
- ✅ Complete API specification
- ✅ Week-by-week development plan
- ✅ All ADRs documenting tech decisions
- ✅ Clear understanding of user/performer model
- ✅ Clean Notion workspace

**Let's build! 🚀**
