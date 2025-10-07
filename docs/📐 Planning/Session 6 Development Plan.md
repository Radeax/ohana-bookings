# Session 6: Development Plan

**Timeline:** 4 weeks

**Hours/Week:** 30-40 hours

**Approach:** Backend-first (API complete before frontend)

**Goal:** Production-ready MVP with admin foundation

---

## Overview

### Backend-First Benefits

✅ **Solid foundation** - API fully tested before UI

✅ **No context switching** - Focus on one layer at a time

✅ **Better testing** - Use Postman/Thunder Client collections

✅ **Clear contracts** - API shapes finalized before frontend

✅ **Confidence** - Know the backend works before building UI

### Phase Breakdown

- **Week 1:** Backend foundation (setup, auth, core schemas)
- **Week 2:** Backend workflow (bookings, assignments, financials)
- **Week 2.5:** Backend polish + frontend setup
- **Week 3:** Frontend core features
- **Week 4:** Frontend polish + deployment

---

## Week 1: Backend Foundation (30-40 hrs)

**Goal:** Project setup + Auth + Core CRUD working

### Monday-Tuesday (8-10 hrs): Project Setup

- [ ] **Initialize monorepo**
  - [ ] `pnpm init` in root
  - [ ] Create `pnpm-workspace.yaml`
  - [ ] Install Turborepo: `pnpm add -D turbo`
  - [ ] Create `turbo.json` config
- [ ] **Create apps structure**
  - [ ] `mkdir -p apps/api apps/frontend packages/types packages/config`
  - [ ] Initialize NestJS: `cd apps/api && npx @nestjs/cli new .`
  - [ ] Keep frontend empty for now
- [ ] **Set up Docker Compose**
  - [ ] Create `docker-compose.yml` (PostgreSQL + Redis)
  - [ ] Start services: `docker-compose up -d`
  - [ ] Verify connections
- [ ] **Install Drizzle ORM**
  - [ ] `pnpm add drizzle-orm pg`
  - [ ] `pnpm add -D drizzle-kit @types/pg`
  - [ ] Create `drizzle.config.ts`
  - [ ] Create `src/db/` folder structure
- [ ] **Configure dev environment**
  - [ ] ESLint + Prettier configs
  - [ ] Create `.env.example`
  - [ ] Set up actual `.env` (not committed)
  - [ ] GitHub repo + initial commit

**Milestone:** ✅ Monorepo running, database connected

---

### Wednesday-Thursday (8-10 hrs): Authentication System

- [ ] **Users schema**
  - [ ] Create `src/db/schema/users.ts`
  - [ ] Define users table (roles array, performer_id)
  - [ ] Run migration: `drizzle-kit generate` + `drizzle-kit migrate`
  - [ ] Seed admin user
- [ ] **Auth module**
  - [ ] Install: `pnpm add @nestjs/passport @nestjs/jwt passport passport-jwt bcrypt`
  - [ ] Install types: `pnpm add -D @types/passport-jwt @types/bcrypt`
  - [ ] Generate: `nest g module auth && nest g service auth && nest g controller auth`
  - [ ] Implement JWT strategy
  - [ ] Create refresh token logic (httpOnly cookie)
- [ ] **Auth endpoints**
  - [ ] POST `/api/auth/login` (email/password → access + refresh tokens)
  - [ ] POST `/api/auth/logout` (clear refresh token cookie)
  - [ ] POST `/api/auth/refresh` (refresh token → new access token)
  - [ ] GET `/api/auth/me` (get current user)
- [ ] **Guards and decorators**
  - [ ] Create `JwtAuthGuard`
  - [ ] Create `@Roles()` decorator
  - [ ] Create `RolesGuard`
  - [ ] Test guards with Postman
- [ ] **Testing**
  - [ ] Test login flow (get tokens)
  - [ ] Test protected endpoint (use access token)
  - [ ] Test refresh flow (get new access token)
  - [ ] Test role-based access (admin vs coordinator)

**Milestone:** ✅ Can log in, auth guards working, tested with Postman

---

### Friday-Sunday (14-20 hrs): Core Schemas & CRUD

