# Complete API Specification

# Complete API Specification - Ohana Booking System (Phase 1)

## Base URL

`/api/v1`

## Authentication

All endpoints (except `/auth/login`) require a valid JWT token in the `Authorization` header:

`Authorization: Bearer <token>`

---

## 1. Authentication & Users

### Auth Endpoints

http

`POST   /api/auth/login
POST   /api/auth/logout
GET    /api/auth/me
POST   /api/auth/refresh-token`

### User Management

http

`GET    /api/users                    # List all users (admin only)
GET    /api/users/:id                # Get user details
POST   /api/users                    # Create new user (admin only)
PATCH  /api/users/:id                # Update user
DELETE /api/users/:id                # Deactivate user (admin only)
PATCH  /api/users/:id/password       # Change user password`

**Request Examples:**

**POST /api/auth/login**

json

`{
  "email": "admin@ohana.com",
  "password": "password123"
}`

**POST /api/users**

json

`{

"email": "[coordinator@ohana.com](mailto:coordinator@ohana.com)",

"password": "temp123",

"first_name": "Jane",

"last_name": "Doe",

"phone": "+15551234567",

"roles": ["coordinator"], // Array: can have multiple roles

"performer_id": null // Link to performer record if user performs
}`

---

## 2. Dashboard

http

`GET    /api/dashboard`

**Response:**

json

`{
  "new_inquiries_count": 3,
  "quoted_inquiries": [
    {
      "id": "...",
      "client_name": "John Smith",
      "event_date": "2025-11-15",
      "quoted_amount": 1500.00,
      "days_since_quote": 2
    }
  ],
  "upcoming_events": [
    {
      "id": "...",
      "date": "2025-10-20",
      "client_name": "Jane Doe",
      "performers": ["Alice", "Bob"],
      "status": "confirmed"
    }
  ],
  "overdue_deposits": [
    {
      "booking_id": "...",
      "client_name": "...",
      "event_date": "2025-10-25",
      "deposit_amount": 500.00,
      "days_overdue": 3
    }
  ],
  "stats": {
    "events_this_month": 5,
    "revenue_this_month": 12500.00,
    "profit_this_month": 5300.00,
    "outstanding_balance": 2000.00
  },
  "recent_notifications": [...]
}`

---

## 3. Inquiries

http

`POST /api/inquiries
GET /api/inquiries # List with filters
GET /api/inquiries/:id
PATCH /api/inquiries/:id
DELETE /api/inquiries/:id # Soft delete

POST /api/inquiries/:id/quote
GET /api/inquiries/:id/quotes
PATCH /api/inquiries/:id/status
POST /api/inquiries/:id/convert-to-booking # Manual booking creation`

**Query Parameters for GET /api/inquiries:**

`?status=new,quoted,confirmed,lost
&event_date_from=YYYY-MM-DD
&event_date_to=YYYY-MM-DD
&source=gigsalad,thebash,email,phone
&page=1
&limit=20
&sort=event_date:asc`

**POST /api/inquiries**

json

`{
  "client_name": "John Smith",
  "client_email": "john@example.com",
  "client_phone": "+15551234567",
  "client_company": "ABC Corp",
  "event_date": "2025-11-15",
  "event_time": "18:00",
  "event_type": "wedding",
  "location_city": "Washington DC",
  "location_venue": "The Hamilton",
  "source": "gigsalad",
  "notes": "Outdoor venue, needs fire permit"
}`

**POST /api/inquiries/:id/quote**

json

`{
  "package_id": "uuid",              *// Optional: auto-fill from package*
  "quoted_amount": 1500.00,
  "notes": "Custom package with fire performance"
}`

**PATCH /api/inquiries/:id/status**

json

`{
  "status": "lost",
  "lost_reason": "budget"            *// Required if status = "lost"*
}`

**Lost Reason Enum:**

- `budget` - "Budget constraints"
- `date` - "Date no longer works"
- `found_alternative` - "Found another performer"
- `event_cancelled` - "Event cancelled"
- `no_response` - "Client stopped responding"
- `other` - "Other (see notes)"

