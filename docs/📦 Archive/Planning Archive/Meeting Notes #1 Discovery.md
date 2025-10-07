# Meeting Notes #1: Discovery

**Date:** September 29, 2025

**Attendees:** Joven Poblete

**Purpose:** Understand current business operations and pain points

---

## Business Overview

**Company:** Ohana of Polynesia

- **Services:** Polynesian variety shows (hula, Tahitian, Maori, Fijian, Samoan dances)
- **Typical Performance:** 45-60 min shows, optional fire performance
- **Volume:** ~40-60 bookings/year (rebuilding from dormancy)
- **Current Roster:** 3-4 active performers

**Event Types:**

- Weddings, corporate events, festivals, birthdays, retirement homes, anniversaries, annual gatherings

**Inquiry Sources:**

- GigSalad (competitive bidding - 20% conversion)
- The Bash (competitive bidding - 20% conversion)
- Direct contact via email/phone (60% conversion)
- Website form (future)

---

## Current Workflow & Pain Points

### Inquiry Management

**Current Process:**

- Inquiries scattered across platforms (GigSalad, The Bash, email)
- No centralized tracking - each inquiry stays in its original inbox
- **Pain:** Forgetting to respond to potential clients

### Booking Process

**Current Process:**

1. Receive inquiry
2. Text/email performers to check availability
3. Quote client (email with PDF price list)
4. **Client pays deposit → booking confirmed** ⚠️ Must confirm performers BEFORE deposit
5. Track in Google Sheets
6. Send performers event details via email

**Pain Points:**

- Manual performer availability checks via text
- Google Sheets as only source of truth
- Time-consuming bookkeeping
- Occasionally double-booking performers
- Losing track of inquiries

### Financial Tracking

**Current Process:**

- Manual tracking in Google Sheets
- Deposit + final payment tracking
- Performer payouts per booking
- Using PayPal invoicing

**Pain Points:**

- Bookkeeping takes too much time
- Difficult to see financial overview (revenue, profit, expenses)

---

## Success Vision (6 months)

**Morning Dashboard:**

- Check app for new inquiries and booking status
- Get notifications for updates (new inquiries, performer responses)

**Eliminated Activities:**

- Relying on Google Sheets
- Texting performers for availability

**Improved Workflows:**

- Fast booking confirmation
- Easy data visibility
- Automated inquiry intake and standard package quotes (future)

---

## Key Requirements Identified

### Primary Goals

1. **Single source of truth** - Replace Google Sheets
2. **Centralized inquiry tracking** - All sources in one place
3. **Financial tracking** - Payments in/out, revenue, profit automatically calculated
4. **Performer coordination** - Digital availability and assignment
5. **Notifications** - Don't miss inquiries or follow-ups

### User Roles

- **Admin** - Full access (including financials)
- **Coordinator** - Booking management (restricted from financials)
- **Performer** (Phase 1.5) - View schedule, mark availability

---

## Critical Workflow: Inquiry to Booking

```
1. Inquiry received (manual entry from any source)
2. Admin quotes client
3. ⚠️ CHECK PERFORMER AVAILABILITY (must happen before deposit)
4. Performers confirm availability
5. Send invoice to client
6. Client pays deposit → Booking created
7. Event details sent to performers
8. Event occurs
9. Final payment collected (typically after performance)
```

---

## Business Context

**Why Rebuilding:**

- Business went dormant for several years (owner stopped responding to inquiries)
- Currently: 1 repeat client, seasonal inquiries returning
- Starting fresh with professional systems

**Market Position:**

- Standard packages available, open to negotiation
- Different rates for less experienced vs. experienced performers
- Expenses: gas, costumes, audio equipment, marketing, subscriptions (GigSalad, The Bash, Google Suite)

---

## Key Insights

✅ **Must solve:** Forgetting to respond to inquiries

✅ **Critical constraint:** Confirm performer availability BEFORE taking client deposit

✅ **Financial need:** Auto-calculated revenue and profit, manual expense entry acceptable

✅ **Notification priority:** New inquiries, follow-up reminders (3 days after quote), event reminders (1 week before)

---

## Next Steps

- Define MVP feature scope → Session 2
- Design database schema → Session 3
- Plan API endpoints → Session 4
- Finalize tech stack → Session 5