- [ ] **Database schemas**
  - [ ] `src/db/schema/clients.ts`
  - [ ] `src/db/schema/packages.ts`
  - [ ] `src/db/schema/performers.ts` (with user_id link)
  - [ ] `src/db/schema/inquiries.ts`
  - [ ] `src/db/schema/quote_history.ts`
  - [ ] Run migrations
- [ ] **Generate modules**
  - [ ] `nest g resource clients`
  - [ ] `nest g resource packages`
  - [ ] `nest g resource performers`
  - [ ] `nest g resource inquiries`
- [ ] **Implement CRUD operations**
  - [ ] Clients: Create, Read (list + single), Update, Delete (soft)
  - [ ] Packages: Create, Read, Update, Delete (deactivate)
  - [ ] Performers: Create, Read, Update, Delete (deactivate)
  - [ ] Inquiries: Create, Read, Update, Delete (soft)
  - [ ] Quote history: Create quote, Get all quotes for inquiry
- [ ] **Add validation**
  - [ ] Install: `pnpm add class-validator class-transformer`
  - [ ] Create DTOs for each resource
  - [ ] Add validation decorators (@IsEmail, @IsNotEmpty, etc.)
  - [ ] Enable global validation pipe in `main.ts`
- [ ] **Error handling**
  - [ ] Create global exception filter
  - [ ] Standardize error responses
  - [ ] Add custom business logic exceptions
- [ ] **Test all CRUD with Postman**
  - [ ] Create Postman collection
  - [ ] Test create operations
  - [ ] Test read operations (list with pagination)
  - [ ] Test update operations
  - [ ] Test delete operations
  - [ ] Test validation errors

**Milestone:** ✅ All core entities CRUD working, tested, validated

---

## Week 2: Backend Workflow Logic (30-40 hrs)

**Goal:** Bookings, assignments, payments, reports all working

### Monday-Tuesday (8-10 hrs): Bookings Core

- [ ] **Bookings schema**
  - [ ] Create `src/db/schema/bookings.ts`
  - [ ] All payment fields (deposit, final)
  - [ ] Invoice tracking fields
  - [ ] Run migration
- [ ] **Bookings module**
  - [ ] `nest g resource bookings`
  - [ ] Implement CRUD endpoints
  - [ ] Create booking DTO with validation
- [ ] **Inquiry → Booking conversion**
  - [ ] POST `/api/inquiries/:id/convert-to-booking`
  - [ ] Copy inquiry data to booking
  - [ ] Update inquiry status to 'confirmed'
  - [ ] Return new booking
- [ ] **Payment tracking**
  - [ ] PATCH `/api/bookings/:id/deposit` (record deposit payment)
  - [ ] PATCH `/api/bookings/:id/final-payment` (record final payment)
  - [ ] PATCH `/api/bookings/:id/invoice` (mark invoice sent)
- [ ] **Test booking flows**
  - [ ] Create booking from scratch
  - [ ] Convert inquiry to booking
  - [ ] Record payments
  - [ ] Mark invoice sent

**Milestone:** ✅ Booking creation + payment tracking working

---

### Wednesday-Thursday (8-10 hrs): Performer Assignments

- [ ] **Schema for assignments & expenses**
  - [ ] `src/db/schema/booking_performers.ts`
  - [ ] `src/db/schema/performer_expenses.ts` (NEW - personal expenses)
  - [ ] `src/db/schema/overhead_expenses.ts` (business expenses)
  - [ ] Run migrations
- [ ] **Assignment endpoints**
  - [ ] POST `/api/bookings/:id/performers` (assign performer)
  - [ ] DELETE `/api/bookings/:id/performers/:performerId` (remove)
  - [ ] GET `/api/bookings/:id/performers` (list assigned)
- [ ] **Conflict detection**
  - [ ] Check if performer already booked at same date/time
  - [ ] Return 409 Conflict with details
  - [ ] Allow admin to override (warning only)
- [ ] **Payout tracking**
  - [ ] PATCH `/api/booking-performers/:id/pay` (mark payout as paid)
  - [ ] POST `/api/payouts/bulk-pay` (mark multiple as paid)
  - [ ] GET `/api/payouts/outstanding` (list unpaid by performer)
