# Session 6: Development Plan

**Date:** September 30, 2025

**Timeline:** 4 weeks (Oct 1 - Oct 28, 2025)

**Capacity:** 30-40 hours/week

**Approach:** Backend-first, then frontend

---

## Overview

**Phase 1 Goal:** Ship working admin MVP with full inquiry-to-booking workflow, financial tracking, and performer management.

**Key Principles:**

- Backend-first: Build and test complete API before starting frontend
- Test thoroughly: Use Postman/Thunder Client for all endpoints
- Commit often: Clear commit messages, push daily
- Document as you go: Add comments, update README

---

## Week 1: Backend Foundation (30-40 hrs)

**Goal:** Database + Auth + Core CRUD working

### Monday-Tuesday (8-10 hrs): Project Setup

**Repository & Monorepo**

- [ ] Create GitHub repo `ohana-bookings`
- [ ] Initialize pnpm workspace
- [ ] Configure Turborepo (`turbo.json`)
- [ ] Create folder structure:
  ```
  ohana-bookings/
  ├── apps/
  │   ├── api/          # NestJS backend
  │   └── frontend/     # Vue 3 (empty for now)
  ├── packages/
  │   ├── types/        # Shared TypeScript types
  │   └── config/       # Shared configs
  ├── turbo.json
  └── package.json
  ```

**Backend Setup**

- [ ] Initialize NestJS app: `nest new api`
- [ ] Install dependencies:
  ```bash
  pnpm add drizzle-orm pg
  pnpm add -D drizzle-kit @types/pg
  pnpm add @nestjs/passport @nestjs/jwt passport passport-jwt
  pnpm add @nestjs/config class-validator class-transformer
  pnpm add bcrypt
  ```
- [ ] Configure ESLint + Prettier
- [ ] Create `.env.example`

**Database Setup**

- [ ] Create `docker-compose.yml` (PostgreSQL + Redis)

  ```yaml
  services:
    postgres:
      image: postgres:16-alpine
      environment:
        POSTGRES_DB: ohana_dev
        POSTGRES_USER: postgres
        POSTGRES_PASSWORD: postgres
      ports:
        - '5432:5432'
      volumes:
        - postgres_data:/var/lib/postgresql/data

    redis:
      image: redis:7-alpine
      ports:
        - '6379:6379'
  ```

- [ ] Start Docker: `docker-compose up -d`
- [ ] Configure Drizzle connection
- [ ] Test database connection

**Deliverable:** ✅ Monorepo initialized, NestJS running, database connected

---

### Wednesday-Thursday (8-10 hrs): Authentication System

**Users Schema**

- [ ] Create `src/db/schema/users.ts`:
  ```tsx
  export const users = pgTable('users', {
    id: uuid('id').primaryKey().defaultRandom(),
    email: varchar('email', { length: 255 }).notNull().unique(),
    password_hash: varchar('password_hash', { length: 255 }).notNull(),
    first_name: varchar('first_name', { length: 100 }).notNull(),
    last_name: varchar('last_name', { length: 100 }).notNull(),
    phone: varchar('phone', { length: 20 }),
    roles: varchar('roles', { length: 50 }).array().notNull(), // ['admin', 'coordinator', 'performer']
    performer_id: uuid('performer_id'), // Links to performers table (nullable)
    is_active: boolean('is_active').default(true).notNull(),
    created_at: timestamp('created_at').defaultNow().notNull(),
    updated_at: timestamp('updated_at').defaultNow().notNull(),
  })
  ```
- [ ] Run migration: `drizzle-kit generate` + `drizzle-kit push`
- [ ] Create seed script: Insert admin user (you)

**Auth Module**

- [ ] Create `AuthModule`, `AuthService`, `AuthController`
- [ ] Implement JWT strategy (Passport)
- [ ] Create guards:
  - `JwtAuthGuard` (requires valid token)
  - `RolesGuard` (checks user roles)
- [ ] Create decorators:
  - `@Public()` (skip auth)
  - `@Roles('admin', 'coordinator')` (role check)
  - `@CurrentUser()` (get user from request)

**Auth Endpoints**

- [ ] `POST /api/auth/login` - Returns access token + refresh token (httpOnly cookie)
- [ ] `POST /api/auth/logout` - Clears refresh token cookie
- [ ] `GET /api/auth/me` - Returns current user info
- [ ] `POST /api/auth/refresh` - Issues new access token from refresh token

**Testing**

- [ ] Test login with Postman (get tokens)
- [ ] Test protected route with token
- [ ] Test refresh token flow
- [ ] Test logout

**Deliverable:** ✅ Full auth system working, tested with Postman

---

### Friday-Sunday (14-20 hrs): Core Entity Schemas + CRUD

**Database Schemas**

Create all core schemas in `src/db/schema/`:

1. **Clients** (`clients.ts`)

   ```tsx
   export const clients = pgTable('clients', {
     id: uuid('id').primaryKey().defaultRandom(),
     name: varchar('name', { length: 255 }).notNull(),
     email: varchar('email', { length: 255 }),
     phone: varchar('phone', { length: 20 }),
     company: varchar('company', { length: 255 }),
     address: text('address'),
     notes: text('notes'),
     is_repeat_client: boolean('is_repeat_client').default(false),
     created_at: timestamp('created_at').defaultNow().notNull(),
     updated_at: timestamp('updated_at').defaultNow().notNull(),
   })
   ```

2. **Packages** (`packages.ts`)

   ```tsx
   export const packages = pgTable('packages', {
     id: uuid('id').primaryKey().defaultRandom(),
     name: varchar('name', { length: 255 }).notNull(),
     description: text('description'),
     default_price: decimal('default_price', { precision: 10, scale: 2 }),
     duration_minutes: integer('duration_minutes'),
     min_performers: integer('min_performers'),
     max_performers: integer('max_performers'),
     includes_fire: boolean('includes_fire').default(false),
     is_active: boolean('is_active').default(true).notNull(),
     display_order: integer('display_order').default(0),
     created_at: timestamp('created_at').defaultNow().notNull(),
     updated_at: timestamp('updated_at').defaultNow().notNull(),
   })
   ```

3. **Performers** (`performers.ts`)

   ```tsx
   export const performers = pgTable('performers', {
     id: uuid('id').primaryKey().defaultRandom(),
     user_id: uuid('user_id'), // Links to users table (nullable in Phase 1)
     first_name: varchar('first_name', { length: 100 }).notNull(),
     last_name: varchar('last_name', { length: 100 }).notNull(),
     email: varchar('email', { length: 255 }),
     phone: varchar('phone', { length: 20 }),
     skills: jsonb('skills'), // ["hula", "tahitian", "fire_knife", ...]
     default_rate: decimal('default_rate', { precision: 10, scale: 2 }),
     is_active: boolean('is_active').default(true).notNull(),
     notes: text('notes'),
     created_at: timestamp('created_at').defaultNow().notNull(),
     updated_at: timestamp('updated_at').defaultNow().notNull(),
   })
   ```

