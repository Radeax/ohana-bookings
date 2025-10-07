# Week 3: Frontend Core Features

**Goal:** All main CRUD screens working

**Hours:** 30-40 hours

---

## Monday-Tuesday (8-10 hrs)

### Auth + Dashboard

### Login Page

- [ ] Create `src/views/Login.vue`
- [ ] Email/password form (PrimeVue InputText, Button)
- [ ] Call auth store login action
- [ ] Show error toast on failure
- [ ] Redirect to dashboard on success
- [ ] Test login flow end-to-end

### Auth Guards

- [ ] Create router `beforeEach` guard
- [ ] Redirect to login if not authenticated
- [ ] Check token validity on app load
- [ ] Handle token refresh
- [ ] Test protected routes

### Dashboard Page

- [ ] Create `src/views/Dashboard.vue`
- [ ] Fetch dashboard data using Pinia Colada
- [ ] Create stats cards (revenue, events, profit, outstanding)
- [ ] New inquiries list widget
- [ ] Upcoming events list widget
- [ ] Quoted inquiries widget (follow-ups needed)
- [ ] Overdue deposits widget
- [ ] Use PrimeVue Card, DataTable
- [ ] Test dashboard with real data

### Main Layout

- [ ] Implement Navigation sidebar with all menu items
- [ ] Implement UserMenu dropdown (Profile, Settings, Logout)
- [ ] Add notifications bell icon (shows unread count)
- [ ] Create NotificationsDropdown component
- [ ] Apply PrimeVue theme
- [ ] Test navigation works

### Toast Service

- [ ] Configure PrimeVue Toast
- [ ] Create composable `useToast()` for messages
- [ ] Test success/error toasts

**Milestone:** ✅ Can log in, see dashboard with real data

---

## Wednesday-Thursday (8-10 hrs)

### Inquiries + Bookings

### Inquiries List

- [ ] Create `src/views/Inquiries/InquiriesList.vue`
- [ ] PrimeVue DataTable (Client, Event Date, Venue, Status, Source)
- [ ] Status badges (new, quoted, confirmed, lost)
- [ ] Filters: Status, Date range, Source
- [ ] Pagination & search
- [ ] Actions: View, Edit, Delete
- [ ] "Create Inquiry" button
- [ ] Fetch data with Pinia Colada
- [ ] Test list with filters

### Create/Edit Inquiry Form

- [ ] Create `src/views/Inquiries/InquiryForm.vue`
- [ ] All inquiry fields (client info, event details, venue)
- [ ] Client dropdown (searchable, can create new)
- [ ] Form validation
- [ ] Save button with Pinia Colada mutation
- [ ] Test create and edit flows

### Inquiry Detail View

- [ ] Create `src/views/Inquiries/InquiryDetail.vue`
- [ ] Show all inquiry details
- [ ] Quote History section
- [ ] "Add Quote" button → QuoteModal
- [ ] "Change Status" dropdown
- [ ] Convert to Booking button (when confirmed)
- [ ] Lost reason dropdown (when lost)
- [ ] Test inquiry detail page

### Quote Modal

- [ ] Create `src/components/QuoteModal.vue`
- [ ] Package dropdown (optional, prefills amount)
- [ ] Quoted amount input
- [ ] Notes textarea
- [ ] Save button
- [ ] Test quote creation

### Bookings List

- [ ] Create `src/views/Bookings/BookingsList.vue`
- [ ] DataTable (Client, Date, Venue, Status, Performers, Amount)
- [ ] Filters: Status, Date range
- [ ] Actions: View, Edit, Cancel
- [ ] "Create Booking" button
- [ ] Test bookings list

### Create/Edit Booking Form

- [ ] Create `src/views/Bookings/BookingForm.vue` (full page)
- [ ] Client selection (searchable)
- [ ] Event details (type, date, time, duration)
- [ ] Venue details (name, full address)
- [ ] Package selection (prefills pricing)
- [ ] Pricing fields (quoted, final)
- [ ] Special requests & notes
- [ ] Validation: event_date cannot be in past
- [ ] Test booking creation

### Booking Detail View

