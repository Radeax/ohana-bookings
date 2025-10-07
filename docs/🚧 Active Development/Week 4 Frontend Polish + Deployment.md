# Week 4: Frontend Polish + Deployment

**Goal:** Production-ready UI, deployed to production

**Hours:** 30-40 hours

---

## Monday-Tuesday (8-10 hrs)

### Calendar + Search

### Calendar View

- [ ] Create `src/views/Calendar/CalendarView.vue`
- [ ] Use PrimeVue FullCalendar component
- [ ] Fetch bookings for date range
- [ ] Show events on calendar (month/week views)
- [ ] Color code by status
- [ ] Click event to see details
- [ ] Test calendar with various date ranges

### Global Search

- [ ] Add search bar in header
- [ ] Create `src/components/GlobalSearchModal.vue`
- [ ] Debounced search input
- [ ] Show results grouped by type
- [ ] Click result to navigate
- [ ] Test search relevance

### Filters & Notifications

- [ ] Ensure all lists have proper filters
- [ ] Create `src/views/Notifications/NotificationsList.vue`
- [ ] List notifications with actions
- [ ] Test all filtering

**Milestone:** ✅ Calendar, search, notifications working

---

## Wednesday-Thursday (8-10 hrs)

### UX Polish

### Loading States

- [ ] Add skeleton loaders (PrimeVue Skeleton) to all tables
- [ ] Add spinners to buttons during mutations
- [ ] Add full-page loader for initial load
- [ ] Test loading states

### Error Handling

- [ ] Global error toast notifications
- [ ] Form validation errors (inline messages)
- [ ] API error messages (user-friendly)
- [ ] Create 404 page
- [ ] Create 403 page (unauthorized)
- [ ] Test error scenarios

### Confirm Dialogs

- [ ] Add PrimeVue ConfirmDialog for:
  - [ ] Delete inquiry
  - [ ] Cancel booking
  - [ ] Remove performer
  - [ ] Delete expense
  - [ ] Deactivate user
- [ ] Test all confirm dialogs

### Empty States

- [ ] Add empty states to all lists
- [ ] Include helpful CTAs
- [ ] Test empty state displays

### Responsive Design

- [ ] Test all views on mobile/tablet
- [ ] Collapsible sidebar on mobile
- [ ] Stack cards vertically on small screens
- [ ] Responsive DataTables
- [ ] Test on various screen sizes

### Accessibility

- [ ] Ensure keyboard navigation works
- [ ] Add ARIA labels
- [ ] Test with screen reader (basic)
- [ ] Verify color contrast
- [ ] Test tab navigation

### Performance

- [ ] Lazy load routes
- [ ] Optimize images (if any)
- [ ] Check bundle size
- [ ] Test on throttled network
- [ ] Optimize large lists if needed

**Milestone:** ✅ Professional UX, all edge cases handled

---

## Friday (6-8 hrs)

### Export + Final Testing

### Export Functionality

- [ ] Add "Export to CSV" buttons on:
  - [ ] Inquiries list
  - [ ] Bookings list
  - [ ] Financial reports
- [ ] Test CSV downloads
- [ ] Verify exported data accuracy

### End-to-End Testing

- [ ] Test complete workflow:
  1. [ ] Log in as admin
  2. [ ] Create inquiry
  3. [ ] Add quote
  4. [ ] Change status to "confirmed"
  5. [ ] Convert to booking
  6. [ ] Assign performers (test conflicts)
  7. [ ] Record deposit payment
  8. [ ] Log performer expense
  9. [ ] Record final payment
  10. [ ] Mark payouts as paid
  11. [ ] View financial reports
  12. [ ] Export data
- [ ] Test as different roles (admin, coordinator)
- [ ] Test edge cases

### Bug Fixes

- [ ] Fix any bugs found
- [ ] Improve validation messages
- [ ] Polish UI inconsistencies
- [ ] Test on different browsers

**Milestone:** ✅ Tested, polished, ready for production

---