4. **Inquiries** (`inquiries.ts`)

   ```tsx
   export const inquiries = pgTable('inquiries', {
     id: uuid('id').primaryKey().defaultRandom(),
     client_id: uuid('client_id').notNull(),
     source: varchar('source', { length: 50 }).notNull(), // gigsalad, thebash, email, phone, website, referral, other
     event_type: varchar('event_type', { length: 100 }),
     event_date: date('event_date'),
     event_time: time('event_time'),
     event_duration_minutes: integer('event_duration_minutes'),
     venue_name: varchar('venue_name', { length: 255 }),
     venue_city: varchar('venue_city', { length: 100 }).notNull(),
     venue_state: varchar('venue_state', { length: 2 }),
     venue_address: text('venue_address'),
     expected_attendees: integer('expected_attendees'),
     special_requests: text('special_requests'),
     budget_range: varchar('budget_range', { length: 100 }),
     status: varchar('status', { length: 50 }).notNull().default('new'), // new, quoted, confirmed, lost
     lost_reason: varchar('lost_reason', { length: 100 }), // budget, date, found_alternative, event_cancelled, no_response, other
     created_by: uuid('created_by').notNull(),
     created_at: timestamp('created_at').defaultNow().notNull(),
     updated_at: timestamp('updated_at').defaultNow().notNull(),
   })
   ```

5. **Quote History** (`quote_history.ts`)

   ```tsx
   export const quoteHistory = pgTable('quote_history', {
     id: uuid('id').primaryKey().defaultRandom(),
     inquiry_id: uuid('inquiry_id').notNull(),
     package_id: uuid('package_id'),
     quoted_amount: decimal('quoted_amount', { precision: 10, scale: 2 }).notNull(),
     notes: text('notes'),
     quoted_by: uuid('quoted_by').notNull(),
     quoted_at: timestamp('quoted_at').defaultNow().notNull(),
   })
   ```

6. **Overhead Expenses** (`overhead_expenses.ts`)

   ```tsx
   export const overheadExpenses = pgTable('overhead_expenses', {
     id: uuid('id').primaryKey().defaultRandom(),
     description: varchar('description', { length: 255 }).notNull(),
     amount: decimal('amount', { precision: 10, scale: 2 }).notNull(),
     category: varchar('category', { length: 50 }).notNull(), // costumes, equipment, subscriptions, marketing, props, other
     expense_date: date('expense_date').notNull(),
     payment_method: varchar('payment_method', { length: 50 }), // paypal, credit_card, cash, check
     receipt_photo_url: varchar('receipt_photo_url', { length: 500 }),
     notes: text('notes'),
     created_by: uuid('created_by').notNull(),
     created_at: timestamp('created_at').defaultNow().notNull(),
     updated_at: timestamp('updated_at').defaultNow().notNull(),
   })
   ```

- [ ] Run migrations for all schemas
- [ ] Add foreign key relations in Drizzle schema

**CRUD Modules**

For each entity, create:

- Module (e.g., `ClientsModule`)
- Service (e.g., `ClientsService`)
- Controller (e.g., `ClientsController`)
- DTOs (Create, Update)

Endpoints for each:

- `POST /api/[entity]` - Create
- `GET /api/[entity]` - List (with pagination, filters)
- `GET /api/[entity]/:id` - Get by ID
- `PATCH /api/[entity]/:id` - Update
- `DELETE /api/[entity]/:id` - Soft delete (set is_active = false)

**Entities to implement:**

- [ ] Clients CRUD
- [ ] Packages CRUD
- [ ] Performers CRUD
- [ ] Inquiries CRUD
- [ ] Quote History endpoints (POST, GET by inquiry_id)
- [ ] Overhead Expenses CRUD

**Validation**

- [ ] Add class-validator decorators to all DTOs
- [ ] Add global validation pipe
- [ ] Test validation errors

**Testing**

- [ ] Create Postman collection
- [ ] Test all CRUD operations
- [ ] Test validation (invalid data should return 400)
- [ ] Test auth guards (endpoints require auth)

**Deliverable:** ✅ All core entities with working CRUD, tested with Postman

---

## Week 2: Backend Workflow Logic (30-40 hrs)

**Goal:** Bookings, assignments, payments, performer expenses working

### Monday-Tuesday (8-10 hrs): Bookings Core

**Bookings Schema**

- [ ] Create `bookings.ts`:

  ```tsx
  export const bookings = pgTable('bookings', {
    id: uuid('id').primaryKey().defaultRandom(),
    inquiry_id: uuid('inquiry_id'), // Nullable (can create booking without inquiry)
    client_id: uuid('client_id').notNull(),
    package_id: uuid('package_id'),

    // Event details
    event_type: varchar('event_type', { length: 100 }).notNull(),
    event_date: date('event_date').notNull(),
    event_time: time('event_time').notNull(),
    event_duration_minutes: integer('event_duration_minutes'),

    // Venue (denormalized from inquiry)
    venue_name: varchar('venue_name', { length: 255 }),
    venue_address: text('venue_address').notNull(),
    venue_city: varchar('venue_city', { length: 100 }).notNull(),
    venue_state: varchar('venue_state', { length: 2 }),
    venue_zip: varchar('venue_zip', { length: 10 }),

    // Client contact (denormalized snapshot)
    client_name: varchar('client_name', { length: 255 }).notNull(),
    client_email: varchar('client_email', { length: 255 }),
    client_phone: varchar('client_phone', { length: 20 }).notNull(),

    // Pricing
    quoted_price: decimal('quoted_price', { precision: 10, scale: 2 }).notNull(),
    final_price: decimal('final_price', { precision: 10, scale: 2 }),

    // Payments
    deposit_amount: decimal('deposit_amount', { precision: 10, scale: 2 }),
    deposit_paid: boolean('deposit_paid').default(false),
    deposit_paid_date: date('deposit_paid_date'),
    deposit_payment_method: varchar('deposit_payment_method', { length: 50 }),

    final_payment_amount: decimal('final_payment_amount', { precision: 10, scale: 2 }),
    final_payment_paid: boolean('final_payment_paid').default(false),
    final_payment_paid_date: date('final_payment_paid_date'),
    final_payment_method: varchar('final_payment_method', { length: 50 }),

    invoice_sent_date: date('invoice_sent_date'),

    // Status
    status: varchar('status', { length: 50 }).notNull().default('pending'), // pending, confirmed, completed, cancelled

    // Details
    special_requests: text('special_requests'),
    internal_notes: text('internal_notes'),

    created_by: uuid('created_by').notNull(),
    created_at: timestamp('created_at').defaultNow().notNull(),
    updated_at: timestamp('updated_at').defaultNow().notNull(),
  })
  ```

