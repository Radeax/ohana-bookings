# Meeting Notes #3: Data Model

**Date:** September 30, 2025

**Attendees:** Joven Poblete

**Purpose:** Design database schema for Phase 1

---

## Core Entities

1. **Users** (admins, coordinators, performers)
2. **Clients** (reusable client records)
3. **Packages** (predefined service offerings)
4. **Inquiries** (potential clients)
5. **Quote_History** (track all quotes per inquiry)
6. **Bookings** (confirmed events)
7. **Performers** (roster)
8. **Booking_Performers** (join table + payout tracking)
9. **Expenses** (manual overhead entries)
10. **Notifications** (in-app alerts)
11. **Performer_Availability** (Phase 1.5)
12. **Audit_Log** (track changes)

---

## Key Schema Decisions

### Users

- Roles: `admin`, `coordinator`, `performer`
- "Coordinator" (better name than "booker") = can book but not view financials
- Support multiple admin accounts from start

### Inquiries

- City/venue required, full address optional
- Track quote history (multiple quotes allowed for budget negotiations)
- Quoted package can prefill values
- Lost reason: dropdown enum (budget, date, found_alternative, event_cancelled, no_response, other)

### Bookings

- Client contact info denormalized (snapshot at booking time)
- Separate payment methods for deposit vs final payment allowed
- Track invoice sent date
- Full address required (unlike inquiries)

### Performers

- Track skills (hula, tahitian, maori, fijian, samoan, fire_knife, fire_poi, fire_staff)
- Default rate field (negotiable per gig)
- `user_id` nullable in Phase 1, linked in Phase 1.5

### Booking_Performers (Join Table)

- Payout always tied to specific booking
- Different rates per performer allowed (less experienced vs experienced)
- Track payout method, paid status, notes

### Clients

- Separate table for repeat client tracking
- Auto-created from inquiries
- Manual creation also supported

### Packages

- Default pricing with negotiation flexibility
- Includes display_order for UI sorting
- Track min/max performers, includes_fire, duration

### Expenses

- General overhead (not per-booking)
- Categories: gas, costumes, audio_equipment, marketing, subscriptions, online_services, props, travel, other

---

## Relationships

```
users ──┬─→ inquiries (created_by)
        ├─→ bookings (created_by)
        ├─→ quote_history (quoted_by)
        ├─→ booking_performers (assigned_by)
        ├─→ expenses (created_by)
        └─→ audit_log (user_id)

clients ──┬─→ inquiries
          └─→ bookings

packages ──┬─→ quote_history
           └─→ bookings

inquiries ──┬─→ quote_history
            └─→ bookings

bookings ──→ booking_performers

performers ──┬─→ booking_performers
             ├─→ performer_availability (Phase 1.5)
             └─→ users (user_id, Phase 1.5)
```

---

## Financial Calculations

### Revenue (Money In)

```sql
SUM(deposit_amount WHERE deposit_paid) +
SUM(final_payment_amount WHERE final_payment_paid)
```

### Expenses (Money Out)

```sql
-- Performer payouts
SUM(payout_amount FROM booking_performers WHERE payout_paid)

-- Overhead
SUM(amount FROM expenses)
```

### Profit

```
Profit = Revenue - (Performer Payouts + Overhead Expenses)
```

---

## Key Design Patterns

✅ **Denormalization:** Client info copied to bookings (historical snapshot)

✅ **Audit Trail:** Separate audit_log table tracks all changes

✅ **Soft Deletes:** Mark entities inactive rather than hard delete

✅ **JSONB:** Use for flexible fields (performer skills, audit changes)

✅ **UUIDs:** All primary keys

✅ **Timestamps:** created_at, updated_at on all tables

---

## Indexes Strategy

**High Priority:**

- `inquiries`: (status, event_date), (client_id), (created_at)
- `bookings`: (event_date, status), (client_id), (deposit_paid, deposit_paid_date)
- `booking_performers`: (booking_id), (performer_id, booking_id) UNIQUE
- `performers`: (is_active), (user_id)

---

## Next Steps

- Create Drizzle schema files → Session 4
- Define API endpoints → Session 4
- Migration strategy → Implementation
