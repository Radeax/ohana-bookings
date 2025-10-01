# Session 4: API Design

# Session 4: API Design

Now let's define **exactly what endpoints you need** to build. We'll focus on the minimum API that supports Phase 1.

## Approach

Rather than building every CRUD operation, let's map your **actual workflows** to specific API endpoints. I'll show you what I'm thinking, then you tell me what's missing.

---

## 1. Authentication & Users

**Phase 1: Just you (admin)**

`POST   /api/auth/login
POST   /api/auth/logout
GET    /api/auth/me                  # Get current user info`

**Skip for Phase 1:**

- User registration (you'll create admin accounts directly in DB)
- Password reset (you'll handle manually for now)
- User management endpoints (create/edit/delete users via DB for now)

**Does this work, or do you need user management in the UI?**

*I need user management*

---

## 2. Dashboard

**Single endpoint that returns everything for your dashboard:**

`GET    /api/dashboard

Response:
{
  "new_inquiries_count": 3,
  "quoted_inquiries": [...],
  "upcoming_events": [...],
  "overdue_deposits": [...],
  "stats": {
    "events_this_month": 5,
    "revenue_this_month": 12500.00,
    "outstanding_balance": 2000.00
  },
  "recent_notifications": [...]
}`

**This gives you everything on one load. Sound good?**

*Yes*

---

## 3. Inquiries

**Workflow: Capture inquiry → Quote → Convert to booking or mark lost**

`POST   /api/inquiries                # Create new inquiry
GET    /api/inquiries                # List all (with filters: status, date range)
GET    /api/inquiries/:id            # Get single inquiry details
PATCH  /api/inquiries/:id            # Update inquiry fields
DELETE /api/inquiries/:id            # Soft delete (mark inactive)

POST   /api/inquiries/:id/quote      # Add a quote to inquiry
GET    /api/inquiries/:id/quotes     # Get quote history

PATCH  /api/inquiries/:id/status     # Change status (new → quoted → confirmed → lost)`

**Questions:**

1. Should changing status require a reason? (e.g., if marking "lost", must provide `lost_reason`)
    1. *Optional field - select with a dropbox for common reasons with an option for “Other”*
2. When you mark an inquiry as "confirmed", should it auto-create a booking, or is that a separate action?
    1. *Yes, auto-create booking. Or prompt user to create booking*

---

## 4. Bookings

**Workflow: Convert inquiry to booking → Assign performers → Track payments**

`POST   /api/bookings                 # Create booking from inquiry
GET    /api/bookings                 # List all (with filters: status, date range)
GET    /api/bookings/:id             # Get booking details with performers
PATCH  /api/bookings/:id             # Update booking fields
DELETE /api/bookings/:id             # Cancel booking

POST   /api/bookings/:id/performers  # Assign performer(s)
DELETE /api/bookings/:id/performers/:performer_id  # Remove performer

PATCH  /api/bookings/:id/deposit     # Record deposit payment
PATCH  /api/bookings/:id/final-payment  # Record final payment`

**Questions:**

1. When you assign a performer, should it check for conflicts (already booked that date)?
    1. *Yes*
2. Should the API prevent assigning performers if you haven't confirmed their availability first?
    1. *No*

---

## 5. Performers

**Workflow: View roster → Check who's booked on a date**

`GET    /api/performers               # List all active performers
GET    /api/performers/:id           # Get performer details + booking history
POST   /api/performers               # Add new performer
PATCH  /api/performers/:id           # Update performer
DELETE /api/performers/:id           # Deactivate performer

GET    /api/performers/availability?date=YYYY-MM-DD  
       # Show who's booked vs. free on a specific date`

**For Phase 1, this is view-only for availability (you still text them). Phase 1.5 adds performer logins.**

**Does this cover what you need?**

- *Yes*

---

## 6. Clients

**Workflow: See if client is new or repeat → View their booking history**

`GET    /api/clients                  # List all clients
GET    /api/clients/:id              # Get client details + booking history
POST   /api/clients                  # Manually create client record
PATCH  /api/clients/:id              # Update client info`

**Note:** Clients are auto-created when you create an inquiry, but you can also create them manually.

**Do you need client management, or is auto-creation enough?**

- *Client management is needed*

---

## 7. Packages

**Workflow: Use predefined packages when quoting**

`GET    /api/packages                 # List all active packages
GET    /api/packages/:id             # Get package details
POST   /api/packages                 # Create package
PATCH  /api/packages/:id             # Update package
DELETE /api/packages/:id             # Deactivate package`

**Do you need full CRUD, or just view packages (you edit them directly in DB)?**

- *Full CRUD*

---

## 8. Financial Reports

**Workflow: See revenue, expenses, profit for a date range**

`GET    /api/reports/financial?start_date=...&end_date=...

Response:
{
  "revenue": {
    "deposits": 5000.00,
    "final_payments": 7500.00,
    "total": 12500.00
  },
  "expenses": {
    "performer_payouts": 6000.00,
    "overhead": 1200.00,
    "total": 7200.00
  },
  "profit": 5300.00,
  "outstanding": {
    "deposits_owed": 1500.00,
    "final_payments_owed": 500.00,
    "performer_payouts_owed": 800.00
  }
}`

**Does this give you what you need, or do you want more detailed breakdowns?**

- *This works*

---

## 9. Expenses

**Workflow: Manually log overhead expenses**

`POST   /api/expenses                 # Record expense
GET    /api/expenses                 # List all (with filters: category, date range)
GET    /api/expenses/:id             # Get expense details
PATCH  /api/expenses/:id             # Update expense
DELETE /api/expenses/:id             # Delete expense`

**Straightforward CRUD. Any special needs here?**

- *No*

---

## 10. Performer Payouts

**Workflow: Track what you owe performers, mark as paid**

`GET    /api/payouts                  # List all payouts (grouped by performer)
GET    /api/payouts/outstanding      # Show unpaid payouts only
PATCH  /api/payouts/:id              # Mark payout as paid

Response for GET /api/payouts:
{
  "payouts": [
    {
      "performer_id": "...",
      "performer_name": "Jane Doe",
      "bookings": [
        {
          "booking_id": "...",
          "event_date": "2025-10-15",
          "amount": 200.00,
          "paid": false
        }
      ],
      "total_owed": 200.00
    }
  ]
}`

**This helps you see what you owe each performer. Make sense?**

- *Yes*

---

## 11. Notifications

**Workflow: View in-app alerts, mark as read**

`GET    /api/notifications            # Get unread notifications
PATCH  /api/notifications/:id/read   # Mark as read
DELETE /api/notifications/:id        # Dismiss notification`

**Simple. You good with this?**

- *Yes*

---

## 12. Calendar

**Workflow: Month/week view of all bookings**

`GET    /api/calendar?start_date=...&end_date=...

Response:
{
  "events": [
    {
      "id": "...",
      "date": "2025-10-15",
      "start_time": "18:00",
      "client_name": "John Smith",
      "event_type": "wedding",
      "performers": ["Jane Doe", "Bob Lee"],
      "status": "confirmed"
    }
  ]
}`

**This powers your calendar UI. Does this have enough info?**

- *Yes*

---

## What's Missing?

Looking at your workflow, I think we're missing:

**Search/Filters:**

- Should there be a global search? (search by client name, event type, etc.)
- Or are list filters enough?
- *Include global search*

**Bulk Operations:**

- Do you ever need to do bulk actions? (e.g., mark multiple payouts as paid)
    - *Yes*

**Export:**

- Do you need to export data to CSV/PDF for record-keeping?
    - *Yes*

---

## My Recommendation: API Build Order

If we're being ruthless about Phase 1, here's what I'd build **first**:

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

**Does this order make sense for your priorities?**

---

Let me know your thoughts on:

1. Which endpoints are missing?
2. Which ones aren't needed?
3. Does the build order match your priorities? *Yes*

Once we align on this, I'll create the final API spec document for Notion!