- [ ] Run migration

**Bookings Module**

- [ ] Create BookingsModule, Service, Controller
- [ ] Implement endpoints:
  - `POST /api/bookings` - Create booking
  - `GET /api/bookings` - List with filters (status, date range)
  - `GET /api/bookings/:id` - Get booking with performers
  - `PATCH /api/bookings/:id` - Update booking
  - `DELETE /api/bookings/:id` - Cancel booking (soft delete)
  - `POST /api/inquiries/:id/convert-to-booking` - Convert inquiry to booking
  - `PATCH /api/bookings/:id/deposit` - Record deposit payment
  - `PATCH /api/bookings/:id/final-payment` - Record final payment
  - `PATCH /api/bookings/:id/invoice` - Mark invoice sent

**Business Logic**

- [ ] When inquiry status → "confirmed", return prompt suggesting booking creation (don't auto-create)
- [ ] When converting inquiry to booking, copy relevant fields
- [ ] Validate: event_date cannot be in the past
- [ ] Validate: deposit + final_payment should equal final_price (warn if not)

**Testing**

- [ ] Test booking creation
- [ ] Test inquiry → booking conversion
- [ ] Test payment recording
- [ ] Test filtering by status, date range

**Deliverable:** ✅ Bookings CRUD working, inquiry conversion working

---

### Wednesday-Thursday (8-10 hrs): Performer Assignments

**Booking Performers Schema**

- [ ] Create `booking_performers.ts`:

  ```tsx
  export const bookingPerformers = pgTable('booking_performers', {
    id: uuid('id').primaryKey().defaultRandom(),
    booking_id: uuid('booking_id').notNull(),
    performer_id: uuid('performer_id').notNull(),

    // Payout
    payout_amount: decimal('payout_amount', { precision: 10, scale: 2 }).notNull(),
    paid: boolean('paid').default(false),
    paid_date: date('paid_date'),
    payment_method: varchar('payment_method', { length: 50 }),

    // Assignment tracking
    notes: text('notes'),
    assigned_at: timestamp('assigned_at').defaultNow().notNull(),
    assigned_by: uuid('assigned_by').notNull(),
    created_at: timestamp('created_at').defaultNow().notNull(),
    updated_at: timestamp('updated_at').defaultNow().notNull(),
  }, (table) => {
    return {
      uniqueBookingPerformer: unique().on([table.booking](http://table.booking)_id, table.performer_id),
    };
  });
  ```

**Performer Expenses Schema**

- [ ] Create `performer_expenses.ts`:
  ```tsx
  export const performerExpenses = pgTable('performer_expenses', {
    id: uuid('id').primaryKey().defaultRandom(),
    booking_performer_id: uuid('booking_performer_id').notNull(),
    performer_id: uuid('performer_id').notNull(), // Redundant but useful for queries
    amount: decimal('amount', { precision: 10, scale: 2 }).notNull(),
    description: text('description').notNull(), // "Gas $45, dinner $30, parking $10"
    expense_date: date('expense_date').notNull(),
    receipt_photo_url: varchar('receipt_photo_url', { length: 500 }), // Phase 2
    created_by: uuid('created_by').notNull(), // Who logged this
    created_at: timestamp('created_at').defaultNow().notNull(),
    updated_at: timestamp('updated_at').defaultNow().notNull(),
  })
  ```
- [ ] Run migrations

**Assignments Module**

- [ ] Implement endpoints:
  - `POST /api/bookings/:id/performers` - Assign performer to booking
  - `DELETE /api/bookings/:id/performers/:performerId` - Remove performer
  - `GET /api/bookings/:id/performers` - List performers for booking
  - `PATCH /api/bookings/:id/performers/:performerId/payout` - Update payout info
  - `PATCH /api/payouts/:id/mark-paid` - Mark payout as paid
  - `POST /api/payouts/bulk-pay` - Mark multiple payouts as paid

**Performer Expenses Module**

- [ ] Implement endpoints:
  - `POST /api/performer-expenses` - Log expense (performer or admin)
  - `GET /api/performer-expenses` - List expenses (filtered by performer_id)
  - `GET /api/performer-expenses/:id` - Get expense details
  - `PATCH /api/performer-expenses/:id` - Update expense
  - `DELETE /api/performer-expenses/:id` - Delete expense

**Conflict Detection Logic**

- [ ] Before assigning performer, check for date/time conflicts:
  ```tsx
  // Check if performer already assigned to another booking on same date/time
  const conflicts = await findConflictingBookings(performerId, eventDate, eventTime, duration);
  if (conflicts.length > 0) {
    // Return 409 Conflict with details
    throw new ConflictException({
      message: 'Performer has conflicting booking',
      conflicts: [conflicts.map](http://conflicts.map)(b => ({
        bookingId: [b.id](http://b.id),
        eventDate: b.event_date,
        eventTime: b.event_time,
        clientName: b.client_name
      }))
    });
  }
  ```
- [ ] Frontend will show warning but allow override (admin decision)

**Permissions**

- [ ] Performers can only create/edit their OWN expenses
- [ ] Admins can view ALL performer expenses
- [ ] Coordinators CANNOT see performer expenses

**Testing**

- [ ] Test assigning performer to booking
- [ ] Test conflict detection (assign same performer to overlapping bookings)
- [ ] Test removing performer
- [ ] Test marking payout as paid
- [ ] Test bulk payout payment
- [ ] Test logging performer expense (admin for self)
- [ ] Test permissions (coordinator cannot see expenses)

**Deliverable:** ✅ Performer assignments working, conflict detection working, expense tracking working

---

### Friday-Sunday (14-20 hrs): Reports & Additional Features

**Dashboard Endpoint**

- [ ] `GET /api/dashboard` returns:
  ```tsx
  {
    newInquiriesCount: number,
    quotedInquiries: QuotedInquiry[], // Need follow-up
    upcomingEvents: UpcomingEvent[], // Next 30 days
    overdueDeposits: OverdueDeposit[],
    stats: {
      eventsThisMonth: number,
      revenueThisMonth: number,
      profitThisMonth: number,
      outstandingBalance: number,
    },
    recentNotifications: Notification[],
  }
  ```

**Financial Reports Endpoint**

- [ ] `GET /api/reports/financial?start_date&end_date` returns:
  ```tsx
  {
    revenue: {
      deposits: number,
      finalPayments: number,
      total: number,
    },
    expenses: {
      performerPayouts: number,
      overheadExpenses: number,
      total: number,
    },
    profit: number,
    outstandingPayments: {
      fromClients: number,
      toPerformers: number,
    },
  }
  ```

**Personal Performer Report Endpoint**

- [ ] `GET /api/reports/performer-earnings/:performerId?start_date&end_date` returns:
  ```tsx
  {
    performerId: string,
    performerName: string,
    grossPay: number,
    personalExpenses: number,
    netTakeHome: number,
    bookingsCount: number,
    bookings: [
      {
        bookingId: string,
        eventDate: string,
        clientName: string,
        payout: number,
        expenses: number,
        net: number,
      }
    ],
  }
  ```
- [ ] Permissions: Performers can only see their own, admins can see all

**All Performers Overview Endpoint**

- [ ] `GET /api/reports/all-performers?start_date&end_date` returns:
  ```tsx
  {
    performers: [
      {
        performerId: string,
        performerName: string,
        grossPay: number,
        personalExpenses: number,
        netTakeHome: number,
        bookingsCount: number,
      }
    ],
    totals: {
      totalPayouts: number,
      totalExpenses: number,
      totalNet: number,
    }
  }
  ```
- [ ] Admin only

**Payout Report Endpoint**

- [ ] `GET /api/reports/payouts?status=outstanding|paid&performer_id` returns:
  ```tsx
  {
    performers: [
      {
        performerId: string,
        performerName: string,
        totalOwed: number,
        bookings: [
          {
            bookingId: string,
            eventDate: string,
            payoutAmount: number,
            paid: boolean,
          },
        ],
      },
    ]
  }
  ```

**Calendar Endpoint**

- [ ] `GET /api/calendar?start_date&end_date&view=month|week` returns:
  ```tsx
  {
    events: [
      {
        bookingId: string,
        date: string,
        time: string,
        clientName: string,
        venueName: string,
        performers: string[], // Performer names
        status: string,
      }
    ]
  }
  ```

**Performer Availability Endpoint**

- [ ] `GET /api/performers/availability?date=YYYY-MM-DD` returns:
  ```tsx
  {
    performers: [
      {
        performerId: string,
        performerName: string,
        isAvailable: boolean,
        conflictingBooking?: {
          bookingId: string,
          eventTime: string,
          clientName: string,
        }
      }
    ]
  }
  ```

**Global Search Endpoint**

- [ ] `GET /api/search?q=query&type=all|inquiries|bookings|clients|performers` returns:
  ```tsx
  {
    inquiries: SearchResult[],
    bookings: SearchResult[],
    clients: SearchResult[],
    performers: SearchResult[],
  }
  ```
- [ ] Search across: client names, venue names, performer names, phone numbers, emails

**Notifications Schema**

- [ ] Create `notifications.ts`:
  ```tsx
  export const notifications = pgTable('notifications', {
    id: uuid('id').primaryKey().defaultRandom(),
    user_id: uuid('user_id').notNull(), // Who receives this
    type: varchar('type', { length: 50 }).notNull(), // new_inquiry, follow_up_reminder, deposit_overdue, event_reminder
    title: varchar('title', { length: 255 }).notNull(),
    message: text('message').notNull(),
    link: varchar('link', { length: 500 }), // URL to related entity
    is_read: boolean('is_read').default(false),
    created_at: timestamp('created_at').defaultNow().notNull(),
  })
  ```

**Notifications Module**

- [ ] Implement endpoints:
  - `GET /api/notifications` - List all for current user
  - `GET /api/notifications/unread` - Count + list unread
  - `PATCH /api/notifications/:id/read` - Mark as read
  - `PATCH /api/notifications/mark-all-read` - Mark all as read
  - `DELETE /api/notifications/:id` - Delete notification

**Notification Creation Logic**

- [ ] Create notification service with methods:
  - `createNewInquiryNotification()` - When inquiry created
  - `createFollowUpReminder()` - 3 days after quote (cron job)
  - `createDepositOverdueNotification()` - 7 days before event, no deposit (cron job)
  - `createEventReminder()` - 7 days before event (cron job)

**Export Endpoints**

- [ ] `GET /api/export/inquiries?format=csv&...filters`
- [ ] `GET /api/export/bookings?format=csv&...filters`
- [ ] `GET /api/export/financial?format=csv&start_date&end_date`
- [ ] Use library like `json2csv` for CSV generation

**Audit Log** (optional but recommended)

- [ ] Create `audit_log.ts` schema:
  ```tsx
  export const auditLog = pgTable('audit_log', {
    id: uuid('id').primaryKey().defaultRandom(),
    user_id: uuid('user_id').notNull(),
    action: varchar('action', { length: 50 }).notNull(), // create, update, delete
    entity_type: varchar('entity_type', { length: 50 }).notNull(), // booking, inquiry, etc.
    entity_id: uuid('entity_id').notNull(),
    changes: jsonb('changes'), // { before: {...}, after: {...} }
    created_at: timestamp('created_at').defaultNow().notNull(),
  })
  ```
- [ ] Add audit logging to critical actions (create/update bookings, payments, etc.)

**Testing**

- [ ] Test all report endpoints
- [ ] Test calendar endpoint
- [ ] Test search
- [ ] Test notifications CRUD
- [ ] Test export endpoints (download CSV)
- [ ] Verify permissions (coordinators can't see financial reports)

**Deliverable:** ✅ All backend endpoints working, thoroughly tested with Postman

---

## Week 2.5: API Polish + Frontend Setup (12-16 hrs)

**Goal:** Finalize API, deploy to staging, initialize frontend

### Monday-Tuesday (8-10 hrs): API Polish

**Pagination**

- [ ] Add pagination to all list endpoints:
  ```tsx
  // Query params: ?page=1&limit=20
  {
    data: T[],
    meta: {
      total: number,
      page: number,
      limit: number,
      totalPages: number,
    }
  }
  ```
- [ ] Apply to: inquiries, bookings, performers, clients, expenses, notifications

**Filters**

- [ ] Inquiries: status, source, date range
- [ ] Bookings: status, date range, performer_id
- [ ] Performers: is_active, skills
- [ ] Overhead expenses: category, date range

**Swagger Documentation**

- [ ] Install `@nestjs/swagger`
- [ ] Add decorators to all endpoints
- [ ] Add DTO decorators (`@ApiProperty`)
- [ ] Generate Swagger UI: `/api/docs`
- [ ] Test all endpoints in Swagger UI

**Error Handling**

- [ ] Create custom exception filters
- [ ] Consistent error response format:
  ```tsx
  {
    error: {
      code: 'VALIDATION_ERROR' | 'NOT_FOUND' | 'CONFLICT' | ...,
      message: string,
      details?: any[],
    }
  }
  ```
- [ ] Add proper HTTP status codes

**Integration Tests** (optional but recommended)

- [ ] Write tests for critical flows:
  - Auth flow (login, refresh, logout)
  - Inquiry → Booking conversion
  - Performer assignment with conflict detection
  - Payment recording
- [ ] Use Jest + Supertest

**Deploy to Railway (Staging)**

- [ ] Create Railway project
- [ ] Add PostgreSQL plugin
- [ ] Add Redis plugin
- [ ] Connect GitHub repo
- [ ] Configure environment variables
- [ ] Deploy API
- [ ] Test production build
- [ ] Verify database migrations run
- [ ] Create seed data (admin user)

**Deliverable:** ✅ API deployed to Railway staging, documented with Swagger

---

### Wednesday-Thursday (4-6 hrs): Frontend Setup

**Initialize Frontend**

- [ ] Create Vite + Vue 3 project:
  ```bash
  cd apps
  pnpm create vite frontend --template vue-ts
  ```
- [ ] Install dependencies:
  ```bash
  pnpm add vue-router pinia @pinia/colada axios
  pnpm add primevue primeicons
  pnpm add -D tailwindcss postcss autoprefixer
  ```

**Configure Tailwind**

- [ ] `npx tailwindcss init -p`
- [ ] Configure `tailwind.config.js`
- [ ] Add Tailwind directives to `main.css`

**Configure PrimeVue**

- [ ] Import PrimeVue in `main.ts`:

  ```tsx
  import PrimeVue from 'primevue/config'
  import 'primevue/resources/themes/lara-light-blue/theme.css'
  import 'primevue/resources/primevue.min.css'
  import 'primeicons/primeicons.css'

  app.use(PrimeVue)
  ```

**Configure Vue Router**

- [ ] Create `src/router/index.ts`
- [ ] Define routes (stub pages for now):
  ```tsx
  const routes = [
    { path: '/login', component: LoginView },
    { path: '/', component: DashboardView, meta: { requiresAuth: true } },
    { path: '/inquiries', component: InquiriesView, meta: { requiresAuth: true } },
    { path: '/bookings', component: BookingsView, meta: { requiresAuth: true } },
    // ...
  ]
  ```
- [ ] Add auth guard (redirect to login if not authenticated)

**Configure Pinia + Pinia Colada**

- [ ] Create Pinia instance
- [ ] Install Pinia Colada plugin
- [ ] Create auth store (`src/stores/auth.ts`):

  ```tsx
  export const useAuthStore = defineStore('auth', () => {
    const user = ref<User | null>(null);
    const accessToken = ref<string | null>(null);

    const isLoggedIn = computed(() => user.value !== null);
    const isAdmin = computed(() => user.value?.roles.includes('admin'));

    async function login(email: string, password: string) { ... }
    async function logout() { ... }
    async function fetchMe() { ... }

    return { user, accessToken, isLoggedIn, isAdmin, login, logout, fetchMe };
  });
  ```

**Create API Client**

- [ ] Create `src/api/client.ts`:

  ```tsx
  import axios from 'axios'
  import { useAuthStore } from '@/stores/auth'

  const apiClient = axios.create({
    baseURL:
      import.meta.env.VITE_API_URL || '[http://localhost:3000/api](http://localhost:3000/api)',
  })

  // Add auth token to requests
  apiClient.interceptors.request.use((config) => {
    const authStore = useAuthStore()
    if (authStore.accessToken) {
      config.headers.Authorization = `Bearer ${authStore.accessToken}`
    }
    return config
  })

  // Handle 401 (refresh token)
  apiClient.interceptors.response.use(
    (response) => response,
    async (error) => {
      if (error.response?.status === 401) {
        // Try to refresh token
        await refreshAccessToken()
        // Retry original request
        return apiClient(error.config)
      }
      return Promise.reject(error)
    }
  )

  export default apiClient
  ```

**Create Base Layout**

- [ ] Create `src/layouts/MainLayout.vue`:
  - Top navbar (logo, user menu, notifications)
  - Left sidebar (navigation menu)
  - Main content area (router-view)
- [ ] Create `src/components/Navigation.vue` (sidebar menu)
- [ ] Create `src/components/UserMenu.vue` (user dropdown)

**Create Stub Pages**

- [ ] `src/views/LoginView.vue` (empty form for now)
- [ ] `src/views/DashboardView.vue` (empty dashboard)
- [ ] `src/views/InquiriesView.vue`
- [ ] `src/views/BookingsView.vue`
- [ ] Other entity views (empty for now)

**Environment Variables**

- [ ] Create `.env.development`:
  ```
  VITE_API_URL=[http://localhost:3000/api](http://localhost:3000/api)
  ```
- [ ] Create `.env.production`:
  ```
  VITE_API_URL=[https://your-api.railway.app/api](https://your-api.railway.app/api)
  ```

**Test Frontend Build**

- [ ] Run dev server: `pnpm dev`
- [ ] Verify routing works
- [ ] Verify PrimeVue components load
- [ ] Verify Tailwind styles work

**Deliverable:** ✅ Frontend scaffolding complete, ready to build features

---

## Week 3: Frontend Core Features (30-40 hrs)

**Goal:** Login + all main CRUD screens working

### Monday-Tuesday (8-10 hrs): Auth + Dashboard

**Login Page**

- [ ] Create `LoginView.vue`:
  - Email input (PrimeVue InputText)
  - Password input (PrimeVue Password)
  - Login button
  - Error message display
- [ ] Connect to auth store
- [ ] On successful login, redirect to dashboard
- [ ] Show error toast on failed login

**Dashboard Page**

- [ ] Create `DashboardView.vue` with widgets:
  - New Inquiries card (count + list)
  - Quoted Inquiries card (need follow-up)
  - Upcoming Events card (next 30 days)
  - Overdue Deposits card
  - Stats cards (events this month, revenue, profit, outstanding)
- [ ] Use Pinia Colada to fetch dashboard data:
  ```tsx
  const { data: dashboard, isLoading } = useQuery({
    key: ['dashboard'],
    query: () => api.getDashboard(),
  })
  ```
- [ ] Use PrimeVue Card, DataTable for widgets

**Main Layout**

- [ ] Implement Navigation sidebar:
  - Dashboard
  - Inquiries
  - Bookings
  - Performers
  - Clients
  - Packages
  - Financial Reports
  - Users (admin only)
- [ ] Implement UserMenu dropdown:
  - Profile
  - Settings
  - Logout
- [ ] Add notifications bell icon (shows unread count)
- [ ] Create NotificationsDropdown component (list recent notifications)

**Toast Service**

- [ ] Configure PrimeVue Toast
- [ ] Create composable `useToast()` for showing messages
- [ ] Use throughout app for success/error messages

**Deliverable:** ✅ Can log in, see dashboard with real data

---

### Wednesday-Thursday (8-10 hrs): Inquiries + Bookings

**Inquiries List**

- [ ] Create `InquiriesListView.vue`:
  - PrimeVue DataTable with columns: Client, Event Date, Venue, Status, Source
  - Filters: Status dropdown, Date range, Source dropdown
  - Pagination
  - Search bar
  - Actions: View, Edit, Delete
  - "Create Inquiry" button
- [ ] Fetch data with Pinia Colada:
  ```tsx
  const { data: inquiries, isLoading } = useQuery({
    key: ['inquiries', filters],
    query: () => api.getInquiries(filters.value),
  })
  ```

**Create/Edit Inquiry Form**

- [ ] Create `InquiryFormModal.vue`:
  - All inquiry fields (client info, event details, venue, etc.)
  - Client dropdown (searchable, can create new)
  - Validation
  - Save button
- [ ] Use Pinia Colada mutation:
  ```tsx
  const { mutate: createInquiry } = useMutation({
    mutation: (data) => api.createInquiry(data),
    onSuccess: () => {
      toast.success('Inquiry created')
      queryClient.invalidateQueries(['inquiries'])
    },
  })
  ```

**Inquiry Detail View**

- [ ] Create `InquiryDetailView.vue`:
  - Show all inquiry details
  - Quote History section (list all quotes)
  - "Add Quote" button → opens QuoteModal
  - "Change Status" dropdown (new, quoted, confirmed, lost)
  - If status → "confirmed", show "Convert to Booking" button
  - If status → "lost", show "Lost Reason" dropdown

**Quote Modal**

- [ ] Create `QuoteModal.vue`:
  - Package dropdown (optional)
  - Quoted amount input
  - Notes textarea
  - Save button
- [ ] On save, add to quote history

**Bookings List**

- [ ] Create `BookingsListView.vue`:
  - DataTable with columns: Client, Event Date, Venue, Status, Performers, Amount
  - Filters: Status, Date range
  - Actions: View, Edit, Cancel
  - "Create Booking" button

**Create/Edit Booking Form**

- [ ] Create `BookingFormView.vue` (full page, not modal - lots of fields):
  - Client selection (searchable dropdown)
  - Event details (type, date, time, duration)
  - Venue details (name, full address)
  - Package selection (optional, prefills pricing)
  - Pricing (quoted price, final price)
  - Special requests
  - Internal notes
  - Save button
- [ ] Validation: event_date cannot be in past

**Booking Detail View**

- [ ] Create `BookingDetailView.vue`:
  - Show all booking details
  - Performers section (list assigned performers)
  - "Assign Performer" button
  - Payments section (deposit, final payment)
  - "Record Payment" buttons
  - Edit booking button

**Deliverable:** ✅ Full inquiry and booking CRUD working

---

### Friday-Sunday (14-20 hrs): Performers, Assignments, Other Entities

**Performers List**

- [ ] Create `PerformersListView.vue`:
  - DataTable: Name, Email, Phone, Skills, Default Rate, Active
  - Filter: Active/Inactive, Skills
  - Actions: View, Edit, Deactivate
  - "Create Performer" button

**Create/Edit Performer Form**

- [ ] Create `PerformerFormModal.vue`:
  - Name, email, phone
  - Skills (multi-select: hula, tahitian, maori, fijian, samoan, fire_knife, fire_poi, fire_staff)
  - Default rate
  - Notes
  - Link to user account (dropdown, optional for Phase 1)

**Assign Performer to Booking**

- [ ] Create `AssignPerformerModal.vue`:
  - Performer dropdown (searchable)
  - Payout amount input
  - Notes
  - "Check Availability" button (shows conflicts if any)
  - Save button
- [ ] On save, if conflict detected:
  - Show warning dialog with conflict details
  - "Assign Anyway" or "Cancel" buttons

**Performer Payouts View**

- [ ] Create `PayoutsView.vue`:
  - Grouped by performer
  - Show: Performer name, Total owed, Bookings list
  - Each booking shows: Event date, Client, Payout amount, Paid status
  - "Mark as Paid" button (individual)
  - Checkbox select multiple + "Mark Selected as Paid" button (bulk)

**Log Performer Expense**

- [ ] Create `LogExpenseModal.vue`:
  - Booking dropdown (your bookings only, or all if admin)
  - Amount input
  - Description textarea ("Gas $45, dinner $30")
  - Expense date
  - Save button
- [ ] Permissions: Can only log for yourself unless admin

**View Performer Expenses**

- [ ] In BookingDetailView, add "Expenses" tab
- [ ] Show all expenses for that booking's performers
- [ ] Admin can see all, performer sees only their own

**Overhead Expenses List**

- [ ] Create `OverheadExpensesView.vue`:
  - DataTable: Description, Amount, Category, Date, Payment Method
  - Filter: Category, Date range
  - Actions: Edit, Delete
  - "Add Expense" button
- [ ] Admin only (coordinators cannot access)

**Create/Edit Overhead Expense**

- [ ] Create `OverheadExpenseFormModal.vue`:
  - Description input
  - Amount input
  - Category dropdown (costumes, equipment, subscriptions, marketing, props, other)
  - Expense date
  - Payment method dropdown
  - Notes

**Clients List**

- [ ] Create `ClientsListView.vue`:
  - DataTable: Name, Email, Phone, Company, Repeat Client
  - Search bar
  - Actions: View, Edit, Delete
  - "Create Client" button

**Create/Edit Client Form**

- [ ] Create `ClientFormModal.vue`:
  - Name, email, phone, company
  - Address (optional)
  - Notes

**Packages List**

- [ ] Create `PackagesListView.vue`:
  - DataTable: Name, Description, Default Price, Duration, Active
  - Actions: Edit, Deactivate, Reorder (display_order)
  - "Create Package" button

**Create/Edit Package Form**

- [ ] Create `PackageFormModal.vue`:
  - Name, description
  - Default price, duration
  - Min/max performers
  - Includes fire (checkbox)
  - Display order

**Users Management** (Admin only)

- [ ] Create `UsersListView.vue`:
  - DataTable: Name, Email, Roles, Active
  - Actions: Edit, Deactivate
  - "Create User" button

**Create/Edit User Form**

- [ ] Create `UserFormModal.vue`:
  - Name, email, phone
  - Roles (multi-select: admin, coordinator, performer)
  - Password (for new users only)
  - Link to performer (dropdown, if role includes performer)

**Deliverable:** ✅ All main screens working, can complete full workflow

---

## Week 4: Frontend Polish + Deployment (30-40 hrs)

**Goal:** Calendar, search, export, production deployment

### Monday-Tuesday (8-10 hrs): Calendar + Search

**Calendar View**

- [ ] Create `CalendarView.vue`:
  - Use PrimeVue FullCalendar component
  - Month and week views
  - Show all bookings as events
  - Color code by status (pending, confirmed, completed)
  - Click event to open BookingDetailModal
- [ ] Fetch calendar data:
  ```tsx
  const { data: events } = useQuery({
    key: ['calendar', dateRange],
    query: () => api.getCalendar(dateRange.value),
  })
  ```

**Global Search**

- [ ] Add search bar to main layout (top navbar)
- [ ] Create `GlobalSearchModal.vue`:
  - Search input with debounce
  - Results grouped by type (Inquiries, Bookings, Clients, Performers)
  - Click result to navigate to detail view
- [ ] Use Pinia Colada:
  ```tsx
  const { data: results } = useQuery({
    key: ['search', searchQuery],
    query: () => [api.search](http://api.search)(searchQuery.value),
    enabled: computed(() => searchQuery.value.length >= 3),
  });
  ```

**Filters on All Lists**

- [ ] Ensure all list views have appropriate filters:
  - Inquiries: Status, Source, Date range
  - Bookings: Status, Date range, Performer
  - Performers: Active, Skills
  - Clients: Search by name/email
  - Overhead Expenses: Category, Date range

**Notifications Page**

- [ ] Create `NotificationsView.vue`:
  - List all notifications
  - Filter: Unread only
  - Mark as read button
  - Mark all as read button
  - Delete notification button

**Deliverable:** ✅ Calendar working, search working, filters on all lists

---

### Wednesday-Thursday (8-10 hrs): UX Polish

**Loading States**

- [ ] Add skeleton loaders (PrimeVue Skeleton) to all data tables while loading
- [ ] Add spinners to buttons during mutation
- [ ] Add full-page loader for initial app load

**Error Handling**

- [ ] Show toast notifications for all errors
- [ ] Graceful error messages (not just "Error 500")
- [ ] Retry button for failed queries
- [ ] Offline detection (show banner if no connection)

**Form Validation**

- [ ] Add client-side validation to all forms
- [ ] Show inline error messages (PrimeVue Message)
- [ ] Disable submit button if form invalid
- [ ] Show server validation errors from API

**Confirm Dialogs**

- [ ] Add PrimeVue ConfirmDialog for destructive actions:
  - Delete inquiry
  - Cancel booking
  - Remove performer from booking
  - Delete expense
  - Deactivate user
- [ ] Show relevant details in confirm message

**Empty States**

- [ ] Add empty state messages when no data:
  - "No inquiries yet. Create your first inquiry!"
  - "No bookings found. Try adjusting filters."
  - Etc.
- [ ] Include relevant action button (e.g., "Create Inquiry")

**Responsive Design**

- [ ] Test all views on mobile/tablet
- [ ] Adjust layout for smaller screens:
  - Collapsible sidebar on mobile
  - Stack cards vertically
  - Responsive DataTables (horizontal scroll or cards)
- [ ] Use PrimeVue responsive utilities

**Accessibility**

- [ ] Ensure all forms are keyboard navigable
- [ ] Add ARIA labels where needed
- [ ] Test with screen reader (basic check)
- [ ] Ensure color contrast meets WCAG standards

**Performance**

- [ ] Lazy load routes (Vue Router lazy loading)
- [ ] Optimize images (if any)
- [ ] Check bundle size (should be reasonable)
- [ ] Test on slower connection (throttle network)

**Deliverable:** ✅ Polished UX, all edge cases handled

---

### Friday (6-8 hrs): Export + Testing

**Export Functionality**

- [ ] Add "Export to CSV" button on:
  - Inquiries list
  - Bookings list
  - Financial reports
- [ ] On click, trigger download:
  ```tsx
  async function exportInquiries() {
    const csv = await api.exportInquiries(filters.value)
    downloadFile(csv, 'inquiries.csv')
  }
  ```

**End-to-End Testing**

- [ ] Test complete workflow:
  1. Log in as admin
  2. Create inquiry
  3. Add quote
  4. Change status to "confirmed"
  5. Convert to booking
  6. Assign performers (test conflict detection)
  7. Record deposit payment
  8. Log performer expense (for yourself)
  9. Record final payment
  10. Mark performer payouts as paid
  11. View financial reports (verify profit calculation)

**Bug Fixes**

- [ ] Fix any bugs found during testing
- [ ] Test edge cases:
  - Very long text in fields
  - Special characters in input
  - Concurrent updates (two users editing same booking)
  - Network errors (API down)

**Improve Validation**

- [ ] Better error messages
- [ ] Add helpful hints (e.g., "Event date must be in the future")
- [ ] Validate file uploads (if any)

**Documentation**

- [ ] Update README with:
  - Project overview
  - Tech stack
  - Local development setup
  - Environment variables
  - How to seed data
  - Deployment instructions

**Deliverable:** ✅ Export working, all features tested, bugs fixed

---

### Saturday-Sunday (8-14 hrs): Production Deployment

**Prepare for Production**

- [ ] Review all environment variables
- [ ] Ensure no hardcoded values
- [ ] Remove console.logs and debug code
- [ ] Set up error tracking (optional: Sentry)
- [ ] Set up analytics (optional: Plausible, Simple Analytics)

**Deploy Backend to Railway (Production)**

- [ ] Create production Railway project (separate from staging)
- [ ] Add PostgreSQL plugin
- [ ] Add Redis plugin
- [ ] Configure production environment variables:
  ```
  NODE_ENV=production
  DATABASE_URL=...
  REDIS_URL=...
  JWT_SECRET=... (generate strong secret)
  JWT_REFRESH_SECRET=...
  FRONTEND_URL=... (Cloudflare Pages URL)
  ```
- [ ] Deploy API from main branch
- [ ] Run database migrations
- [ ] Verify deployment (check logs)
- [ ] Test API endpoints with Postman

**Seed Production Data**

- [ ] Create admin user (you)
- [ ] Create your performer record
- [ ] Link user to performer
- [ ] Create a few packages
- [ ] Test login

**Deploy Frontend to Cloudflare Pages**

- [ ] Create Cloudflare Pages project
- [ ] Connect GitHub repo
- [ ] Configure build settings:
  ```
  Build command: pnpm run build
  Build output directory: apps/frontend/dist
  Root directory: /
  ```
- [ ] Set environment variables:
  ```
  VITE_API_URL=[https://your-api.railway.app/api](https://your-api.railway.app/api)
  ```
- [ ] Deploy from main branch
- [ ] Verify deployment
- [ ] Test frontend (open Cloudflare Pages URL)

**Configure Custom Domain** (optional)

- [ ] Add custom domain to Cloudflare Pages (e.g., [`app.ohanaofpolynesia.com`](http://app.ohanaofpolynesia.com))
- [ ] Update DNS records
- [ ] Update CORS settings in backend to allow custom domain

**SSL/HTTPS**

- [ ] Verify Railway API has HTTPS
- [ ] Verify Cloudflare Pages has HTTPS
- [ ] Ensure httpOnly cookies work over HTTPS

**Full Production Testing**

- [ ] Test complete workflow on production:
  - Login
  - Create inquiry
  - Convert to booking
  - Assign performers
  - Record payments
  - Log expenses
  - View reports
  - Export data
- [ ] Test from multiple devices (desktop, mobile)
- [ ] Test from different browsers (Chrome, Firefox, Safari)

**Set Up Backups**

- [ ] Verify Railway automatic backups are enabled
- [ ] Test restoring from backup (optional but recommended)
- [ ] Document backup/restore process

**Monitoring**

- [ ] Set up uptime monitoring (optional: UptimeRobot, Betterstack)
- [ ] Set up error alerts (optional: Sentry)
- [ ] Monitor API response times (Railway dashboard)

**Final Documentation**

- [ ] Create user guide (optional: Notion doc)
- [ ] Document common workflows
- [ ] Create troubleshooting guide
- [ ] Share production URLs with stakeholders (yourself)

**Deliverable:** 🚀 **MVP LIVE IN PRODUCTION**

---

## Success Criteria (End of Week 4)

✅ **Authentication**

- Can log in with multiple roles (admin, coordinator, performer)
- JWT refresh token works
- Role-based access control enforced

✅ **Inquiry Management**

- Can create, edit, delete inquiries
- Can add quotes (multiple per inquiry)
- Can change inquiry status
- Lost reason tracking works

✅ **Booking Management**

- Can create bookings manually or from inquiry
- Can edit booking details
- Can cancel bookings
- Client info denormalized correctly

✅ **Performer Management**

- Can create, edit, deactivate performers
- Can assign performers to bookings
- Conflict detection warns of overlaps (doesn't block)
- Can remove performers from bookings

✅ **Payment Tracking**

- Can record deposit payments
- Can record final payments
- Can mark invoice as sent
- Outstanding balances calculated correctly

✅ **Payout Tracking**

- Can view all unpaid payouts
- Can mark individual payout as paid
- Can mark multiple payouts as paid (bulk)
- Payment method tracking works

✅ **Performer Expenses**

- Can log personal expenses (gas, food)
- Expenses tied to specific bookings
- Performers see only their own expenses
- Admins see all expenses

✅ **Overhead Expenses**

- Can log business expenses (costumes, equipment, subscriptions)
- Category tracking works
- Admin-only access enforced

✅ **Financial Reports**

- Business profit calculated correctly (revenue - all expenses)
- Personal take-home shows gross pay - personal expenses
- All performers overview shows everyone's earnings
- Date range filtering works

✅ **Dashboard**

- Shows new inquiries count
- Shows quoted inquiries needing follow-up
- Shows upcoming events
- Shows overdue deposits
- Shows accurate stats (revenue, profit, events count)

✅ **Calendar**

- Shows all bookings in month/week view
- Color-coded by status
- Click event to see details

✅ **Search & Filters**

- Global search works across all entities
- List filters work (status, date range, etc.)
- Search is fast and relevant

✅ **Notifications**

- In-app notifications work
- New inquiry notifications created
- Follow-up reminders work (cron job)
- Mark as read works

✅ **Export**

- Can export inquiries to CSV
- Can export bookings to CSV
- Can export financial report to CSV

✅ **UX**

- Loading states everywhere
- Error handling graceful
- Form validation helpful
- Confirm dialogs for destructive actions
- Empty states for no data
- Responsive on mobile/tablet

✅ **Deployment**

- Backend deployed to Railway (production)
- Frontend deployed to Cloudflare Pages
- HTTPS working
- Custom domain configured (optional)
- Database backups enabled
- Monitoring set up (optional)

---

## Phase 1.5 Preview (Weeks 5-6)

**Goal:** Add performer portal

After Phase 1 MVP is live and stable, add:

1. **Performer Logins**
   - External performers get user accounts
   - Login credentials sent via email
2. **Performer Portal**
   - View assigned bookings
   - Mark availability (calendar)
   - Log their own expenses
   - See their personal earnings (gross, expenses, net)
3. **Email Notifications**
   - Assigned to booking notification
   - Event reminder (7 days before)
   - Payout received notification
4. **Admin Enhancements**
   - See performer availability when assigning
   - Bulk email to all performers

---

## Tips for Success

**Daily Routine:**

1. Start with highest-priority task from plan
2. Work in focused blocks (Pomodoro: 25 min work, 5 min break)
3. Test as you go (don't wait until the end)
4. Commit code frequently with clear messages
5. Push to GitHub daily

**When Stuck:**

- Reference your past NestJS project
- Use AI copilot (GitHub Copilot, Claude, ChatGPT) for boilerplate
- Check official docs (NestJS, Vue, PrimeVue)
- Ask for help with specific error messages
- Take a break and come back with fresh eyes

**Quality Over Speed:**

- Don't rush
- Write clean code (future you will thank you)
- Add comments for complex logic
- Test edge cases
- Handle errors gracefully

**Celebrate Milestones:**

- End of Week 1: Auth working ✅
- End of Week 2: Complete API ✅
- End of Week 3: Full frontend ✅
- End of Week 4: Production deployment 🚀

---

## Next Session

Once Phase 1 is deployed, we can:

- Review what went well / what to improve
- Plan Phase 1.5 (performer portal)
- Plan Phase 2 (advanced features)
- Discuss marketing website
- Talk about future enhancements

**Good luck! You've got this! 🎉**