- [ ] **Performer expenses (personal costs)**
  - [ ] POST `/api/performer-expenses` (log expense for a gig)
  - [ ] GET `/api/performer-expenses?performer_id=...&booking_id=...`
  - [ ] PATCH `/api/performer-expenses/:id` (edit expense)
  - [ ] DELETE `/api/performer-expenses/:id`
  - [ ] **Permissions:** Admin can log for anyone, performers for self (Phase 1.5)
- [ ] **Overhead expenses (business costs)**
  - [ ] POST `/api/overhead-expenses` (create expense)
  - [ ] GET `/api/overhead-expenses` (list with filters)
  - [ ] PATCH `/api/overhead-expenses/:id` (update)
  - [ ] DELETE `/api/overhead-expenses/:id`
  - [ ] **Permissions:** Admin only
- [ ] **Test all assignment flows**
  - [ ] Assign performer to booking
  - [ ] Try double-booking (should warn)
  - [ ] Remove performer assignment
  - [ ] Mark payout as paid
  - [ ] Log performer expense
  - [ ] Log overhead expense

**Milestone:** ✅ Performer assignments + expenses working

---

### Friday-Sunday (14-20 hrs): Reports & Business Logic

- [ ] **Dashboard endpoint**
  - [ ] GET `/api/dashboard`
  - [ ] New inquiries count
  - [ ] Quoted inquiries (with follow-up reminders)
  - [ ] Upcoming events (next 30 days)
  - [ ] Overdue deposits
  - [ ] Monthly stats (revenue, profit, events)
  - [ ] Recent notifications
- [ ] **Calendar endpoint**
  - [ ] GET `/api/calendar?start_date=...&end_date=...`
  - [ ] Return bookings grouped by date
  - [ ] Include performer assignments
  - [ ] Support month/week views
- [ ] **Financial reports**
  - [ ] GET `/api/reports/business-financials?start=...&end=...`
    - Revenue (deposits + finals)
    - Expenses (payouts + overhead)
    - Profit
    - Outstanding balances
  - [ ] GET `/api/reports/performer-earnings/:performerId?start=...&end=...`
    - Gross pay (all payouts)
    - Personal expenses
    - Net take-home
  - [ ] GET `/api/reports/all-performers?start=...&end=...` (admin only)
    - Summary for each performer
- [ ] **Payout reports**
  - [ ] GET `/api/payouts?status=outstanding`
  - [ ] GET `/api/payouts/by-performer`
  - [ ] Group by performer, show totals
- [ ] **Performer availability**
  - [ ] GET `/api/performers/availability?date=YYYY-MM-DD`
  - [ ] Check who's available on a date
  - [ ] Check who's already booked
- [ ] **Global search**
  - [ ] GET `/api/search?q=...&type=all|inquiries|bookings|clients|performers`
  - [ ] Search across multiple entities
  - [ ] Return results with entity type
- [ ] **Notifications**
  - [ ] Create notifications schema
  - [ ] Run migration
  - [ ] Implement notification creation logic
  - [ ] GET `/api/notifications` (list)
  - [ ] GET `/api/notifications/unread` (count)
  - [ ] PATCH `/api/notifications/:id/read`
  - [ ] PATCH `/api/notifications/mark-all-read`
  - [ ] DELETE `/api/notifications/:id`
- [ ] **Test all reports**
  - [ ] Create test bookings with payments
  - [ ] Assign performers with payouts
  - [ ] Log expenses (both types)
  - [ ] Verify dashboard calculations
  - [ ] Verify financial reports
  - [ ] Test calendar view
  - [ ] Test search

**Milestone:** ✅ Complete API working, all endpoints tested

---

## Week 2.5: API Polish + Frontend Setup (12-16 hrs)

**Goal:** Production-ready API + Frontend scaffolding

### Monday-Tuesday (8-10 hrs): API Polish

- [ ] **Add filters to list endpoints**
  - [ ] Inquiries: Filter by status, date range, source
  - [ ] Bookings: Filter by status, date range
  - [ ] Expenses: Filter by category, date range
  - [ ] Implement using query parameters