**Auto-Booking on Status Change:**
When PATCH `/api/inquiries/:id/status` sets `status: "confirmed"`, the API responds:

json

`{
  "inquiry": {...},
  "prompt_booking_creation": true,
  "suggested_booking": {
    "event_date": "...",
    "client_name": "...",
    "total_price": 1500.00  *// From latest quote*
  }
}`

Frontend then calls `POST /api/inquiries/:id/convert-to-booking` to complete.

---

## 4. Bookings

http

`POST /api/bookings
GET /api/bookings
GET /api/bookings/:id
PATCH /api/bookings/:id
DELETE /api/bookings/:id # Cancel booking

POST /api/bookings/:id/performers
DELETE /api/bookings/:id/performers/:performer_id

PATCH /api/bookings/:id/deposit
PATCH /api/bookings/:id/final-payment
PATCH /api/bookings/:id/invoice`

**POST /api/bookings**

json

`{
  "inquiry_id": "uuid",              *// Links to inquiry*
  "event_date": "2025-11-15",
  "event_start_time": "18:00",
  "event_end_time": "20:00",
  "location_address": "123 Main St, Washington DC 20001",
  "package_id": "uuid",
  "total_price": 1500.00,
  "deposit_amount": 500.00,
  "final_payment_amount": 1000.00,
  "special_requests": "Fire performance requested"
}`

**POST /api/bookings/:id/performers**

json

`{
  "performer_id": "uuid",
  "payout_amount": 200.00
}`

**Response:**

- `200 OK` - Performer assigned successfully
- `409 Conflict` - Performer already booked for this date/time

**Error Response for 409:**

json

`{
  "error": "PERFORMER_CONFLICT",
  "message": "Performer Jane Doe is already booked on 2025-11-15",
  "conflicting_booking": {
    "id": "...",
    "client_name": "...",
    "event_time": "17:00-19:00"
  }
}`

**PATCH /api/bookings/:id/deposit**

json

`{
  "deposit_paid": true,
  "deposit_paid_date": "2025-10-01",
  "deposit_payment_method": "paypal"
}`

**PATCH /api/bookings/:id/invoice**

json

`{
  "invoice_sent": true,
  "invoice_sent_date": "2025-10-01"
}`

---

## 5. Performers

http

`GET /api/performers
GET /api/performers/:id
POST /api/performers
PATCH /api/performers/:id
DELETE /api/performers/:id # Deactivate

GET /api/performers/availability?date=YYYY-MM-DD`

**POST /api/performers**

json

`{
  "first_name": "Jane",
  "last_name": "Doe",
  "email": "jane@example.com",
  "phone": "+15551234567",
  "skills": ["hula", "tahitian", "fire_knife"],
  "default_rate": 200.00,
  "notes": "Preferred for fire performances"
}`

**GET /api/performers/availability?date=2025-11-15**

json

`{
  "date": "2025-11-15",
  "performers": [
    {
      "id": "...",
      "name": "Jane Doe",
      "is_booked": true,
      "booking": {
        "id": "...",
        "client_name": "John Smith",
        "event_time": "18:00-20:00"
      }
    },
    {
      "id": "...",
      "name": "Bob Lee",
      "is_booked": false
    }
  ]
}`

---

## 6. Clients

http

`GET    /api/clients
GET    /api/clients/:id
POST   /api/clients
PATCH  /api/clients/:id
DELETE /api/clients/:id              # Soft delete`

**GET /api/clients/:id**

json

`{
  "id": "...",
  "name": "John Smith",
  "email": "john@example.com",
  "phone": "+15551234567",
  "company": "ABC Corp",
  "is_repeat_client": true,
  "total_bookings": 3,
  "booking_history": [
    {
      "booking_id": "...",
      "event_date": "2024-06-15",
      "event_type": "wedding",
      "total_price": 1500.00
    }
  ],
  "notes": "Always pays on time"
}`

---

## 7. Packages

http