## Saturday-Sunday (8-14 hrs)

### Production Deployment

### Railway Production Setup

- [ ] Create production Railway project
- [ ] Add PostgreSQL (production tier)
- [ ] Add Redis
- [ ] Configure production env vars:
  - [ ] Strong JWT secrets
  - [ ] Frontend URL
  - [ ] Other secrets
- [ ] Set up automatic backups

### Deploy API to Railway

- [ ] Connect GitHub repo (main branch)
- [ ] Configure build
- [ ] Deploy API
- [ ] Run migrations in production
- [ ] Seed admin user
- [ ] Test API endpoints
- [ ] Document production API URL

### Cloudflare Pages Production Setup

- [ ] Create Cloudflare Pages project
- [ ] Connect GitHub repo
- [ ] Configure build settings:
  - [ ] Build command: `pnpm build`
  - [ ] Output directory: `dist`
  - [ ] Root: `apps/frontend`
- [ ] Add env var: `VITE_API_URL`

### Deploy Frontend to Cloudflare

- [ ] Push to main branch (triggers deploy)
- [ ] Wait for build
- [ ] Test deployed frontend
- [ ] Verify API connection
- [ ] Test HTTPS/SSL
- [ ] Document production URL

### Production Testing

- [ ] Create real admin user
- [ ] Test login
- [ ] Test all critical flows:
  - [ ] Inquiry → Booking
  - [ ] Performer assignment
  - [ ] Payment recording
  - [ ] Financial reports
  - [ ] Export
- [ ] Verify calculations accurate
- [ ] Test from multiple devices
- [ ] Test from different browsers

### Custom Domain (Optional)

- [ ] Add custom domain to Cloudflare
- [ ] Update DNS records
- [ ] Update backend CORS
- [ ] Verify HTTPS with custom domain

### Final Configuration

- [ ] Verify backups enabled
- [ ] Test backup restore (optional)
- [ ] Document backup process
- [ ] Set up monitoring (optional)
- [ ] Set up error alerts (optional)

### Documentation

- [ ] Update README with:
  - [ ] Project overview
  - [ ] Tech stack
  - [ ] Local setup
  - [ ] Environment variables
  - [ ] Deployment instructions
- [ ] Document production URLs in START HERE
- [ ] Create user guide (optional)
- [ ] Document common workflows

**Final Milestone:** 🚀 **Production MVP live!**

---

## Daily Log

### Monday, Oct X

_What I worked on:_

_Blockers:_

### Tuesday, Oct X

_What I worked on:_

### Wednesday, Oct X

_What I worked on:_

### Thursday, Oct X

_What I worked on:_

### Friday, Oct X

_What I worked on:_

### Saturday, Oct X

_Deployment progress:_

### Sunday, Oct X

_Production status:_

_CELEBRATION!_ 🎉

---

## Success Criteria

### Functional Requirements

- [ ] ✅ Login with multiple roles
- [ ] ✅ Inquiry → booking workflow
- [ ] ✅ Performer assignments with conflicts
- [ ] ✅ Payment tracking
- [ ] ✅ Expense tracking (personal + overhead)
- [ ] ✅ Financial reports accurate
- [ ] ✅ Calendar working
- [ ] ✅ Search & filters working
- [ ] ✅ Export to CSV
- [ ] ✅ Deployed to production

### Technical Requirements

- [ ] ✅ Type-safe contracts
- [ ] ✅ Auth working (JWT + refresh)
- [ ] ✅ Role-based permissions
- [ ] ✅ Database migrations
- [ ] ✅ API documented (Swagger)
- [ ] ✅ Error handling
- [ ] ✅ Responsive UI
- [ ] ✅ Automated deployment

---

## Notes

_Add deployment notes, issues resolved, lessons learned_

---

## What's Next?

**Phase 1.5** - Performer Portal (Weeks 5-6):

- Performer logins
- Availability calendar
- Self-service expense logging
- Email notifications

**You did it!** 🎉 Take a moment to celebrate shipping your MVP!