- [ ] **Pagination**
  - [ ] Add pagination to all list endpoints
  - [ ] Return: `{ data: [...], total: number, page: number, pageSize: number }`
  - [ ] Support `?page=1&pageSize=20`
- [ ] **Swagger/OpenAPI docs**
  - [ ] Install: `pnpm add @nestjs/swagger`
  - [ ] Add Swagger decorators to controllers
  - [ ] Configure Swagger in `main.ts`
  - [ ] Access at `/api/docs`
- [ ] **Export endpoints**
  - [ ] GET `/api/export/inquiries?format=csv&...filters`
  - [ ] GET `/api/export/bookings?format=csv&...filters`
  - [ ] GET `/api/export/financial?format=csv&start=...&end=...`
  - [ ] Generate CSV data
- [ ] **Audit logging**
  - [ ] Create audit_log schema
  - [ ] Run migration
  - [ ] Create audit logging interceptor
  - [ ] Log important actions (create booking, payment, etc.)
- [ ] **Integration tests**
  - [ ] Write tests for critical flows:
    - Inquiry → Quote → Booking
    - Assign performer with conflict
    - Record payments
    - Financial calculations
- [ ] **Deploy to Railway (staging)**
  - [ ] Create Railway project
  - [ ] Add PostgreSQL + Redis
  - [ ] Configure environment variables
  - [ ] Deploy API
  - [ ] Run migrations in production
  - [ ] Seed admin user
  - [ ] Test API in staging

**Milestone:** ✅ API deployed to staging, fully documented

---

### Wednesday-Thursday (4-6 hrs): Frontend Setup

- [ ] **Initialize Vite + Vue 3**
  - [ ] `cd apps/frontend && pnpm create vite . --template vue-ts`
  - [ ] Install dependencies
  - [ ] Remove boilerplate
- [ ] **Install UI libraries**
  - [ ] `pnpm add primevue primeicons`
  - [ ] `pnpm add -D tailwindcss postcss autoprefixer`
  - [ ] `npx tailwindcss init -p`
  - [ ] Configure Tailwind + PrimeVue
- [ ] **Install state management**
  - [ ] `pnpm add pinia @pinia/colada`
  - [ ] `pnpm add axios`
  - [ ] Configure Pinia in `main.ts`
- [ ] **Configure Vue Router**
  - [ ] `pnpm add vue-router`
  - [ ] Create `src/router/index.ts`
  - [ ] Define initial routes (login, dashboard placeholder)
  - [ ] Add route guards for auth
- [ ] **Create API client**
  - [ ] Create `src/api/client.ts` (axios instance)
  - [ ] Add interceptors (auth token, refresh logic)
  - [ ] Import types from `@ohana/types` package
- [ ] **Create auth store**
  - [ ] `src/stores/auth.ts` (Pinia store)
  - [ ] Login action
  - [ ] Logout action
  - [ ] Get current user
  - [ ] Token management (in memory)
- [ ] **Create layout components**
  - [ ] `src/layouts/MainLayout.vue` (header + sidebar)
  - [ ] `src/components/AppHeader.vue`
  - [ ] `src/components/AppSidebar.vue`
  - [ ] Basic structure, no styling yet

**Milestone:** ✅ Frontend setup complete, ready to build features

---

## Week 3: Frontend Core Features (30-40 hrs)

**Goal:** All main CRUD screens working

### Monday-Tuesday (8-10 hrs): Auth + Dashboard

- [ ] **Login page**
  - [ ] `src/views/Login.vue`
  - [ ] Email/password form (PrimeVue InputText, Button)
  - [ ] Call auth store login action
  - [ ] Show errors (Toast)
  - [ ] Redirect to dashboard on success
- [ ] **Auth guards**
  - [ ] Router beforeEach guard
  - [ ] Redirect to login if not authenticated
  - [ ] Check token on app load
- [ ] **Dashboard page**
  - [ ] `src/views/Dashboard.vue`
  - [ ] Fetch dashboard data (Pinia Colada)
  - [ ] Stats cards (revenue, events, profit)
  - [ ] New inquiries list widget
  - [ ] Upcoming events list widget
  - [ ] Quoted inquiries (follow-ups)
