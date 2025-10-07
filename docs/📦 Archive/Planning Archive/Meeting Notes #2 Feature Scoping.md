# Meeting Notes #2: Feature Scoping

**Date:** September 29, 2025

**Attendees:** Joven Poblete

**Purpose:** Define MVP scope - what's in, what's out

---

## Core Problem Prioritization

**#1 Problem:** Single source of truth for bookings

- Replace Google Sheets
- Accessible by admins, coordinators, and performers
- More sophisticated than manual texts

**#2 Problem:** Financial data tracking

- Revenue and profit auto-calculated
- Manual expense entry

---

## Phase 1: Admin Foundation (4 weeks)

### ✅ In Scope

**Inquiry Management**

- Manual entry from all sources (GigSalad, The Bash, email, phone)
- Status tracking: New → Quoted → Confirmed → Lost
- Track WHO was quoted (even if they don't book)
- Quote history per inquiry
- Lost reason tracking (dropdown: budget, date, found alternative, event cancelled, no response, other)

**Booking Workflow**

- Create bookings from inquiries
- **Auto-prompt booking creation** when inquiry marked "Confirmed"
- Manually assign performers
- Conflict detection when assigning (check if performer already booked)
- Track special requests, package details

**Payment Tracking**

- Client payments (deposits + finals, can use different payment methods)
- Performer payouts (per booking, different rates allowed)
- Payment methods tracked
- Calculate: Revenue, Profit, Balance owed
- Manual expense entry (simple form)
- **Invoice sent tracking** (date sent)
- Use PayPal invoicing (no PDF generation needed)

**Dashboard**

- New inquiries (need response)
- Quoted inquiries (with follow-up reminders)
- Upcoming events
- Overdue deposits
- Quick stats (monthly revenue/profit)

**Calendar View**

- Month/week view of bookings
- Click to see details

**Notifications (In-App Only)**

- New inquiry submitted
- Follow up reminder (quoted inquiry, 3 days)
- Deposit not received (X days before event)
- Event reminder (1 week before)

**User Roles**

- Admin (full access)
- Coordinator (can manage inquiries/bookings, no financial access)

**Additional Features**

- Full CRUD for Users, Clients, Packages, Performers, Expenses
- Global search across all entities
- Bulk operations (mark multiple payouts as paid)
- Export to CSV/PDF

---

## Phase 1.5: Performer Portal (2 weeks)

### ✅ In Scope

- Performer logins
- Mark availability (calendar)
- View assigned gigs
- See gig details (date, time, location, special requests)
- Email notifications (assigned to gig, event reminders)

---

## ❌ Out of Scope (Phase 2+)

- Website form integration (no website yet)
- GigSalad/TheBash API sync
- SMS notifications
- PDF invoice generation (using PayPal)
- Advanced financial reports
- Client portal
- Automated quote generation
- Email templates
- Automated follow-ups

---

## Key Decisions

✅ **Inquiry to Booking:** Auto-prompt (not auto-create) when inquiry marked "Confirmed"

✅ **Performer Assignment:** Check for conflicts, but don't block if availability not confirmed

✅ **Lost Reasons:** Dropdown with common options + "Other"

✅ **Quote Tracking:** Log all quotes (allows updating quotes for budget negotiations)

✅ **Packages:** Quoted package can prefill quoted amount

✅ **Client Contact:** Denormalized on bookings for historical accuracy

✅ **Performer Payouts:** Always tied to specific booking, different rates per performer allowed

✅ **Expenses:** General overhead, not per-booking

✅ **Expense Categories:** gas, costumes, audio_equipment, marketing, subscriptions, online_services, props, travel, other

---

## API Build Order

### Week 1-2: Core CRUD

1. Auth (login/logout/me)
2. Inquiries (POST, GET, PATCH, DELETE)
3. Bookings (POST, GET, PATCH)
4. Performers (GET list, GET by ID)

### Week 3: Workflow Features

1. Inquiry → Booking conversion
2. Assign performers to booking
3. Record payments (deposit/final)
4. Dashboard endpoint

### Week 4: Financial & Polish

1. Performer payouts tracking
2. Expenses CRUD
3. Financial reports
4. Notifications
5. Calendar view

---

## Success Criteria

- All bookings managed through app (zero Google Sheets)
- Fast inquiry response (< 24 hours)
- Zero double-bookings
- Clear financial visibility
- Positive user feedback
