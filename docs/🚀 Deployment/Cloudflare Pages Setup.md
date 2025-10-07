# Cloudflare Pages Setup

## Staging Frontend

**URL:** (add when created)

**Branch:** `develop`

### Build Configuration

```
Build command: pnpm build
Build output directory: apps/frontend/dist
Root directory: /
```

### Environment Variables

```
VITE_API_URL=(Railway staging API URL)
```

---

## Production Frontend

**URL:** (add when created)

**Branch:** `main`

**Custom Domain:** (optional)

### Build Configuration

```
Build command: pnpm build
Build output directory: apps/frontend/dist
Root directory: /
```

### Environment Variables

```
VITE_API_URL=(Railway production API URL)
```

---

## Setup Checklist

### Staging

- [ ] Create Cloudflare Pages project
- [ ] Connect GitHub repo (develop branch)
- [ ] Configure build settings
- [ ] Set environment variables
- [ ] Deploy and test

### Production

- [ ] Create Cloudflare Pages project
- [ ] Connect GitHub repo (main branch)
- [ ] Configure build settings
- [ ] Set environment variables
- [ ] Deploy and test
- [ ] Configure custom domain (optional)
- [ ] Verify HTTPS working
