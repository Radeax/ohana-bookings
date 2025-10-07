# Session 2: MVP Feature Scoping

# Session 2: MVP Feature Scoping

Now let's be **ruthless** about what goes in the MVP. We'll build the minimum that solves your top 3 pains.

## Part 1: Core Problem to Solve

Looking at your pains, here's what I think the MVP should focus on:

**Primary Goal:** Stop forgetting inquiries + track bookings in one place

**Secondary Goal:** Track payment status without spreadsheets

**Out of Scope for MVP:** Automated quotes, performer self-service portal, formal reminders

Does that feel right, or would you prioritize differently?

- _The #1 problem to solve is having a single source of truth for future/past bookings that can be referenced by clients, admins/bookers (the ones who book, might need a better term), and the performers. And something more sophisticated than Google Sheets and manual texts._
- _#2 is to keep track of financial data_

---

## Part 2: Inquiry Management

**For MVP, let's tackle inquiries step by step:**

**Which of these is most important to you right now?**

a) **Manual entry of inquiries** from all sources (GigSalad, email, phone) into one place

b) **Automatic capture** from your website form

c) **Integration** with GigSalad/TheBash APIs

My recommendation: Start with **(a) manual entry**. You can paste/type inquiries from any source into the app. Website form and integrations come later.

**Do you agree? Or is the website form critical for MVP?**

- _I agree - currently don’t have a website and GigSalad and TheBash doesn’t have many new inquiries coming in at the moment._

---

## Part 3: Booking Workflow

**For each inquiry, what do you need to track?**

Here's what I'm thinking for MVP:

### Inquiry Fields:

- Client name
- Contact (email, phone)
- Event date/time
- Location (city/venue)
- Event type (wedding, corporate, etc.)
- Status: `New` → `Quoted` → `Booked` → `Lost`
- Notes (free text)

### After Deposit (becomes "Booking"):

- Performers assigned
- Package/price
- Deposit paid? (yes/no + amount)
- Final payment status
- Special requests

**Questions:**

1. Is this list complete, or am I missing critical fields?
   1. _Because we have limited performers, I confirm performer availability before asking the client to pay a deposit to taking money before knowing if we can provide the service._
2. Do you need to track WHO you quoted (even if they don't book)?
   1. _That would be helpful_
3. Should "Quoted" inquiries remind you to follow up after X days?
   1. _Yes_

---

## Part 4: Performer Management

**For MVP, what's the minimum you need?**

Option A: **Simple list of performers**

- You manually text/email them (no change from today)
- App just helps you see who's already booked on a date

Option B: **Availability tracking**

- Performers can log in and mark dates available/unavailable
- You see availability when assigning them
- They get notified when assigned (email/text)

**Which option for MVP?**

- My recommendation: Start with **(A)** - just visibility. Add performer logins in Phase 2.
- But if checking availability is a huge pain, maybe (B) is worth including?
  - _Yes, let’s go with (B)_

---

## Part 5: Payment Tracking

**For MVP, what do you need to track?**

Here's my proposal:

### Per Booking:

- Total price
- Deposit amount + date paid
- Final payment amount + date paid
- Balance owed
- Payment method (check, Venmo, card, etc.)

### Reports:

- How much is owed to you (outstanding deposits/final payments)
- Monthly revenue (simple total)

**Questions:**

1. Do you need to track performer payouts in MVP, or just client payments?
   1. Both
2. Do you invoice clients, or just receive payments?
   1. _Sometimes just receive payments especially if booked through a booking site like GigSalad, but usually invoice_
3. Any other financial data you need to see?
   1. _The usual - revenue, profit, expenses, etc._

---

## Part 6: The Dashboard

**When you open the app on Monday morning, what do you want to see?**

My recommendation:

### Dashboard shows:

- **New inquiries** (need to respond)
- **Quoted inquiries** (waiting to hear back)
- **Upcoming events** (next 30 days)
- **Overdue payments** (deposits/finals not paid)
- **Quick stats** (events this month, revenue this month)

**Does this match your vision, or would you change it?**

- _Yes_

---

## Part 7: Notifications/Reminders

**What reminders matter most?**

Check all that apply:

- [x] New inquiry (so you don't forget to respond)
- [x] Follow up on quoted inquiry after 3 days
- [x] Deposit not received X days before event
- [ ] Final payment not received X days before event
  - _While some clients prepay in full, payment is not due until after performance_
- [x] Event happening tomorrow (send performer details)
  - Maybe earlier than a day in advance - a week

**Which 1-2 are most critical for MVP?**

- I’d say notifications to the performer when I send them a new gig which would replace texting them along with feedback notifications for admins

---

Take your time and answer these questions in your Notion page. Once I see your answers, I'll draft your MVP feature list with clear IN/OUT scope!