- [ ] Create `src/views/Bookings/BookingDetail.vue`
- [ ] Show all booking details
- [ ] Performers section
- [ ] "Assign Performer" button
- [ ] Payments section (deposit, final)
- [ ] "Record Payment" buttons
- [ ] Test booking detail page

### Record Payments

- [ ] Create deposit payment modal
- [ ] Create final payment modal
- [ ] Fields: Amount, method, date
- [ ] Test payment recording

**Milestone:** ✅ Full inquiry → booking workflow working

---

## Friday-Sunday (14-20 hrs)

### Performers, Assignments, Expenses, Other Entities

### Performers List

- [ ] Create `src/views/Performers/PerformersList.vue`
- [ ] DataTable: Name, Email, Skills, Rate, Active
- [ ] Filter: Active/Inactive, Skills
- [ ] "Create Performer" button
- [ ] Test performers list

### Create/Edit Performer

- [ ] Create `src/views/Performers/PerformerForm.vue`
- [ ] Name, email, phone
- [ ] Skills MultiSelect
- [ ] Default rate
- [ ] Notes
- [ ] Test performer creation

### Assign Performer to Booking

- [ ] Create `src/components/AssignPerformerModal.vue`
- [ ] Performer dropdown
- [ ] Payout amount input
- [ ] "Check Availability" button
- [ ] Conflict warning dialog
- [ ] Test assignment with conflicts

### Performer Payouts View

- [ ] Create `src/views/Payouts/PayoutsList.vue`
- [ ] Grouped by performer
- [ ] Show total owed, bookings list
- [ ] "Mark as Paid" buttons (individual & bulk)
- [ ] Test payout marking

### Log Performer Expense

- [ ] Create `src/components/LogExpenseModal.vue`
- [ ] Booking dropdown
- [ ] Amount & description
- [ ] Expense date
- [ ] Permissions check
- [ ] Test expense logging

### View Performer Expenses

- [ ] Add "Expenses" tab in BookingDetail
- [ ] Show expenses for booking
- [ ] Test visibility by role

### Overhead Expenses List

- [ ] Create `src/views/Expenses/ExpensesList.vue`
- [ ] DataTable: Description, Amount, Category, Date
- [ ] Filter by category, date range
- [ ] Admin only access
- [ ] Test overhead expenses

### Create/Edit Overhead Expense

- [ ] Create `src/components/OverheadExpenseFormModal.vue`
- [ ] All expense fields
- [ ] Test expense creation

### Clients List

- [ ] Create `src/views/Clients/ClientsList.vue`
- [ ] DataTable: Name, Email, Phone, Company
- [ ] Search bar
- [ ] Test clients list

### Create/Edit Client

- [ ] Create `src/components/ClientFormModal.vue`
- [ ] All client fields
- [ ] Test client creation

### Packages List

- [ ] Create `src/views/Packages/PackagesList.vue`
- [ ] DataTable: Name, Price, Duration, Active
- [ ] Reorder functionality
- [ ] Test packages list

### Create/Edit Package

- [ ] Create `src/components/PackageFormModal.vue`
- [ ] All package fields
- [ ] Test package creation

### Users Management (Admin only)

- [ ] Create `src/views/Users/UsersList.vue`
- [ ] DataTable: Name, Email, Roles, Active
- [ ] Admin only access
- [ ] Test users list

### Create/Edit User

- [ ] Create `src/components/UserFormModal.vue`
- [ ] All user fields
- [ ] Roles multi-select
- [ ] Link to performer
- [ ] Test user creation

**Milestone:** ✅ All main screens working, full workflow complete

---

## Daily Log

### Monday, Oct X

_What I worked on:_

_Blockers:_

_Tomorrow:_

### Tuesday, Oct X

_What I worked on:_

_Blockers:_

_Tomorrow:_

### Wednesday, Oct X

_What I worked on:_

_Blockers:_

_Tomorrow:_

### Thursday, Oct X

_What I worked on:_

_Blockers:_

_Tomorrow:_

### Friday, Oct X

_What I worked on:_

_Blockers:_

_Weekend plan:_

### Saturday, Oct X

_What I worked on:_

### Sunday, Oct X

_What I worked on:_

_Next week prep:_

---

## Notes & Snippets

_Add useful code snippets, commands, or notes here as you work_

---

## Questions

_Track questions that come up during development_
