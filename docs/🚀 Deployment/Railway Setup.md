# Railway Setup

## Staging Environment

**URL:** (add when created)

**Database:** PostgreSQL

**Redis:** Yes

### Environment Variables

```
NODE_ENV=staging
DATABASE_URL=(auto-provided by Railway)
REDIS_URL=(auto-provided by Railway)
JWT_SECRET=...
JWT_REFRESH_SECRET=...
FRONTEND_URL=...
```

### Deployment Notes

- Auto-deploy from `develop` branch
- Migrations run automatically

---

## Production Environment

**URL:** (add when created)

**Database:** PostgreSQL (production tier)

**Redis:** Yes

### Environment Variables

```
NODE_ENV=production
DATABASE_URL=(auto-provided by Railway)
REDIS_URL=(auto-provided by Railway)
JWT_SECRET=(strong secret - different from staging)
JWT_REFRESH_SECRET=(strong secret - different from staging)
FRONTEND_URL=(Cloudflare Pages URL)
```

### Deployment Notes

- Auto-deploy from `main` branch
- Migrations run automatically
- Backups enabled

---

## Setup Checklist

### Staging

- [ ] Create Railway project
- [ ] Add PostgreSQL plugin
- [ ] Add Redis plugin
- [ ] Configure environment variables
- [ ] Connect GitHub repo (develop branch)
- [ ] Deploy and test
- [ ] Run seed data

### Production

- [ ] Create Railway project (separate from staging)
- [ ] Add PostgreSQL plugin (production tier)
- [ ] Add Redis plugin
- [ ] Configure environment variables
- [ ] Connect GitHub repo (main branch)
- [ ] Enable automatic backups
- [ ] Deploy and test
- [ ] Create admin user
