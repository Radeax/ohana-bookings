# Session 3: Data Model

# Session 3: Data Model

Now let's design the database schema that supports Phase 1. We'll design it so Phase 1.5 is easy to add later.

## Core Entities

Based on your workflow, I see these main entities:

1. **Users** (admins, bookers, performers)
2. **Inquiries** (potential clients)
3. **Bookings** (confirmed events)
4. **Performers** (roster)
5. **Payments** (money in/out)
6. **Expenses** (manual entries)
7. **Notifications** (in-app alerts)

Let me walk through each one:

---

## 1. Users Table

**Purpose:** Everyone who logs in (admins, bookers, and eventually performers)

`users
├─ id (uuid, primary key)
├─ email (unique)
├─ password_hash
├─ first_name
├─ last_name
├─ phone
├─ role (enum: 'admin', 'booker', 'performer')
├─ is_active (boolean)
├─ created_at
└─ updated_at`

**Questions:**

1. Should bookers and admins be the same person with different permissions, or separate accounts?
   1. _Is there a better name for “bookers”? But yes, all admins are bookers, but not all bookers will be admins._
2. For Phase 1, you're the only admin - should we even have multiple admin accounts, or just one hardcoded login?
   1. _We can support multiple admin accounts._

---

## 2. Inquiries Table

**Purpose:** Track every potential client from first contact

`inquiries
├─ id (uuid, primary key)
├─ client_name
├─ client_email
├─ client_phone
├─ event_date (date)
├─ event_time (time, nullable)
├─ event_type (string: 'wedding', 'corporate', etc.)
├─ location_city
├─ location_venue (nullable)
├─ location_address (nullable)
├─ status (enum: 'new', 'quoted', 'confirmed', 'lost')
├─ source (enum: 'gigsalad', 'thebash', 'email', 'phone', 'referral', 'other')
├─ quoted_amount (decimal, nullable)
├─ quoted_date (date, nullable)
├─ notes (text, nullable)
├─ lost_reason (text, nullable - if status = 'lost')
├─ created_by (uuid, foreign key → users.id)
├─ created_at
└─ updated_at`

**Questions:**

1. Should we track the full address up front, or just city/venue for inquiries?
   1. _City/venue required for inquiries, optional full address._
2. Do you want to track multiple quotes per inquiry, or just the latest one?
   1. _Could keep a log of past inquiries, in case we update a quote (ie, client has a low budget)_
3. Should we have a separate "quoted_package" field to track what you offered?
   1. _A quoted_package could prefill some of the other values, like `quoted_amount`_

---

## 3. Bookings Table

**Purpose:** Confirmed events with deposit paid

`bookings
├─ id (uuid, primary key)
├─ inquiry_id (uuid, foreign key → inquiries.id)
├─ event_date (date)
├─ event_start_time (time)
├─ event_end_time (time, nullable)
├─ event_type
├─ location_address (full address now)
├─ package_name (string, nullable)
├─ total_price (decimal)
├─ deposit_amount (decimal)
├─ deposit_paid (boolean)
├─ deposit_paid_date (date, nullable)
├─ final_payment_amount (decimal)
├─ final_payment_paid (boolean)
├─ final_payment_paid_date (date, nullable)
├─ payment_method (enum: 'check', 'venmo', 'paypal', 'cash', 'gigsalad', 'thebash', 'other')
├─ special_requests (text, nullable)
├─ status (enum: 'pending', 'confirmed', 'completed', 'cancelled')
├─ created_by (uuid, foreign key → users.id)
├─ created_at
└─ updated_at`

**Questions:**

1. Should deposit and final payment have separate payment methods, or is it always the same?
   1. _Some people pay the deposit and final balance using the same payment method (paypal invoice, mailed check) but sometimes they might pay the rest of the balance in cash._
2. Do you need to track the "invoice sent" date?
   1. _That would be useful_