`GET    /api/packages
GET    /api/packages/:id
POST   /api/packages
PATCH  /api/packages/:id
DELETE /api/packages/:id             # Deactivate`

**POST /api/packages**

json

`{
  "name": "Basic Show",
  "description": "45-minute Polynesian variety show",
  "default_price": 1200.00,
  "duration_minutes": 45,
  "min_performers": 2,
  "max_performers": 4,
  "includes_fire": false,
  "is_active": true,
  "display_order": 1
}`

---

## 8. Financial Reports

http

`GET /api/reports/business-financials?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD

GET /api/reports/performer-earnings/:performerId?start_date=...&end_date=...

GET /api/reports/all-performers-earnings?start_date=...&end_date=...`

**GET /api/reports/business-financials** (Admin Only)

json

`{

"period": {

"start_date": "2025-10-01",

"end_date": "2025-10-31"

},

"revenue": {

"deposits_paid": 5000.00,

"final_payments_paid": 7500.00,

"total": 12500.00

},

"business_expenses": {

"performer_payouts": 6000.00,

"overhead_expenses": {

"costumes": 800.00,

"equipment": 0.00,

"subscriptions": 400.00,

"marketing": 300.00,

"props": 0.00,

"other": 0.00,

"total": 1500.00

},

"total": 7500.00

},

"business_profit": 5000.00,

"outstanding": {

"deposits_owed": 1500.00,

"final_payments_owed": 500.00,

"performer_payouts_owed": 800.00

}

}`

**GET /api/reports/performer-earnings/:performerId** (Performer can see own, Admin sees all)

json

`{

"performer": {

"id": "...",

"name": "Joven Poblete"

},

"period": {

"start_date": "2025-10-01",

"end_date": "2025-10-31"

},

"earnings": {

"gigs_count": 12,

"gross_pay": 2400.00, // Total payouts

"personal_expenses": 650.00, // Gas, food, etc.

"net_take_home": 1750.00 // gross - expenses

},

"gig_breakdown": [

{

"booking_id": "...",

"event_date": "2025-10-15",

"client_name": "John Smith",

"payout": 200.00,

"expenses": 75.00,

"net": 125.00

}

]

}`

**GET /api/reports/all-performers-earnings** (Admin Only)

json

`{

"period": {

"start_date": "2025-10-01",

"end_date": "2025-10-31"

},

"performers": [

{

"id": "...",

"name": "Joven Poblete",

"gigs_count": 12,

"gross_pay": 2400.00,

"personal_expenses": 650.00,

"net_take_home": 1750.00

},

{

"id": "...",

"name": "Alice Smith",

"gigs_count": 8,

"gross_pay": 1800.00,

"personal_expenses": 0.00, // Not logged

"net_take_home": 1800.00

}

],

"totals": {

"total_payouts": 6000.00,

"total_expenses_logged": 1200.00

}

}
`}
}`

---

## 9. Overhead Expenses (Business Costs)

http

`GET /api/overhead-expenses

GET /api/overhead-expenses/:id

POST /api/overhead-expenses

PATCH /api/overhead-expenses/:id

DELETE /api/overhead-expenses/:id`

**Query Parameters:**

`?category=costumes,equipment,subscriptions,marketing

&expense_date_from=YYYY-MM-DD

&expense_date_to=YYYY-MM-DD`

**POST /api/overhead-expenses**

json

`{

"description": "New costumes for Tahitian dance",

"amount": 800.00,

"category": "costumes",

"expense_date": "2025-10-15",

"payment_method": "paypal",

"notes": "Ordered from Hawaii supplier"

}`

**Category Enum:**

- `costumes` - Performance costumes
- `equipment` - Audio equipment, props, etc.
- `subscriptions` - GigSalad, The Bash, software
- `marketing` - Advertising, promotional materials
- `props` - Stage props, decorations
- `other` - Miscellaneous expenses

---

## 10. Performer Expenses (Personal Gig Costs)

http

`GET /api/performer-expenses

GET /api/performer-expenses/:id

