# Meeting Notes #4: API Design

**Date:** September 30, 2025

**Attendees:** Joven Poblete

**Purpose:** Define exact API endpoints for Phase 1

---

## Base URL

`/api/v1`

## Authentication

All endpoints require JWT except `/auth/login`

Format: `Authorization: Bearer <token>`

---

## Core Endpoints

### 1. Authentication & Users

```
POST   /api/auth/login
POST   /api/auth/logout
GET    /api/auth/me
POST   /api/auth/refresh-token

GET    /api/users                    # Admin only
GET    /api/users/:id
POST   /api/users                    # Admin only
PATCH  /api/users/:id
DELETE /api/users/:id                # Admin only
PATCH  /api/users/:id/password
```

### 2. Dashboard

```
GET    /api/dashboard
```

Returns: new inquiries, quoted inquiries, upcoming events, overdue deposits, stats, notifications

### 3. Inquiries

```
POST   /api/inquiries
GET    /api/inquiries                # Filters: status, date range, source
GET    /api/inquiries/:id
PATCH  /api/inquiries/:id
DELETE /api/inquiries/:id            # Soft delete

POST   /api/inquiries/:id/quote      # Add quote
GET    /api/inquiries/:id/quotes     # Quote history
PATCH  /api/inquiries/:id/status     # Change status
POST   /api/inquiries/:id/convert-to-booking
```

**Status Change Behavior:**

- Lost reason OPTIONAL (dropdown: budget, date, found_alternative, event_cancelled, no_response, other)
- When status → "confirmed": API prompts user to create booking (doesn't auto-create)

### 4. Bookings

```
POST   /api/bookings
GET    /api/bookings                 # Filters: status, date range
GET    /api/bookings/:id
PATCH  /api/bookings/:id
DELETE /api/bookings/:id             # Cancel

POST   /api/bookings/:id/performers  # Assign performer
DELETE /api/bookings/:id/performers/:performer_id

PATCH  /api/bookings/:id/deposit
PATCH  /api/bookings/:id/final-payment
PATCH  /api/bookings/:id/invoice
```

**Conflict Detection:**

- Assigning performer checks for date/time conflicts
- Returns 409 Conflict with details of conflicting booking
- Does NOT block assignment (admin can override)

### 5. Performers

```
GET    /api/performers
GET    /api/performers/:id
POST   /api/performers
PATCH  /api/performers/:id
DELETE /api/performers/:id           # Deactivate

GET    /api/performers/availability?date=YYYY-MM-DD
```

### 6. Clients

```
GET    /api/clients
GET    /api/clients/:id              # Includes booking history
POST   /api/clients
PATCH  /api/clients/:id
DELETE /api/clients/:id              # Soft delete
```

### 7. Packages

```
GET    /api/packages
GET    /api/packages/:id
POST   /api/packages
PATCH  /api/packages/:id
DELETE /api/packages/:id             # Deactivate
```

### 8. Financial Reports

```
GET    /api/reports/financial?start_date=...&end_date=...
```

Returns: revenue, expenses (performer payouts + overhead), profit, outstanding balances

### 9. Expenses

```
GET    /api/expenses                 # Filters: category, date range
GET    /api/expenses/:id
POST   /api/expenses
PATCH  /api/expenses/:id
DELETE /api/expenses/:id
```

### 10. Performer Payouts

```
GET    /api/payouts                  # Grouped by performer
GET    /api/payouts/outstanding
PATCH  /api/payouts/:id              # Mark as paid
PATCH  /api/payouts/bulk-pay         # Bulk payment
```

### 11. Notifications

```
GET    /api/notifications
GET    /api/notifications/unread
PATCH  /api/notifications/:id/read
PATCH  /api/notifications/mark-all-read
DELETE /api/notifications/:id
```

### 12. Calendar

```
GET    /api/calendar?start_date=...&end_date=...&view=month|week
```

### 13. Search

```
GET    /api/search?q=...&type=all|inquiries|bookings|clients|performers
```

### 14. Export

```
GET    /api/export/inquiries?format=csv|pdf&...filters
GET    /api/export/bookings?format=csv|pdf&...filters
GET    /api/export/financial?format=csv|pdf&start_date=...&end_date=...
```

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

```json
{
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
}
```

---

## Implementation Order (4 weeks)

**Week 1: Foundation**

- Database + migrations
- Auth system
- User management
- Inquiries CRUD
- Basic validation

**Week 2: Core Workflow**

- Bookings CRUD
- Performers CRUD
- Clients CRUD
- Packages CRUD
- Inquiry quoting + history
- Inquiry → Booking conversion
- Assign performers with conflict detection

**Week 3: Financial Tracking**

- Payment tracking
- Performer payouts
- Expenses CRUD
- Financial reports
- Dashboard endpoint

**Week 4: Polish & Features**

- Notifications
- Calendar view
- Global search
- Bulk operations
- Export functionality
- Audit logging
- Testing & bug fixes

---

## Next Steps

- Finalize tech stack → Session 5
- Create development plan → Session 6