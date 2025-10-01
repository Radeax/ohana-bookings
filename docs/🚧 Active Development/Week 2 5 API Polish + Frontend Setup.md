# Week 2.5: API Polish + Frontend Setup

**Goal:** Production-ready API + Frontend scaffolding

**Hours:** 12-16 hours

---

## Monday-Tuesday (8-10 hrs): API Polish

### Add Filters & Pagination

- [ ]  Add filters to all list endpoints (status, date range, etc.)
- [ ]  Add pagination (page, pageSize query params)
- [ ]  Test all filter combinations

### Swagger Documentation

- [ ]  Install @nestjs/swagger
- [ ]  Add Swagger decorators to controllers
- [ ]  Add @ApiProperty to DTOs
- [ ]  Configure Swagger in main.ts
- [ ]  Access at /api/docs and verify
- [ ]  Test all endpoints in Swagger UI

### Export & Audit

- [ ]  Create export endpoints (inquiries, bookings, financial CSV)
- [ ]  Install json2csv library
- [ ]  Create audit_log schema
- [ ]  Create audit logging interceptor
- [ ]  Test exports and audit logging

### Deploy to Railway (Staging)

- [ ]  Create Railway project
- [ ]  Add PostgreSQL + Redis
- [ ]  Configure environment variables
- [ ]  Connect GitHub repo
- [ ]  Deploy API
- [ ]  Run migrations
- [ ]  Seed admin user
- [ ]  Test API in staging

**Milestone:** ✅ API deployed to staging, documented

---

## Wednesday-Thursday (4-6 hrs): Frontend Setup

### Initialize

- [ ]  Create Vite + Vue 3 project
- [ ]  Install PrimeVue, Tailwind, Pinia, Vue Router, Axios
- [ ]  Configure all libraries

### Create Foundation

- [ ]  Create API client (axios with interceptors)
- [ ]  Create auth store (Pinia)
- [ ]  Create router with auth guards
- [ ]  Create layout components (MainLayout, Header, Sidebar)
- [ ]  Test that everything loads

**Milestone:** ✅ Frontend setup complete, ready to build

---

## Daily Log

### Monday

*What I worked on:*

### Tuesday

*What I worked on:*

### Wednesday

*What I worked on:*

### Thursday

*What I worked on:*

---

## Notes

*Add setup notes, configuration snippets*