- [ ] **Main layout**
  - [ ] Implement navigation menu (sidebar)
  - [ ] User dropdown (logout)
  - [ ] Notifications dropdown (bell icon)
  - [ ] Apply PrimeVue theme

**Milestone:** ✅ Can log in, see dashboard with real data

---

### Wednesday-Thursday (8-10 hrs): Inquiries + Bookings

- [ ] **Inquiries list**
  - [ ] `src/views/Inquiries/InquiriesList.vue`
  - [ ] PrimeVue DataTable with sorting, filtering
  - [ ] Status badges (new, quoted, confirmed, lost)
  - [ ] Action buttons (view, edit, quote, convert)
  - [ ] Click row to view details
- [ ] **Create/edit inquiry**
  - [ ] `src/views/Inquiries/InquiryForm.vue`
  - [ ] Form with all inquiry fields (PrimeVue components)
  - [ ] Client autocomplete (search existing clients)
  - [ ] Validation (form validation)
  - [ ] Save inquiry (create or update)
- [ ] **Quote management**
  - [ ] Quote dialog/modal
  - [ ] Select package (prefills amount)
  - [ ] Enter custom amount
  - [ ] Notes field
  - [ ] Save quote (add to quote history)
  - [ ] Show quote history
- [ ] **Inquiry status changes**
  - [ ] Status dropdown
  - [ ] If 'lost': Show lost reason dropdown
  - [ ] If 'confirmed': Prompt to convert to booking
- [ ] **Bookings list**
  - [ ] `src/views/Bookings/BookingsList.vue`
  - [ ] DataTable with status, date, client, performers
  - [ ] Filter by status, date range
  - [ ] Click to view/edit
- [ ] **Create booking from inquiry**
  - [ ] Confirmation dialog
  - [ ] Call convert endpoint
  - [ ] Redirect to new booking page
- [ ] **Edit booking**
  - [ ] `src/views/Bookings/BookingForm.vue`
  - [ ] All booking fields
  - [ ] Payment status indicators
  - [ ] Record payment buttons
  - [ ] Save changes
- [ ] **Record payments**
  - [ ] Deposit payment modal
  - [ ] Final payment modal
  - [ ] Amount, method, date
  - [ ] Update booking

**Milestone:** ✅ Full inquiry → booking workflow working

---

### Friday-Sunday (14-20 hrs): Performers, Assignments, Expenses

- [ ] **Performers list**
  - [ ] `src/views/Performers/PerformersList.vue`
  - [ ] DataTable with skills, rate, status
  - [ ] Filter by active/inactive
  - [ ] Create/edit buttons
- [ ] **Create/edit performer**
  - [ ] `src/views/Performers/PerformerForm.vue`
  - [ ] Name, email, phone
  - [ ] Skills (MultiSelect)
  - [ ] Default rate
  - [ ] Notes
  - [ ] Save performer
- [ ] **Assign performers to booking**
  - [ ] In BookingForm, add "Assign Performers" section
  - [ ] Dropdown to select performer
  - [ ] Enter payout amount
  - [ ] Check availability (show conflicts as warning)
  - [ ] Add performer to booking
  - [ ] Show list of assigned performers
  - [ ] Remove performer button
- [ ] **Performer payouts view**
  - [ ] `src/views/Payouts/PayoutsList.vue`
  - [ ] Group by performer
  - [ ] Show: Performer name, gig count, total owed, paid status
  - [ ] Expandable rows (show individual gigs)
  - [ ] Mark as paid (individual or bulk)
- [ ] **Log performer expense**
  - [ ] In PayoutsList or booking details
  - [ ] "Log Expense" button for each gig
  - [ ] Modal: Amount, description, date
  - [ ] Save expense
  - [ ] Show expenses under each gig
  - [ ] **Phase 1:** Admin logs for any performer
  - [ ] **Phase 1.5:** Performers log their own
- [ ] **Overhead expenses**
  - [ ] `src/views/Expenses/ExpensesList.vue`
  - [ ] DataTable with date, description, amount, category
  - [ ] Filter by category, date range
  - [ ] Create expense button
  - [ ] Edit/delete actions
