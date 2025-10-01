# MVP Feature List

# MVP Feature List - Ohana Booking System

## 🎯 Core Goals

**#1:** Single source of truth for bookings (replacing Google Sheets + scattered texts)

**#2:** Track financial data (payments in/out, revenue, profit)

## ✅ IN SCOPE - MVP v1.0

### 1. **Inquiry Management**

- ✅ Manual entry of inquiries (from any source)
- ✅ Track inquiry fields:
    - Client name, email, phone
    - Event date/time
    - Location (city/venue)
    - Event type (wedding, corporate, etc.)
    - Notes
- ✅ Inquiry status: `New` → `Quoted` → `Confirmed` → `Lost`
- ✅ Track WHO was quoted (even if they don't book)
- ✅ Admin notes per inquiry

### 2. **Performer Management**

- ✅ **Performer logins** (they can log in)
- ✅ Performers mark their availability (calendar view)
- ✅ Admin sees performer availability when assigning
- ✅ List of all performers with contact info
- ✅ See performer's booking history

### 3. **Booking Workflow**

**Critical constraint:** Confirm performers BEFORE taking deposit

**Flow:**

1. New inquiry → Admin quotes
2. Client interested → **Admin checks performer availability**
3. Performers confirm → Admin sends invoice
4. Deposit paid → Booking confirmed
5. Event happens → Final payment collected

**Booking fields:**

- All inquiry fields carry over
- Performers assigned (1 or more)
- Package/price
- Deposit: amount, date paid, payment method
- Final payment: amount, date paid, payment method
- Balance owed (calculated)
- Special requests
- Invoice sent? (yes/no + date)

### 4. **Payment & Financial Tracking**

**Business Level (Admin View):**

- ✅ Track client payments (deposits + finals)
- ✅ Track performer payouts per booking
- ✅ Track overhead expenses (costumes, equipment, subscriptions)
- ✅ Payment methods (check, Venmo, PayPal, card, GigSalad, etc.)
- ✅ Mark invoice sent (yes/no + date, using PayPal invoicing)
- ✅ Financial dashboard:
    - Revenue (client payments)
    - Business Expenses (performer payouts + overhead)
    - Business Profit (revenue - expenses)
    - Outstanding client payments
    - Outstanding performer payouts

**Performer Level (Personal View):**

- ✅ Performers can log personal expenses (gas, food, parking) for gigs they perform
- ✅ Performer dashboard shows:
    - Gross Pay (total payouts from gigs)
    - Personal Expenses (costs they logged)
    - Net Take-Home (gross - expenses)
- ✅ **Phase 1:** Admins log expenses for any performer
- ✅ **Phase 1.5:** Performers log their own expenses

**Note:** Performer expenses are NOT business reimbursements. They're personal costs performers track to understand their true profit

### 5. **Dashboard**

- ✅ New inquiries (need response)
- ✅ Quoted inquiries (waiting to hear back)
- ✅ Upcoming events (next 30 days)
- ✅ Overdue deposits
- ✅ Quick stats (events this month, revenue this month)

### 6. **Notifications**

**For Admins:**

- ✅ New inquiry submitted
- ✅ Follow up reminder (quoted inquiry, 3 days)
- ✅ Deposit not received (X days before event)
- ✅ Event reminder (1 week before)

**For Performers:**

- ✅ **Notification when assigned to a gig** (email/SMS)
- ✅ Event reminder (1 week before)

### 7. **User Roles**

- ✅ **Admin** (full access including financials)
- ✅ **Coordinator** (can create inquiries/bookings, restricted from financial data)
- ✅ **Performer** (see their schedule, mark availability, view assigned gigs)

**Multi-Role Support:**

- ✅ Users can have multiple roles (e.g., `['admin', 'coordinator', 'performer']`)
- ✅ Example: You are Admin + Coordinator + Performer (can manage system AND perform at events)
- ✅ Users who perform are linked to a performer record via `performer_id`
- ✅ Performers can be linked to users via `user_id` (bidirectional)

### 8. **Calendar View**

- ✅ Month/week view of all bookings
- ✅ See performer availability overlay
- ✅ Click event to see details

## ❌ OUT OF SCOPE - Phase 2+

### Website Integration

- ❌ Public inquiry form (no website yet)
- ❌ Client-facing portal
- ❌ Online payment collection

### Third-Party Integrations

- ❌ GigSalad/TheBash API sync
- ❌ Automated quote generation
- ❌ Calendar sync (Google Calendar, etc.)

### Advanced Features

- ❌ Automated reminders via SMS
- ❌ Contract management (digital signatures)
- ❌ Advanced reporting/analytics
- ❌ Multi-language support
- ❌ Mobile app

### Nice-to-Have

- ❌ Email templates
- ❌ Automated follow-ups
- ❌ Photo/video uploads
- ❌ Client reviews/ratings