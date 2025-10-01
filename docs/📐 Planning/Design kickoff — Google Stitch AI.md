# Design kickoff — Google Stitch AI

> Goal: generate first-pass UI designs for Ohana Bookings using Google Stitch AI, then iterate toward high-fidelity mockups.
> 

### Product snapshot

- App: Ohana Bookings
- One-liner: Simple bookings and scheduling for family-run services
- Platforms: Mobile first, then responsive web
- Tone: Friendly, trustworthy, island-inspired

### Target users

- Service owners managing appointments
- Customers booking services
- Admin or staff managing schedules

### Core user flows

1. Browse services
2. Select time slot
3. Book and pay
4. Manage bookings
5. Staff calendar view

### Information architecture

- Landing
- Auth: Sign in, Sign up, Forgot password
- Services: List, Detail
- Booking: Select time, Details, Payment, Confirmation
- Account: Profile, Payment methods, Past bookings
- Admin: Calendar, Bookings list, Service management

### Visual direction

- Palette: ocean blues, coral accents, warm neutrals
- Vibe: clean, airy, generous whitespace
- Accessibility: WCAG AA minimum

---

### Stitch AI prompt pack — system style

Copy one prompt at a time into Google Stitch AI to generate style options.

- Prompt A: Global design tokens

"Design a modern, accessible UI system for an app called 'Ohana Bookings'. Use ocean blue (#155E75) as primary, coral accent (#FB7185), and warm sand neutral (#F1EFE7). Use rounded 12px radius, soft shadows, clean San Serif headings, humanist body text. Layouts prioritize clarity and touch targets. Include states for hover, focus, active, disabled. Provide color roles and elevation examples."

- Prompt B: Component set

"Create a component library for Ohana Bookings: App bar, Tab bar, Card, List item, Button (primary, secondary, tertiary), Form fields, Date picker, Time slot selector (grid and list), Modal, Toast, Empty states, Pagination, Calendar views. Include variants and interaction states, with accessible color contrast and spacing scale (4, 8, 12, 16...)."

---

### Stitch AI prompt pack — key screens

Use these prompts to generate first drafts of each screen.

- 1) Landing

"Design a welcoming landing screen for Ohana Bookings. Hero with tagline 'Plan. Book. Relax.' Quick actions: Browse Services, View Calendar, Sign In. Feature cards highlighting 'Local pros', 'Transparent pricing', 'Flexible rescheduling'. Footer links. Warm ocean imagery, airy layout, mobile-first."

- 2) Services list

"Design a services list screen with filters (Category, Price, Rating), search bar, and service cards with thumbnail, title, short description, duration, price, rating. Sticky filter bar on scroll. Include empty and loading states."

- 3) Service detail

"Design a service detail page with gallery, description, provider info, reviews snippet, duration, add-ons, and prominent 'Book now' call to action. Show next available dates and times, and policies."

- 4) Booking flow — select time

"Design a time selection step with month calendar and time slot selector. Allow switching between list and grid of time slots. Show timezone, availability badges, and validation for conflicts."

- 5) Booking flow — details and payment

"Design a form for contact details, notes, add-ons, coupon code, and payment summary. Integrate payment section with card fields and Apple Pay / Google Pay buttons. Show total, fees, and refund policy."

- 6) Booking confirmation

"Design a confirmation screen with success state, booking summary, calendar add button, share options, and recommended related services."

- 7) Account — bookings

"Design a bookings list with upcoming and past tabs, each item with status, date/time, service, provider, and quick actions (reschedule, cancel, contact)."

- 8) Admin — calendar

"Design a staff calendar with week and month views, color-coded services, drag to create, click to edit booking, and side panel with details. Include filters by staff and service."

---

### Hand-off checklist

- Export AI outputs into Figma frames
- Define typography scale and spacing variables
- Replace placeholder copy with product voice
- Set component variants and auto layout rules
- Run quick accessibility checks

### Notes

- Keep imagery culturally respectful and authentic
- Prioritize clarity and speed to book over decoration