- [ ] **Create/edit overhead expense**
  - [ ] Modal or separate form
  - [ ] Description, amount, category, date, payment method
  - [ ] Save expense
- [ ] **Clients list**
  - [ ] `src/views/Clients/ClientsList.vue`
  - [ ] DataTable with name, email, booking count
  - [ ] Click to see booking history
  - [ ] Create/edit client
- [ ] **Packages list**
  - [ ] `src/views/Packages/PackagesList.vue`
  - [ ] DataTable with name, price, duration
  - [ ] Create/edit/deactivate
- [ ] **Users management**
  - [ ] `src/views/Users/UsersList.vue` (admin only)
  - [ ] DataTable with name, email, roles
  - [ ] Create user (set roles, link to performer if needed)
  - [ ] Edit user (update roles, reset password)
  - [ ] Deactivate user

**Milestone:** ✅ All entities manageable, full CRUD working

---

## Week 4: Frontend Polish + Deployment (30-40 hrs)

**Goal:** Production-ready UI, deployed

### Monday-Tuesday (8-10 hrs): Calendar + Search

- [ ] **Calendar view**
  - [ ] `src/views/Calendar/CalendarView.vue`
  - [ ] Use PrimeVue FullCalendar
  - [ ] Fetch bookings for date range
  - [ ] Show events on calendar
  - [ ] Click event to see details
  - [ ] Jump to booking edit
  - [ ] Month/week view toggle
- [ ] **Global search**
  - [ ] Search bar in header
  - [ ] Debounced search input
  - [ ] Call search endpoint
  - [ ] Show results in dropdown
  - [ ] Group by entity type
  - [ ] Click result to navigate
- [ ] **Filters on all lists**
  - [ ] Inquiries: Status, date range, source
  - [ ] Bookings: Status, date range
  - [ ] Expenses: Category, date range
  - [ ] Implement using query params
  - [ ] Clear filters button
- [ ] **Notifications page**
  - [ ] `src/views/Notifications/NotificationsList.vue`
  - [ ] List all notifications
  - [ ] Mark as read on click
  - [ ] Delete notification
  - [ ] Filter by type

**Milestone:** ✅ Calendar, search, notifications working

---

### Wednesday-Thursday (8-10 hrs): UX Polish

- [ ] **Loading states**
  - [ ] Skeleton loaders for lists (PrimeVue Skeleton)
  - [ ] Spinners for buttons during save
  - [ ] Progress bar for page navigation
- [ ] **Error handling**
  - [ ] Global error toast notifications
  - [ ] Form validation errors (inline)
  - [ ] API error messages (show to user)
  - [ ] 404 page
  - [ ] 403 page (unauthorized)
- [ ] **Confirm dialogs**
  - [ ] Delete confirmations (PrimeVue ConfirmDialog)
  - [ ] "Are you sure?" for important actions
  - [ ] Cancel booking confirmation
- [ ] **Empty states**
  - [ ] "No inquiries yet" message
  - [ ] "No bookings found" with CTA
  - [ ] Empty search results
- [ ] **Responsive design**
  - [ ] Test on mobile/tablet
  - [ ] Adjust DataTable for smaller screens
  - [ ] Mobile-friendly navigation

**Milestone:** ✅ Professional UX, handles all edge cases

---

### Friday (6-8 hrs): Export + Final Testing

- [ ] **Export functionality**
  - [ ] Export buttons on lists (inquiries, bookings, expenses)
  - [ ] Download CSV file
  - [ ] Financial report export
  - [ ] Show download toast
- [ ] **End-to-end testing**
  - [ ] Complete workflow tests:
    1. Create inquiry
    2. Quote inquiry
    3. Convert to booking
    4. Assign performers
    5. Log performer expense
    6. Record payments
    7. Mark payouts as paid
    8. View financial reports
  - [ ] Test as different roles (admin, coordinator)
  - [ ] Test edge cases (validation, conflicts, errors)
- [ ] **Bug fixes**
  - [ ] Fix any bugs found during testing
  - [ ] Improve validation messages
  - [ ] Polish UI inconsistencies

**Milestone:** ✅ Tested, polished, ready for production

---

### Saturday-Sunday (8-14 hrs): Production Deployment

