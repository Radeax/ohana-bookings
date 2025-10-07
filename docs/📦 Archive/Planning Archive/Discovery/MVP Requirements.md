# MVP Requirements

**Ohana Entertainment Booking App**

**Date:** 2025-07-19

**Owner:** [Your Name]

---

## 1. **Purpose**

Build a custom web app for Ohana of Polynesia to streamline the process of managing client inquiries, event bookings, performer scheduling, and communication. The goal is to replace scattered spreadsheets, texts, and emails with a unified platform that saves time, reduces errors, and enhances client experience.

---

## 2. **Background & Context**

Ohana of Polynesia manages dance entertainment bookings for private and corporate events. Currently, inquiries and bookings are handled manually via Google Sheets, email, and third-party lead platforms, creating inefficiencies and a risk of double-booking or miscommunication.

---

## 3. **Scope**

### **In Scope**

- Admin dashboard for managing inquiries, bookings, performers, and schedules
- Performer management (availability, assignment)
- Inquiry and booking management
- Basic reporting (bookings, revenue)
- Internal notes and simple client communication tracking
- Web-based platform accessible via desktop/mobile

### **Out of Scope (Initial MVP)**

- Full-featured performer self-service portal (future phase)
- Deep analytics/reporting
- Third-party lead platform integration (manual for MVP, automation as future feature)
- Automated invoicing/payments (future phase)
- Automated client communication (reminders, etc.—future phase)

---

## 4. **Personas**

- **Admin/Owner:** Manages bookings, responds to inquiries, assigns performers
- **Performer:** (Phase 2+) Can log in to view assigned bookings and availability
- **Client:** Indirect; interacts via improved communication and service

---

## 5. **Requirements**

### **Functional Requirements**

### 1. **Inquiry Management**

- Capture inquiries from web form and manually enter others (phone/email)
- View and search all inquiries in a list
- Link inquiries to bookings or mark as lost/closed

### 2. **Booking Management**

- Create bookings from inquiries or manually
- Assign one or more performers to each booking
- Track booking status: Inquiry > Pending > Confirmed > Completed > Cancelled
- Track event date, time, location, package type, and special notes
- Mark deposit/payment status

### 3. **Performer Management**

- List all performers (with name, contact, roles)
- Track performer availability/unavailability (simple calendar or list)
- Assign performers to bookings and notify them (manual/automated, Phase 2)
- View performer booking history

### 4. **Dashboard & Calendar**

- Overview dashboard: Upcoming events, pending actions, recent inquiries
- Calendar view of all bookings/events

### 5. **Reporting (Basic)**

- Monthly summary: Number of bookings, revenue, most-booked performers

### 6. **Client Communication Tracking**

- Log sent emails/calls/confirmations
- Add internal notes to inquiries and bookings

### 7. **Authentication & Authorization**

- Secure login for admin(s)
- Role-based access (admin, performer—future)

---

### **Non-Functional Requirements**

- Responsive web design for desktop and mobile
- Fast load times and reliable uptime
- Secure data storage (client and performer information)
- Simple, intuitive UI for quick onboarding

---

## 6. **Success Metrics**

- All bookings/inquiries managed in app (no more spreadsheets)
- 100% of active performers assigned via app by [target date]
- Improved response time to inquiries (goal: under 24h)
- Zero double-booked events

---

## 7. **Milestones & Timeline**

_(See Project Charter for full schedule. MVP target: 2025-10-15)_

---

## 8. **Assumptions**

- Admin is comfortable entering and managing data via web app
- Performers can be onboarded for login in future phase
- Initial integration with third-party platforms will be manual

---

## 9. **Open Questions**

- Which third-party platforms to prioritize for future integration?
- Do performers need notifications/communications via app (SMS/email) in MVP?
- Will clients ever interact directly with the app, or is it admin-facing only?

---

## 10. **Future Enhancements (Not MVP)**

- Performer self-service portal (manage their own availability, see schedules)
- Automated invoicing, client payments, and reminders
- Deep analytics and downloadable reports
- Integration with GigSalad, TheBash, etc.

---

**Prepared by:** [Your Name]

**Date:** 2025-07-19
