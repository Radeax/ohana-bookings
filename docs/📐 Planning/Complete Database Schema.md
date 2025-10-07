# Complete Database Schema

# Complete Database Schema - Ohana Booking System

## Design Principles

- **Multi-role users:** Users can have multiple roles (admin + coordinator + performer)
- **User-performer link:** Users can be linked to performer records when they perform
- **Separate expense tracking:** Business overhead expenses vs. performer personal expenses
- **Audit trail:** Track who did what and when
- **Denormalization where it makes sense:** Store client info on bookings for stability
- **Financial clarity:** Three levels of financial tracking (revenue, business expenses, performer personal expenses)

---

## 1. Users Table

**Purpose:** System users (admins, coordinators, performers with login access)

**Key Change:** Users can have MULTIPLE roles via array

```sql
users
├─ id (uuid, pk)
├─ email (unique, required)
├─ password_hash (required)
├─ first_name (required)
├─ last_name (required)
├─ phone (nullable)
├─ roles (text[], required)              -- ['admin'], ['coordinator'], ['admin', 'coordinator', 'performer'], etc.
├─ performer_id (uuid, fk → [performers.id](http://performers.id), nullable)  -- Link to performer record if user performs
├─ is_active (boolean, default: true)
├─ last_login_at (timestamp, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Role Definitions:**

- `admin` - Full access including financials
- `coordinator` - Booking management, no financial access
- `performer` - View own schedule and gigs (Phase 1.5)

**Examples:**

- You: `roles: ['admin', 'coordinator', 'performer']` + `performer_id` links to your performer record
- Future coordinator: `roles: ['coordinator']`, `performer_id: null`
- External performer with login: `roles: ['performer']` + `performer_id` links to their record

**Indexes:**

- `email` (unique)
- `performer_id`
- `roles` (GIN index for array queries)

---

## 2. Performers Table

**Purpose:** Performer roster (contractors who perform at events)

**Key Change:** Added `user_id` to link performers to user accounts

```sql
performers
├─ id (uuid, pk)
├─ user_id (uuid, fk → [users.id](http://users.id), nullable)  -- NULL in Phase 1, linked in Phase 1.5 when they get login
├─ first_name (required)
├─ last_name (required)
├─ email (nullable)
├─ phone (nullable)
├─ skills (jsonb, nullable)                 -- ["hula", "tahitian", "fire_knife", etc.]
├─ default_rate (decimal, nullable)
├─ is_active (boolean, default: true)
├─ notes (text, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Skills enum:** hula, tahitian, maori, fijian, samoan, fire_knife, fire_poi, fire_staff

**Indexes:**

- `is_active`
- `user_id`

---

## 3. Clients Table

**Purpose:** Reusable client records for repeat customers

```sql
clients
├─ id (uuid, pk)
├─ name (required)
├─ email (required)
├─ phone (nullable)
├─ company (nullable)
├─ notes (text, nullable)
├─ is_repeat_client (boolean, default: false)
├─ total_bookings (integer, default: 0)    -- calculated
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `email`
- `is_repeat_client`

---

## 4. Packages Table

**Purpose:** Predefined service offerings with default pricing

```sql
packages
├─ id (uuid, pk)
├─ name (required)                          -- e.g., "Basic Show", "Fire Performance Add-On"
├─ description (text, nullable)
├─ default_price (decimal, required)
├─ duration_minutes (integer, nullable)
├─ min_performers (integer, default: 1)
├─ max_performers (integer, nullable)
├─ includes_fire (boolean, default: false)
├─ is_active (boolean, default: true)
├─ display_order (integer, default: 0)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `is_active, display_order`

---

## 5. Inquiries Table

**Purpose:** Track every potential client from first contact

```sql
inquiries
├─ id (uuid, pk)
├─ client_id (uuid, fk → [clients.id](http://clients.id), nullable)
├─ client_name (required)                   -- denormalized
├─ client_email (required)
├─ client_phone (nullable)
├─ client_company (nullable)
├─ event_date (date, required)
├─ event_time (time, nullable)
├─ event_type (enum: 'wedding', 'corporate', 'festival', 'birthday', 'retirement', 'anniversary', 'gathering', 'other')
├─ location_city (required)
├─ location_venue (nullable)
├─ location_address (text, nullable)        -- full address optional at inquiry stage
├─ status (enum: 'new', 'quoted', 'confirmed', 'lost')
├─ source (enum: 'gigsalad', 'thebash', 'email', 'phone', 'referral', 'website', 'other')
├─ notes (text, nullable)
├─ lost_reason (text, nullable)             -- required if status = 'lost'
├─ created_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `status, event_date`
- `client_id`
- `created_at`

---

## 6. Quote_History Table

**Purpose:** Track all quotes sent for an inquiry

```sql
quote_history
├─ id (uuid, pk)
├─ inquiry_id (uuid, fk → [inquiries.id](http://inquiries.id), required)
├─ package_id (uuid, fk → [packages.id](http://packages.id), nullable)
├─ quoted_amount (decimal, required)
├─ quoted_package_name (string, nullable)   -- denormalized
├─ notes (text, nullable)
├─ quoted_by (uuid, fk → [users.id](http://users.id), required)
├─ quoted_at (timestamp, required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `inquiry_id, quoted_at`

---

## 7. Bookings Table

**Purpose:** Confirmed events with deposit paid

```sql
bookings
├─ id (uuid, pk)
├─ inquiry_id (uuid, fk → [inquiries.id](http://inquiries.id), required)
├─ client_id (uuid, fk → [clients.id](http://clients.id), nullable)
├─ -- Denormalized client info
├─ client_name (required)
├─ client_email (required)
├─ client_phone (nullable)
├─ client_company (nullable)
├─ -- Event details
├─ event_date (date, required)
├─ event_start_time (time, required)
├─ event_end_time (time, nullable)
├─ event_type (enum: same as inquiries)
├─ location_address (text, required)
├─ location_city (required)
├─ location_venue (nullable)
├─ -- Pricing
├─ package_id (uuid, fk → [packages.id](http://packages.id), nullable)
├─ package_name (string, nullable)
├─ total_price (decimal, required)
├─ -- Deposit tracking
├─ deposit_amount (decimal, required)
├─ deposit_paid (boolean, default: false)
├─ deposit_paid_date (date, nullable)
├─ deposit_payment_method (enum: 'check', 'venmo', 'paypal', 'cash', 'zelle', 'gigsalad', 'thebash', 'other')
├─ -- Final payment tracking
├─ final_payment_amount (decimal, required)
├─ final_payment_paid (boolean, default: false)
├─ final_payment_paid_date (date, nullable)
├─ final_payment_method (enum: same as deposit)
├─ -- Invoice tracking
├─ invoice_sent (boolean, default: false)
├─ invoice_sent_date (date, nullable)
├─ -- Other
├─ special_requests (text, nullable)
├─ status (enum: 'pending', 'confirmed', 'completed', 'cancelled')
├─ cancellation_reason (text, nullable)
├─ created_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `event_date, status`
- `client_id`
- `deposit_paid, deposit_paid_date`
- `final_payment_paid, final_payment_paid_date`

**Calculated:** `balance_owed = total_price - (deposit_paid ? deposit_amount : 0) - (final_payment_paid ? final_payment_amount : 0)`

---

## 8. Booking_Performers Table

**Purpose:** Many-to-many relationship + payout tracking

**Key Change:** Simplified - only payout info, expenses tracked separately

```sql
booking_performers
├─ id (uuid, pk)
├─ booking_id (uuid, fk → [bookings.id](http://bookings.id), required)
├─ performer_id (uuid, fk → [performers.id](http://performers.id), required)
├─ payout_amount (decimal, required)       -- What performer gets paid
├─ paid (boolean, default: false)          -- Has performer been paid?
├─ paid_date (date, nullable)
├─ payment_method (enum: 'check', 'venmo', 'cash', 'zelle', 'paypal', 'other')
├─ notes (text, nullable)
├─ assigned_at (timestamp, required)
├─ assigned_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `booking_id`
- `performer_id, booking_id` (unique)
- `paid`

**Unique Constraint:** `(booking_id, performer_id)`

---

## 9. Performer_Expenses Table (NEW)

**Purpose:** Track performer personal expenses (gas, food, etc.) - NOT business reimbursements

**Key Point:** These are the performer's own costs they want to track for their net profit calculation

```sql
performer_expenses
├─ id (uuid, pk)
├─ booking_performer_id (uuid, fk → booking_[performers.id](http://performers.id), required)  -- Which gig?
├─ performer_id (uuid, fk → [performers.id](http://performers.id), required)                  -- Redundant but useful
├─ amount (decimal, required)                                          -- Total expenses
├─ description (text, required)                                        -- "Gas $45, dinner $30, parking $10"
├─ expense_date (date, required)                                       -- Usually = event date
├─ receipt_photo_url (text, nullable)                                  -- Phase 2: Upload receipts
├─ created_by (uuid, fk → [users.id](http://users.id), required)                         -- Who logged this
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `booking_performer_id`
- `performer_id, expense_date`
- `created_by`

**Permissions:**

- Phase 1: Admins can log expenses for any performer
- Phase 1.5: Performers can log their own expenses only

---

## 10. Overhead_Expenses Table

**Purpose:** Business-level expenses (costumes, equipment, subscriptions)

**Key Point:** These are business costs, not per-gig or per-performer

```sql
overhead_expenses
├─ id (uuid, pk)
├─ description (required)                   -- "New costume", "GigSalad subscription Sept"
├─ amount (decimal, required)
├─ category (enum: 'costumes', 'equipment', 'subscriptions', 'marketing', 'props', 'other')
├─ expense_date (date, required)
├─ payment_method (enum: 'paypal', 'credit_card', 'cash', 'check', 'other')
├─ receipt_photo_url (text, nullable)       -- Phase 2: Upload receipts
├─ notes (text, nullable)
├─ created_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `expense_date`
- `category`

---

## 11. Notifications Table

**Purpose:** In-app alerts

```sql
notifications
├─ id (uuid, pk)
├─ user_id (uuid, fk → [users.id](http://users.id), required)
├─ type (enum: 'new_inquiry', 'follow_up_reminder', 'deposit_overdue', 'event_reminder', 'performer_assigned', 'booking_cancelled')
├─ title (required)
├─ message (text, required)
├─ action_url (string, nullable)
├─ related_inquiry_id (uuid, fk → [inquiries.id](http://inquiries.id), nullable)
├─ related_booking_id (uuid, fk → [bookings.id](http://bookings.id), nullable)
├─ is_read (boolean, default: false)
├─ read_at (timestamp, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `user_id, is_read, created_at`
- `type`

---

## 12. Performer_Availability Table (Phase 1.5)

**Purpose:** Performers mark dates available/unavailable

```sql
performer_availability
├─ id (uuid, pk)
├─ performer_id (uuid, fk → [performers.id](http://performers.id), required)
├─ date (date, required)
├─ status (enum: 'available', 'unavailable', 'tentative')
├─ notes (text, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `performer_id, date` (unique)
- `date, status`

---

## 13. Audit_Log Table

**Purpose:** Track significant changes

```sql
audit_log
├─ id (uuid, pk)
├─ user_id (uuid, fk → [users.id](http://users.id), required)
├─ action (enum: 'create', 'update', 'delete', 'status_change', 'payment_recorded')
├─ entity_type (enum: 'inquiry', 'booking', 'performer', 'expense', 'user')
├─ entity_id (uuid, required)
├─ changes (jsonb, nullable)                -- {"field": {"old": "value", "new": "value"}}
├─ ip_address (string, nullable)
├─ user_agent (string, nullable)
├─ created_at (timestamp)
```

**Indexes:**

- `entity_type, entity_id, created_at`
- `user_id, created_at`

---

## Relationships Summary

```
users ──┬─→ inquiries (created_by)
        ├─→ bookings (created_by)
        ├─→ quote_history (quoted_by)
        ├─→ booking_performers (assigned_by)
        ├─→ performer_expenses (created_by)
        ├─→ overhead_expenses (created_by)
        ├─→ notifications (user_id)
        ├─→ audit_log (user_id)
        └─→ performers (user_id, bidirectional link)

performers ──┬─→ booking_performers
             ├─→ performer_expenses
             ├─→ performer_availability (Phase 1.5)
             └─→ users (user_id)

clients ──┬─→ inquiries
          └─→ bookings

packages ──┬─→ quote_history
           └─→ bookings

inquiries ──┬─→ quote_history
            └─→ bookings

bookings ──┬─→ booking_performers
           └─→ notifications

booking_performers ──→ performer_expenses
```

---

## Financial Calculations

### Business Level (Admin View)

**Revenue:**

```sql
SELECT
  SUM(deposit_amount) FILTER (WHERE deposit_paid = true) +
  SUM(final_payment_amount) FILTER (WHERE final_payment_paid = true)
FROM bookings
WHERE event_date BETWEEN :start_date AND :end_date
```

**Business Expenses:**

```sql
-- Performer payouts
SELECT SUM(payout_amount)
FROM booking_performers
WHERE paid = true
  AND booking_id IN (
    SELECT id FROM bookings
    WHERE event_date BETWEEN :start_date AND :end_date
  )

-- Overhead expenses
SELECT SUM(amount)
FROM overhead_expenses
WHERE expense_date BETWEEN :start_date AND :end_date
```

**Business Profit:**

```
Profit = Revenue - (Performer Payouts + Overhead Expenses)
```

### Performer Level (Personal View)

**Performer's Gross Pay:**

```sql
SELECT SUM(bp.payout_amount)
FROM booking_performers bp
JOIN bookings b ON [bp.booking](http://bp.booking)_id = [b.id](http://b.id)
WHERE bp.performer_id = :performer_id
  AND bp.paid = true
  AND b.event_date BETWEEN :start_date AND :end_date
```

**Performer's Personal Expenses:**

```sql
SELECT SUM(amount)
FROM performer_expenses
WHERE performer_id = :performer_id
  AND expense_date BETWEEN :start_date AND :end_date
```

**Performer's Net Take-Home:**

```
Net = Gross Pay - Personal Expenses
```

---

## Key Changes from Original Schema

✅ **users.roles** - Array instead of single role

✅ **users.performer_id** - Link to performer record

✅ **performers.user_id** - Bidirectional link

✅ **performer_expenses** - NEW table for personal gig costs

✅ **overhead_expenses** - Renamed from "expenses", clearer purpose

✅ **booking_performers** - Simplified, no expense fields

---

## Migration Path

Phase 1 → Phase 1.5:

- Create user accounts for performers
- Link `performers.user_id` to new user records
- Add `'performer'` to their `users.roles` array
- Enable performer portal features

# Complete Database Schema - Ohana Booking System

## Design Principles

- **Multi-role users:** Users can have multiple roles (admin + coordinator + performer)
- **User-performer link:** Users can be linked to performer records when they perform
- **Separate expense tracking:** Business overhead expenses vs. performer personal expenses
- **Audit trail:** Track who did what and when
- **Denormalization where it makes sense:** Store client info on bookings for stability
- **Financial clarity:** Three levels of financial tracking (revenue, business expenses, performer personal expenses)

---

## 1. Users Table

**Purpose:** System users (admins, coordinators, performers with login access)

**Key Change:** Users can have MULTIPLE roles via array

```sql
users
├─ id (uuid, pk)
├─ email (unique, required)
├─ password_hash (required)
├─ first_name (required)
├─ last_name (required)
├─ phone (nullable)
├─ roles (text[], required)              -- ['admin'], ['coordinator'], ['admin', 'coordinator', 'performer'], etc.
├─ performer_id (uuid, fk → [performers.id](http://performers.id), nullable)  -- Link to performer record if user performs
├─ is_active (boolean, default: true)
├─ last_login_at (timestamp, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Role Definitions:**

- `admin` - Full access including financials
- `coordinator` - Booking management, no financial access
- `performer` - View own schedule and gigs (Phase 1.5)

**Examples:**

- You: `roles: ['admin', 'coordinator', 'performer']` + `performer_id` links to your performer record
- Future coordinator: `roles: ['coordinator']`, `performer_id: null`
- External performer with login: `roles: ['performer']` + `performer_id` links to their record

**Indexes:**

- `email` (unique)
- `performer_id`
- `roles` (GIN index for array queries)

---

## 2. Performers Table

**Purpose:** Performer roster (contractors who perform at events)

**Key Change:** Added `user_id` to link performers to user accounts

```sql
performers
├─ id (uuid, pk)
├─ user_id (uuid, fk → [users.id](http://users.id), nullable)  -- NULL in Phase 1, linked in Phase 1.5 when they get login
├─ first_name (required)
├─ last_name (required)
├─ email (nullable)
├─ phone (nullable)
├─ skills (jsonb, nullable)                 -- ["hula", "tahitian", "fire_knife", etc.]
├─ default_rate (decimal, nullable)
├─ is_active (boolean, default: true)
├─ notes (text, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Skills enum:** hula, tahitian, maori, fijian, samoan, fire_knife, fire_poi, fire_staff

**Indexes:**

- `is_active`
- `user_id`

---

## 3. Clients Table

**Purpose:** Reusable client records for repeat customers

```sql
clients
├─ id (uuid, pk)
├─ name (required)
├─ email (required)
├─ phone (nullable)
├─ company (nullable)
├─ notes (text, nullable)
├─ is_repeat_client (boolean, default: false)
├─ total_bookings (integer, default: 0)    -- calculated
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `email`
- `is_repeat_client`

---

## 4. Packages Table

**Purpose:** Predefined service offerings with default pricing

```sql
packages
├─ id (uuid, pk)
├─ name (required)                          -- e.g., "Basic Show", "Fire Performance Add-On"
├─ description (text, nullable)
├─ default_price (decimal, required)
├─ duration_minutes (integer, nullable)
├─ min_performers (integer, default: 1)
├─ max_performers (integer, nullable)
├─ includes_fire (boolean, default: false)
├─ is_active (boolean, default: true)
├─ display_order (integer, default: 0)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `is_active, display_order`

---

## 5. Inquiries Table

**Purpose:** Track every potential client from first contact

```sql
inquiries
├─ id (uuid, pk)
├─ client_id (uuid, fk → [clients.id](http://clients.id), nullable)
├─ client_name (required)                   -- denormalized
├─ client_email (required)
├─ client_phone (nullable)
├─ client_company (nullable)
├─ event_date (date, required)
├─ event_time (time, nullable)
├─ event_type (enum: 'wedding', 'corporate', 'festival', 'birthday', 'retirement', 'anniversary', 'gathering', 'other')
├─ location_city (required)
├─ location_venue (nullable)
├─ location_address (text, nullable)        -- full address optional at inquiry stage
├─ status (enum: 'new', 'quoted', 'confirmed', 'lost')
├─ source (enum: 'gigsalad', 'thebash', 'email', 'phone', 'referral', 'website', 'other')
├─ notes (text, nullable)
├─ lost_reason (text, nullable)             -- required if status = 'lost'
├─ created_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `status, event_date`
- `client_id`
- `created_at`

---

## 6. Quote_History Table

**Purpose:** Track all quotes sent for an inquiry

```sql
quote_history
├─ id (uuid, pk)
├─ inquiry_id (uuid, fk → [inquiries.id](http://inquiries.id), required)
├─ package_id (uuid, fk → [packages.id](http://packages.id), nullable)
├─ quoted_amount (decimal, required)
├─ quoted_package_name (string, nullable)   -- denormalized
├─ notes (text, nullable)
├─ quoted_by (uuid, fk → [users.id](http://users.id), required)
├─ quoted_at (timestamp, required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `inquiry_id, quoted_at`

---

## 7. Bookings Table

**Purpose:** Confirmed events with deposit paid

```sql
bookings
├─ id (uuid, pk)
├─ inquiry_id (uuid, fk → [inquiries.id](http://inquiries.id), required)
├─ client_id (uuid, fk → [clients.id](http://clients.id), nullable)
├─ -- Denormalized client info
├─ client_name (required)
├─ client_email (required)
├─ client_phone (nullable)
├─ client_company (nullable)
├─ -- Event details
├─ event_date (date, required)
├─ event_start_time (time, required)
├─ event_end_time (time, nullable)
├─ event_type (enum: same as inquiries)
├─ location_address (text, required)
├─ location_city (required)
├─ location_venue (nullable)
├─ -- Pricing
├─ package_id (uuid, fk → [packages.id](http://packages.id), nullable)
├─ package_name (string, nullable)
├─ total_price (decimal, required)
├─ -- Deposit tracking
├─ deposit_amount (decimal, required)
├─ deposit_paid (boolean, default: false)
├─ deposit_paid_date (date, nullable)
├─ deposit_payment_method (enum: 'check', 'venmo', 'paypal', 'cash', 'zelle', 'gigsalad', 'thebash', 'other')
├─ -- Final payment tracking
├─ final_payment_amount (decimal, required)
├─ final_payment_paid (boolean, default: false)
├─ final_payment_paid_date (date, nullable)
├─ final_payment_method (enum: same as deposit)
├─ -- Invoice tracking
├─ invoice_sent (boolean, default: false)
├─ invoice_sent_date (date, nullable)
├─ -- Other
├─ special_requests (text, nullable)
├─ status (enum: 'pending', 'confirmed', 'completed', 'cancelled')
├─ cancellation_reason (text, nullable)
├─ created_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `event_date, status`
- `client_id`
- `deposit_paid, deposit_paid_date`
- `final_payment_paid, final_payment_paid_date`

**Calculated:** `balance_owed = total_price - (deposit_paid ? deposit_amount : 0) - (final_payment_paid ? final_payment_amount : 0)`

---

## 8. Booking_Performers Table

**Purpose:** Many-to-many relationship + payout tracking

**Key Change:** Simplified - only payout info, expenses tracked separately

```sql
booking_performers
├─ id (uuid, pk)
├─ booking_id (uuid, fk → [bookings.id](http://bookings.id), required)
├─ performer_id (uuid, fk → [performers.id](http://performers.id), required)
├─ payout_amount (decimal, required)       -- What performer gets paid
├─ paid (boolean, default: false)          -- Has performer been paid?
├─ paid_date (date, nullable)
├─ payment_method (enum: 'check', 'venmo', 'cash', 'zelle', 'paypal', 'other')
├─ notes (text, nullable)
├─ assigned_at (timestamp, required)
├─ assigned_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `booking_id`
- `performer_id, booking_id` (unique)
- `paid`

**Unique Constraint:** `(booking_id, performer_id)`

---

## 9. Performer_Expenses Table (NEW)

**Purpose:** Track performer personal expenses (gas, food, etc.) - NOT business reimbursements

**Key Point:** These are the performer's own costs they want to track for their net profit calculation

```sql
performer_expenses
├─ id (uuid, pk)
├─ booking_performer_id (uuid, fk → booking_[performers.id](http://performers.id), required)  -- Which gig?
├─ performer_id (uuid, fk → [performers.id](http://performers.id), required)                  -- Redundant but useful
├─ amount (decimal, required)                                          -- Total expenses
├─ description (text, required)                                        -- "Gas $45, dinner $30, parking $10"
├─ expense_date (date, required)                                       -- Usually = event date
├─ receipt_photo_url (text, nullable)                                  -- Phase 2: Upload receipts
├─ created_by (uuid, fk → [users.id](http://users.id), required)                         -- Who logged this
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `booking_performer_id`
- `performer_id, expense_date`
- `created_by`

**Permissions:**

- Phase 1: Admins can log expenses for any performer
- Phase 1.5: Performers can log their own expenses only

---

## 10. Overhead_Expenses Table

**Purpose:** Business-level expenses (costumes, equipment, subscriptions)

**Key Point:** These are business costs, not per-gig or per-performer

```sql
overhead_expenses
├─ id (uuid, pk)
├─ description (required)                   -- "New costume", "GigSalad subscription Sept"
├─ amount (decimal, required)
├─ category (enum: 'costumes', 'equipment', 'subscriptions', 'marketing', 'props', 'other')
├─ expense_date (date, required)
├─ payment_method (enum: 'paypal', 'credit_card', 'cash', 'check', 'other')
├─ receipt_photo_url (text, nullable)       -- Phase 2: Upload receipts
├─ notes (text, nullable)
├─ created_by (uuid, fk → [users.id](http://users.id), required)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `expense_date`
- `category`

---

## 11. Notifications Table

**Purpose:** In-app alerts

```sql
notifications
├─ id (uuid, pk)
├─ user_id (uuid, fk → [users.id](http://users.id), required)
├─ type (enum: 'new_inquiry', 'follow_up_reminder', 'deposit_overdue', 'event_reminder', 'performer_assigned', 'booking_cancelled')
├─ title (required)
├─ message (text, required)
├─ action_url (string, nullable)
├─ related_inquiry_id (uuid, fk → [inquiries.id](http://inquiries.id), nullable)
├─ related_booking_id (uuid, fk → [bookings.id](http://bookings.id), nullable)
├─ is_read (boolean, default: false)
├─ read_at (timestamp, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `user_id, is_read, created_at`
- `type`

---

## 12. Performer_Availability Table (Phase 1.5)

**Purpose:** Performers mark dates available/unavailable

```sql
performer_availability
├─ id (uuid, pk)
├─ performer_id (uuid, fk → [performers.id](http://performers.id), required)
├─ date (date, required)
├─ status (enum: 'available', 'unavailable', 'tentative')
├─ notes (text, nullable)
├─ created_at (timestamp)
└─ updated_at (timestamp)
```

**Indexes:**

- `performer_id, date` (unique)
- `date, status`

---

## 13. Audit_Log Table

**Purpose:** Track significant changes

```sql
audit_log
├─ id (uuid, pk)
├─ user_id (uuid, fk → [users.id](http://users.id), required)
├─ action (enum: 'create', 'update', 'delete', 'status_change', 'payment_recorded')
├─ entity_type (enum: 'inquiry', 'booking', 'performer', 'expense', 'user')
├─ entity_id (uuid, required)
├─ changes (jsonb, nullable)                -- {"field": {"old": "value", "new": "value"}}
├─ ip_address (string, nullable)
├─ user_agent (string, nullable)
├─ created_at (timestamp)
```

**Indexes:**

- `entity_type, entity_id, created_at`
- `user_id, created_at`

---

## Relationships Summary

```
users ──┬─→ inquiries (created_by)
        ├─→ bookings (created_by)
        ├─→ quote_history (quoted_by)
        ├─→ booking_performers (assigned_by)
        ├─→ performer_expenses (created_by)
        ├─→ overhead_expenses (created_by)
        ├─→ notifications (user_id)
        ├─→ audit_log (user_id)
        └─→ performers (user_id, bidirectional link)

performers ──┬─→ booking_performers
             ├─→ performer_expenses
             ├─→ performer_availability (Phase 1.5)
             └─→ users (user_id)

clients ──┬─→ inquiries
          └─→ bookings

packages ──┬─→ quote_history
           └─→ bookings

inquiries ──┬─→ quote_history
            └─→ bookings

bookings ──┬─→ booking_performers
           └─→ notifications

booking_performers ──→ performer_expenses
```

---

## Financial Calculations

### Business Level (Admin View)

**Revenue:**

```sql
SELECT
  SUM(deposit_amount) FILTER (WHERE deposit_paid = true) +
  SUM(final_payment_amount) FILTER (WHERE final_payment_paid = true)
FROM bookings
WHERE event_date BETWEEN :start_date AND :end_date
```

**Business Expenses:**

```sql
-- Performer payouts
SELECT SUM(payout_amount)
FROM booking_performers
WHERE paid = true
  AND booking_id IN (
    SELECT id FROM bookings
    WHERE event_date BETWEEN :start_date AND :end_date
  )

-- Overhead expenses
SELECT SUM(amount)
FROM overhead_expenses
WHERE expense_date BETWEEN :start_date AND :end_date
```

**Business Profit:**

```
Profit = Revenue - (Performer Payouts + Overhead Expenses)
```

### Performer Level (Personal View)

**Performer's Gross Pay:**

```sql
SELECT SUM(bp.payout_amount)
FROM booking_performers bp
JOIN bookings b ON [bp.booking](http://bp.booking)_id = [b.id](http://b.id)
WHERE bp.performer_id = :performer_id
  AND bp.paid = true
  AND b.event_date BETWEEN :start_date AND :end_date
```

**Performer's Personal Expenses:**

```sql
SELECT SUM(amount)
FROM performer_expenses
WHERE performer_id = :performer_id
  AND expense_date BETWEEN :start_date AND :end_date
```

**Performer's Net Take-Home:**

```
Net = Gross Pay - Personal Expenses
```

---

## Key Changes from Original Schema

✅ **users.roles** - Array instead of single role

✅ **users.performer_id** - Link to performer record

✅ **performers.user_id** - Bidirectional link

✅ **performer_expenses** - NEW table for personal gig costs

✅ **overhead_expenses** - Renamed from "expenses", clearer purpose

✅ **booking_performers** - Simplified, no expense fields

---

## Migration Path

Phase 1 → Phase 1.5:

- Create user accounts for performers
- Link `performers.user_id` to new user records
- Add `'performer'` to their `users.roles` array
- Enable performer portal features