POST /api/performer-expenses

PATCH /api/performer-expenses/:id

DELETE /api/performer-expenses/:id`

**Query Parameters:**

`?performer_id=uuid

&booking_id=uuid

&expense_date_from=YYYY-MM-DD

&expense_date_to=YYYY-MM-DD`

**POST /api/performer-expenses**

json

`{

"booking_performer_id": "uuid", // Which gig assignment?

"performer_id": "uuid", // Which performer?

"amount": 75.00,

"description": "Gas $45, dinner $30",

"expense_date": "2025-10-20" // Usually = event date

}`

**Permissions:**

- **Phase 1:** Admins can log expenses for any performer
- **Phase 1.5:** Performers can log their own expenses only

**Note:** These are NOT business reimbursements. These are the performer's personal costs they track to understand their net profit,
"notes": "Purchased at Guitar Center"
}`

---

## 10. Performer Payouts

http

`GET    /api/payouts
GET    /api/payouts/outstanding
PATCH  /api/payouts/:id              # Mark as paid
PATCH  /api/payouts/bulk-pay         # Bulk payment`

**PATCH /api/payouts/bulk-pay**

json

`{
  "payout_ids": ["uuid1", "uuid2", "uuid3"],
  "payment_date": "2025-10-15",
  "payment_method": "venmo"
}`

---

## 11. Notifications

http

`GET    /api/notifications
GET    /api/notifications/unread
PATCH  /api/notifications/:id/read
PATCH  /api/notifications/mark-all-read
DELETE /api/notifications/:id`

---

## 12. Calendar

http

`GET    /api/calendar?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD&view=month|week`

---

## 13. Search

http

`GET    /api/search?q=...&type=all|inquiries|bookings|clients|performers`

**Response:**

json

`{
  "query": "john smith",
  "results": {
    "inquiries": [...],
    "bookings": [...],
    "clients": [...]
  },
  "total_results": 15
}`

---

## 14. Export

http

`GET    /api/export/inquiries?format=csv|pdf&...filters
GET    /api/export/bookings?format=csv|pdf&...filters
GET    /api/export/financial?format=csv|pdf&start_date=...&end_date=...
GET    /api/export/performers?format=csv&...filters`

**Returns:** File download with appropriate headers

---

## Build Order (4 Weeks)

### **Week 1: Foundation**

1. ✅ Database setup + migrations
2. ✅ Auth system (login/logout/me/refresh)
3. ✅ User management CRUD
4. ✅ Inquiries CRUD
5. ✅ Basic validation & error handling

### **Week 2: Core Workflow**

1. ✅ Bookings CRUD
2. ✅ Performers CRUD
3. ✅ Clients CRUD (auto-creation from inquiries)
4. ✅ Packages CRUD
5. ✅ Inquiry quoting + quote history
6. ✅ Inquiry → Booking conversion
7. ✅ Assign performers to bookings (with conflict detection)

### **Week 3: Financial Tracking**

1. ✅ Payment tracking (deposit/final)
2. ✅ Performer payout tracking
3. ✅ Expenses CRUD
4. ✅ Financial reports
5. ✅ Dashboard endpoint

### **Week 4: Polish & Features**

1. ✅ Notifications system
2. ✅ Calendar view
3. ✅ Global search
4. ✅ Bulk operations (payouts)
5. ✅ Export functionality (CSV/PDF)
6. ✅ Audit logging
7. ✅ Testing & bug fixes

---

## Status Codes

- `200 OK` - Success
- `201 Created` - Resource created
- `204 No Content` - Success, no response body
- `400 Bad Request` - Validation error
- `401 Unauthorized` - Not authenticated
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Business logic conflict (e.g., performer double-booked)
- `422 Unprocessable Entity` - Semantic error
- `500 Internal Server Error` - Server error

---

## Error Response Format

json

`{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "client_email",
        "message": "Invalid email format"
      }
    ]
  }
}`

---

This is your complete API specification! Ready to move to **Session 5: Tech Stack Decisions**?
