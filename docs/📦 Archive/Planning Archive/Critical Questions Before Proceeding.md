# Critical Questions Before Proceeding

## Critical Questions Before We Proceed

Looking at this scope, I have a few concerns:

**1. Performer Logins = More Complexity**
Adding performer authentication, availability tracking, and notifications is a significant chunk of work. Are you sure you want this in MVP, or can we start with:

- **MVP:** Admin-only app, manual performer coordination
- **v1.1:** Add performer logins
- _We can do this, do performer login with v1.1_

**2. Financial Tracking Depth**
You want revenue, profit, expenses - that's getting into accounting territory. For MVP, can we simplify to:

- **Track:** Client payments, performer payouts
- **Calculate:** Balance owed, outstanding payments
- **Phase 2:** Full P&L reports, expense categories
- _It doesn’t have to be very complicated at first. Revenue and profit is automatically calculated. Expenses can be manually inputted somewhere._

**3. Invoice Generation**
Do you need actual PDF invoices, or can you email clients with payment details for now?

- _I’ve been using PayPal’s online invoicing. Can continue to use this for now_

**4. Notifications**
Real email/SMS notifications require integrating with services (SendGrid, Twilio). For MVP, can we do:

- **In-app notifications** only
- **Phase 1.5:** Email notifications
- **Phase 2:** SMS
- _This works_