3. Should we store the client contact info here too (denormalized), or always reference the inquiry?
   1. _Client contact info can be included_

---

## 4. Performers Table

**Purpose:** Your roster (separate from users table initially)

`performers
├─ id (uuid, primary key)
├─ user_id (uuid, foreign key → users.id, nullable for Phase 1)
├─ first_name
├─ last_name
├─ email
├─ phone
├─ is_active (boolean)
├─ notes (text, nullable)
├─ created_at
└─ updated_at`

**Note:** In Phase 1, `user_id` is NULL. In Phase 1.5, we link performers to user accounts.

**Questions:**

1. Do you need to track performer skills/specialties (hula, fire, etc.)?
   1. _Yes, it’d be helpful_
2. Should we track their default rate, or is that negotiated per gig?
   1. _It’s negotiable, but for the most part we’ll try to stick with the default rate_

---

## 5. Booking_Performers Table (Join Table)

**Purpose:** Many-to-many relationship (one booking can have multiple performers, one performer can have multiple bookings)

`booking_performers
├─ id (uuid, primary key)
├─ booking_id (uuid, foreign key → bookings.id)
├─ performer_id (uuid, foreign key → performers.id)
├─ payout_amount (decimal)
├─ payout_paid (boolean)
├─ payout_paid_date (date, nullable)
├─ payout_method (enum: 'check', 'venmo', 'cash', 'zelle', 'other')
├─ notes (text, nullable)
├─ created_at
└─ updated_at`

**Questions:**

1. Is performer payout always tied to a specific booking, or do you sometimes pay them in bulk?
   1. _Payout is always tied to a specific booking._
2. Do different performers get different rates for the same booking?
   1. _Less experienced performers typically have a different rate. Most performers have similar or the same rate._

---

## 6. Expenses Table

**Purpose:** Manual expense entry for overhead (costumes, props, marketing, etc.)

`expenses
├─ id (uuid, primary key)
├─ description
├─ amount (decimal)
├─ category (enum: 'costumes', 'props', 'marketing', 'travel', 'other')
├─ expense_date (date)
├─ payment_method (enum: 'cash', 'card', 'check', 'other')
├─ created_by (uuid, foreign key → users.id)
├─ created_at
└─ updated_at`

**Questions:**

1. Should expenses be linked to specific bookings, or just general overhead?
   1. _General overhead, not many expenses per booking_
2. What expense categories do you typically have?
   1. _Gas, costumes, audio equipment, marketing, subscriptions like TheBash, online services (ie Google Suite)_

---

## 7. Notifications Table (Phase 1)

**Purpose:** In-app alerts for admins

`notifications
├─ id (uuid, primary key)
├─ user_id (uuid, foreign key → users.id)
├─ type (enum: 'new_inquiry', 'follow_up_reminder', 'deposit_overdue', 'event_reminder')
├─ title
├─ message
├─ related_inquiry_id (uuid, nullable)
├─ related_booking_id (uuid, nullable)
├─ is_read (boolean)
├─ created_at
└─ updated_at`

---

## Missing Pieces?

**What else do we need to track?**

Some things I'm wondering about:

1. **Contacts/Clients Table:** Should we have a separate "clients" table if someone books multiple times?
   1. _We can have a separate clients table, especially to keep track of new/repeat clients_
2. **Availability Table (Phase 1.5):** For performers to mark dates available/unavailable
   1. _What are you wondering about regarding this?_
3. **Audit Log:** Track who changed what and when?
   1. _Yes_
4. **Quote History:** Track multiple quotes per inquiry?
   1. _Yes_

---

## Your Turn!

Please review each table and answer the questions I've marked. Also:

1. **What am I missing?** Any other data you need to track?
   1. _Maybe a packages/offering/services table that comes with a default rate and other values_
2. **What's wrong?** Any fields that don't match your workflow?
3. **What's overkill?** Anything we can simplify for Phase 1?

Once you answer, I'll create the final schema document for your Notion!