- [ ] **Railway production setup**
  - [ ] Create production Railway project
  - [ ] Add PostgreSQL (production tier)
  - [ ] Add Redis
  - [ ] Configure production env vars
  - [ ] Set up automatic backups
- [ ] **Deploy API to Railway**
  - [ ] Connect GitHub repo
  - [ ] Configure build command
  - [ ] Deploy
  - [ ] Run migrations in production
  - [ ] Seed admin user
  - [ ] Test API endpoints (Postman)
- [ ] **Cloudflare Pages setup**
  - [ ] Create Cloudflare Pages project
  - [ ] Connect GitHub repo (apps/frontend)
  - [ ] Configure build command: `pnpm build`
  - [ ] Set output directory: `dist`
  - [ ] Add environment variable: `VITE_API_URL`
- [ ] **Deploy frontend to Cloudflare**
  - [ ] Push to GitHub (triggers deploy)
  - [ ] Wait for build
  - [ ] Test deployed frontend
  - [ ] Verify API connection
- [ ] **Production testing**
  - [ ] Create real admin user
  - [ ] Test login
  - [ ] Create test inquiry
  - [ ] Create test booking
  - [ ] Test all critical flows
  - [ ] Verify financial calculations
- [ ] **Documentation**
  - [ ] Update README with:
    - Project overview
    - Tech stack
    - Local dev setup
    - Deployment instructions
  - [ ] API documentation (Swagger URL)
  - [ ] User guide (basic how-to)
- [ ] **Monitoring setup**
  - [ ] Check Railway logs
  - [ ] Set up error alerts (if available)
  - [ ] Monitor performance

**Final Milestone:** 🚀 **Production MVP live and working!**

---

## Success Criteria (End of Week 4)

### Functional Requirements

✅ Can log in with multiple roles (admin + coordinator + performer)

✅ Can create inquiry → quote → booking

✅ Can assign performers with conflict warnings

✅ Can record payments (deposit + final)

✅ Can track performer payouts

✅ Can log performer expenses (personal gig costs)

✅ Can log overhead expenses (business costs)

✅ Dashboard shows accurate business financials

✅ Can view personal take-home (gross - expenses)

✅ Calendar shows all bookings

✅ Can search and filter everywhere

✅ Can export data to CSV

✅ Notifications work

✅ Deployed to production

### Technical Requirements

✅ Type-safe contracts (shared types package)

✅ Authentication working (JWT + refresh tokens)

✅ Role-based permissions enforced

✅ Database migrations versioned

✅ API documented (Swagger)

✅ Error handling throughout

✅ Responsive UI

✅ Automated deployment

---

## Tips for Success

### Daily Workflow

1. **Pick 1-2 tasks** from the plan each day
2. **Backend first** - Always implement API endpoint before UI
3. **Test immediately** - Use Postman after each endpoint
4. **Commit often** - Small, focused commits
5. **Use AI** - Let copilot handle boilerplate

### When Stuck

- Reference your past NestJS project
- Check Notion docs (ADRs, API spec, schema)
- Use AI for specific questions
- Take breaks (Pomodoro technique)

### Avoiding Pitfalls

⚠️ **Don't over-engineer** - Keep it simple for MVP

⚠️ **Don't skip testing** - Test each endpoint immediately

⚠️ **Don't context switch** - Finish backend before frontend

⚠️ **Don't deploy without testing** - Test locally first

---

## Next: Phase 1.5 (Weeks 5-6)

After Phase 1 MVP ships:

- Performer logins (link existing performers to users)
- Performer portal (view schedule, log own expenses)
- Availability calendar
- Email notifications

**Estimated:** 2 weeks, 20-30 hours/week

---

## Key Differences from Original Plan

✅ **Backend-first approach** - Complete API before UI

✅ **30-40 hrs/week** - More time, more thorough

✅ **Performer expenses separate** - Not reimbursements

✅ **Overhead expenses included** - Business costs tracked

✅ **Multi-role users** - Array of roles, user-performer link

✅ **Week 2.5 added** - API polish + frontend setup buffer

This plan sets you up for **sustainable development velocity** while building a **production-quality application**. Good luck! 🚀
