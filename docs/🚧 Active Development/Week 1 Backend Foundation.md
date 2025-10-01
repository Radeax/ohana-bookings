# Week 1: Backend Foundation

**Goal:** Project setup + Auth + Core CRUD working

**Hours:** 30-40 hours

---

## Monday-Tuesday (8-10 hrs)

### Project Setup

- [ ]  Initialize monorepo (pnpm + Turborepo)
- [ ]  Create folder structure (apps/api, apps/frontend, packages/)
- [ ]  Set up Docker Compose (PostgreSQL + Redis)
- [ ]  Install Drizzle ORM
- [ ]  Configure dev environment (ESLint, Prettier, .env)
- [ ]  Create GitHub repo + initial commit

**Milestone:** ✅ Monorepo running, database connected

---

## Wednesday-Thursday (8-10 hrs)

### Authentication System

- [ ]  Create users schema
- [ ]  Run migration + seed admin user
- [ ]  Install auth packages (@nestjs/passport, jwt, bcrypt)
- [ ]  Implement JWT strategy + refresh tokens
- [ ]  Create auth endpoints (login, logout, refresh, me)
- [ ]  Create guards and decorators
- [ ]  Test with Postman (all auth flows)

**Milestone:** ✅ Can log in, auth guards working

---

## Friday-Sunday (14-20 hrs)

### Core Schemas & CRUD

- [ ]  Create schemas (clients, packages, performers, inquiries, quote_history)
- [ ]  Run migrations
- [ ]  Generate NestJS modules (clients, packages, performers, inquiries)
- [ ]  Implement CRUD operations for all entities
- [ ]  Add validation (DTOs with class-validator)
- [ ]  Create global exception filter
- [ ]  Test all CRUD with Postman

**Milestone:** ✅ All core entities CRUD working, tested, validated

---

## Daily Log

### Monday, Oct X

*What I worked on:*

*Blockers:*

*Tomorrow:*

---

## Notes & Snippets

*Add useful code snippets, commands, or notes here as you work*

---

## Questions

*Track questions that come up during development*