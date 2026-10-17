# Bookiess Pages

BOOKIESS — COMPLETE FULL-STACK WEBSITE BUILD PROMPT

1. YOUR ROLE

Act as a senior full-stack software engineer, UI/UX designer, database architect, product designer, security engineer, and QA tester.

Build a complete, functional, responsive website called Bookiess — a global book marketplace and social reading platform where readers discover and purchase books, writers publish and sell their work, communities discuss books and characters, and authors can invite readers to help shape stories.

This is a real full-stack MVP, not a static mockup, landing-page-only project, or collection of disconnected screens.

Create the actual project files, working routes, reusable components, database schema, authentication, backend operations, authorization rules, functional forms, and setup instructions.

Do not stop after producing a plan or visual prototype. Implement, run, and test the application to the extent your environment allows.

If a feature requires external credentials, create a clearly documented integration point and an honest development-mode alternative. Never pretend an unconfigured integration is working.

2. PRODUCT VISION

Brand: Bookiess

Brand personality:

Intelligent, bookish, welcoming, contemporary, creative, and community-oriented.

Premium literary identity without being intimidating.

A little nerdy and playful, especially in book discussions and fandom communities.

Suitable for readers and writers around the world.

Core brand message:

"Read stories. Find your people. Shape what happens next."

Supporting message:

"Not just a place to read. A place to belong."

The platform combines five connected experiences:

A global digital and physical bookstore.

A publishing and sales platform for writers.

Bookiess Hubs for communities, discussions, and chat.

Story Lab for author-controlled collaborative storytelling.

Personal reader libraries, profiles, and reading activity.

All five experiences must share the same accounts, database, design system, and navigation.

3. VISUAL THEME — LOCK THIS BEFORE BUILDING

Use the previously approved Bookiess moodboard as the main visual direction.

Theme name: Modern Bookish Editorial / Enchanted Editorial, grounded in contemporary design.

This means literary elegance and a cozy bookstore atmosphere, combined with a polished modern web application.

It must NOT look like:

A fantasy role-playing game.

A medieval kingdom or magical portal.

A dystopian interface.

An excessively dark Gothic website.

A generic ecommerce template.

An overdecorated AI-generated landing page.

Color palette

Use these design tokens consistently:

Forest green: #123D2F — primary brand color.

Deep green: #0B2F25 — darker navigation and emphasis.

Warm parchment: #F8F0DF — primary warm background.

Cream: #FFFDF7 — cards and reading surfaces.

Antique gold: #D4AF62 — restrained highlights.

Charcoal: #222321 — primary text.

Muted sage: #A7B89A — secondary accents.

Warm taupe: #8B8174 — secondary text and borders.

Maintain adequate contrast and accessibility. Gold is an accent, not the default color for long text.

Typography

Use:

Playfair Display or a comparable literary serif for major headings.

Inter or a comparable modern sans-serif for navigation, body text, controls, and dashboards.

A comfortable, highly readable serif option for the reading interface.

Use typography intentionally. Avoid oversized headings on every page, excessive italics, and decorative fonts for interface controls.

Layout and components

Generous but efficient whitespace.

Clear visual hierarchy.

Attractive book covers as the primary visual assets.

Restrained rounded corners, subtle shadows, and fine borders.

Consistent spacing, grid alignment, and button sizes.

Contemporary cards, navigation, search, dropdowns, tabs, dialogs, and notifications.

Responsive layouts for desktop, tablet, and mobile.

Polished loading, empty, success, validation, and error states.

Subtle transitions and hover states, with reduced-motion support.

Imagery

Use a mixture of:

Realistic book-cover artwork.

Cozy reading and writing photography.

Contemporary editorial illustrations.

Handwritten notes, reading tabs, annotations, and subtle literary details.

Use licensed, original, or appropriately sourced imagery. Do not use copyrighted book-cover images without permission or misrepresent official editions. Demo books may use clearly fictional titles and original covers.

Light and dark modes

Use the warm editorial theme as the default.

Offer an optional dark reading mode using charcoal, deep green, and readable warm text. Keep the broader website consistent with the primary theme.

4. HOMEPAGE AND OPENING CAROUSEL

The homepage must begin with a polished, wide editorial carousel positioned directly beneath the main navigation.

This carousel is essential. Do not omit it or replace it with a single static hero banner.

Carousel design

Wide, responsive editorial layout.

Approximately 16:6 to 16:9 visual proportion on desktop, adapting for mobile.

Text and imagery arranged side by side on desktop.

Thoughtful image crops and a clean stacked layout on mobile.

Elegant typography, a concise headline, short supporting text, and one clear call-to-action.

Four distinct slides.

Working previous and next arrows.

Four clickable pagination indicators.

Gentle transitions.

Optional slow auto-advance, with pause-on-hover, pause-on-focus, and respect for reduced-motion preferences.

Keyboard-accessible controls and descriptive image alternative text.

Do not use distracting animations, autoplay video, oversized gradients, or excessive visual effects.

Slide 1: Discover your next read

Headline: "Your next favorite book is waiting."

Supporting text: "Discover fresh voices, hidden gems, and stories worth staying up late for."

CTA: "Explore Books"

Image direction: A warm reading desk, stacked books, natural daylight, and a contemporary bookstore atmosphere.

Action: Navigate to Explore Books.

Slide 2: Find your people

Headline: "Every great book starts a conversation."

Supporting text: "Find readers who love your favorite characters, theories, genres, and plot twists."

CTA: "Explore Hubs"

Image direction: A contemporary book-club atmosphere with annotated books, reading notes, and cozy real-world details.

Action: Navigate to Hubs.

Slide 3: Share your story

Headline: "Your words deserve an audience."

Supporting text: "Publish your work, build your readership, and turn your writing into something people can discover."

CTA: "Start Publishing"

Image direction: A modern writer's desk, manuscript pages, laptop, notebook, and natural light.

Action: Navigate to the writer registration or publishing dashboard, depending on authentication.

Slide 4: Create stories together

Headline: "What if readers helped shape the story?"

Supporting text: "Join author-approved discussions, submit ideas, vote on possibilities, and help shape what comes next."

CTA: "Discover Story Lab"

Action: Navigate to Story Lab.

Use editorial images and original demo content. Do not use dramatic fantasy landscapes as the default imagery.

Below the carousel, show:

Browse by genre.

Featured books.

New releases.

Popular and highly rated books.

Independent writers to discover.

Recommended books, personalized when reader history exists.

Featured or public Bookiess Hubs.

Active Story Lab projects.

A call-to-action for writers.

A footer with help, policies, contact, and social links.

Do not overload the homepage. Prioritize discovery, readability, and clear navigation.

5. GLOBAL NAVIGATION

Create a consistent navigation system containing:

Bookiess logo.

Home.

Explore.

Categories or Genres.

Hubs.

Story Lab.

For Writers.

Search.

Shopping cart.

Notifications.

User profile and account menu.

For logged-in users, provide quick access to:

My Library.

My Hubs.

My Reading Activity.

My Purchases.

My Writing Studio, if authorized.

Settings.

On mobile, use a responsive menu or compact bottom navigation for the most important destinations.

All navigation links must lead to real pages or functional sections.

6. ACCOUNTS, AUTHENTICATION, AND PERMISSIONS

Implement real account registration, login, logout, session persistence, password reset, and protected routes.

Use a secure authentication provider or a properly implemented server-side authentication system.

Support these permission types:

Reader

Browse and purchase books.

Read accessible books.

Write reviews and comments.

Join and participate in hubs.

Follow authors.

Submit Story Lab suggestions.

Vote where permitted.

Manage profile and reading library.

Writer

All reader permissions.

Create and manage author profile.

Create, edit, preview, and publish books.

Upload book covers and manuscripts.

Manage editions, prices, and publication settings.

View sales and readership analytics.

Create or participate in authorized Story Lab projects.

Moderate their own book discussions where appropriate.

A user should be able to become a writer without needing a separate account.

Hub moderator

Manage membership and invitations.

Pin or remove inappropriate hub content.

Mute or remove members within authorized communities.

Manage hub-specific moderation reports.

Enforce community rules.

Platform administrator

Manage users, books, categories, reports, and platform settings.

Review reported content.

Moderate public content and accounts.

View platform-level analytics.

Manage commission configuration and administrative settings.

Enforce permissions on the backend, not just by hiding buttons in the frontend.

Users must not be able to edit another writer's books, access private messages, read unauthorized manuscripts, alter other users' purchases, or grant themselves administrator privileges.

7. EXPLORE AND BOOK DISCOVERY

Build a functional book discovery experience.

Include:

Search by title, author, description, genre, tags, and language.

Search suggestions where practical.

Filters for genre, format, language, price, rating, publication status, and availability.

Sorting by relevance, newest, popularity, rating, and price.

Pagination or efficient incremental loading.

Featured collections.

New releases.

Trending books.

Independent authors.

Personalized recommendations when sufficient reading activity exists.

Provide useful empty states when no results match.

Search must query actual database content, not just filter a small hardcoded array.

8. BOOK DETAIL PAGES

Each book must have a dedicated page containing:

Book cover.

Title and subtitle.

Author profile link.

Synopsis.

Genres, tags, language, and publication date.

Edition and format details.

Digital price and/or physical edition price.

Average rating and number of reviews.

Verified-purchase indicators where applicable.

Reviews and discussion section.

Similar or related books.

Reading sample or preview, where permitted.

Add to cart.

Buy now.

Add to wishlist.

Follow author.

Join or discover a related hub.

Share book link.

Report book.

Digital and physical editions must be represented correctly. A physical edition may need shipping and delivery information; a digital edition must not show irrelevant shipping fields.

Never imply that a book is available for immediate reading before access has been confirmed.

9. DIGITAL AND PHYSICAL BOOKSTORE

Support both digital and physical books.

Digital products

Ebook files and/or structured chapter content.

Formats such as EPUB and PDF where supported.

Online reading interface.

Optional permitted downloads.

Secure access after purchase.

Purchase confirmation and library access.

Physical products

Edition and format details.

Price and stock status.

Shipping address and delivery information.

Shipping cost and estimated delivery where supported.

Order status and order history.

Cancellation, returns, and refund workflows appropriate to the applicable policies.

Do not attempt to simulate international shipping or inventory as real functionality without a configured service or real data.

Shopping cart and checkout

Add and remove products.

Change quantities for physical books.

Display subtotal, taxes or estimated taxes, shipping where applicable, discounts, and total.

Validate stock before order confirmation.

Handle pending, successful, failed, canceled, and refunded payments.

Provide order confirmation.

Update the reader's library after a confirmed digital purchase.

Avoid duplicate orders and duplicate payment processing.

Integrate a suitable payment provider such as Stripe or another provider supported by the deployment region and business requirements.

Never store raw card details.

Payment success must be confirmed server-side through verified provider responses or webhooks. A client-side success screen alone must never grant access to paid content.

If payment credentials are missing, provide a clearly labeled sandbox or development flow. Do not represent simulated payments as real transactions.

10. WRITER'S STUDIO

Create a polished writer dashboard.

Author profile

Display name and biography.

Profile image.

Social or website links.

Published books.

Followers.

Reader engagement statistics.

Book creation

Allow writers to:

Create a new book.

Save a draft.

Edit title, subtitle, synopsis, cover, genres, tags, language, and edition details.

Upload or write manuscript content.

Organize chapters and chapter order.

Preview a book before publication.

Choose free or paid access.

Configure digital and physical editions.

Set supported prices and currencies.

Publish, unpublish, or archive their own works, subject to purchase and legal obligations.

View validation errors and publication status.

Publication controls

Provide statuses such as:

Draft.

Published.

Unpublished.

Archived.

Under review, when moderation is required.

Writers retain appropriate rights to their work. Publishing terms must be transparent.

Open registration should not mean unmoderated distribution. Include reporting, copyright complaints, prohibited-content policies, and abuse controls.

Writer analytics

Show:

Book views.

Reader engagement.

Followers.

Sales.

Units sold.

Refunds.

Gross sales.

Platform commission.

Estimated net earnings.

Payout status.

Clearly distinguish gross sales, net earnings, and money actually paid out.

11. READER LIBRARY AND READING EXPERIENCE

Create a personal library with:

Purchased books.

Free books saved by the reader.

Reading progress.

Currently reading.

Completed books.

Want-to-read list.

Favorites.

Reading history.

Bookmarks and notes where supported.

Online reader

Provide:

Clean, distraction-free typography.

Adjustable font size and line spacing.

Light and dark reading themes.

Reading progress.

Chapter navigation.

Table of contents.

Bookmarks.

Resume reading.

Responsive reading layout.

Accessible keyboard controls.

Only display content the user is authorized to access.

For protected manuscripts and paid ebooks, use secure access controls. Do not expose private storage URLs or unrestricted source files.

Respect any publisher-defined restrictions on downloads, previews, and sharing.

12. REVIEWS, RATINGS, AND DISCUSSIONS

Readers should be able to:

Rate a book from one to five stars.

Write and edit their own reviews.

Delete their own reviews.

Comment on reviews where enabled.

Reply to comments where supported.

React to reviews and discussion posts.

Mark content as containing spoilers.

Report abusive or inappropriate content.

Rules:

One active rating/review per user per book, editable by that user.

Prevent users from impersonating other reviewers.

Mark verified purchases only when purchase records support that label.

Calculate average ratings from valid reviews.

Paginate long discussion threads.

Validate all inputs on the backend.

Sanitize user-generated content.

Prevent spam and repeated submissions.

13. BOOKIESS HUBS — SOCIAL READING COMMUNITIES

Hubs are a major product feature, not a minor add-on.

A hub is a community built around a book, author, series, genre, character, fandom, or reading interest.

Hub discovery

Allow users to:

Browse public hubs.

Search hubs by topic, title, genre, or associated book.

View member counts, descriptions, activity, and rules.

Join or leave public hubs.

Request access to private hubs.

Join by invitation where enabled.

Follow hub activity.

Discover relevant hubs from book detail pages.

Hub creation

Allow eligible users to create hubs with:

Name.

Description.

Icon or cover image.

Associated book or series, optionally.

Topic and tags.

Public or private visibility.

Membership rules.

Community guidelines.

Moderator assignments.

Configurable participation permissions.

Prevent duplicate spam hubs where practical.

Hub content

Include:

Discussion posts.

Threaded comments or replies.

Reactions.

Polls.

Spoiler-marked posts.

Character discussions.

Fan theories.

Reading-club announcements.

Events or reading challenges.

Pinned posts.

Member lists.

Author announcements where applicable.

Real-time group chat

Implement persistent group messaging with a real-time service or suitable backend.

Features:

Message history.

Real-time message delivery.

Message timestamps.

Sender identity.

Replies or basic message reactions where practical.

Unread indicators.

Basic moderation controls.

Report and block functionality.

Appropriate access checks for private hubs.

Do not build a chat UI that only changes locally without saving messages.

Community safety

Hub moderators can enforce community rules.

Users can report messages and posts.

Users can block other users.

Rate-limit messages and other high-frequency actions.

Validate hub membership before displaying private content.

Keep moderation actions auditable.

Prevent blocked users from bypassing restrictions through ordinary interactions.

Include clear community guidelines and spoiler etiquette.

14. STORY LAB — AUTHOR-CONTROLLED COLLABORATIVE STORYTELLING

Story Lab is one of Bookiess's signature features.

It allows authors to invite readers to contribute ideas and, when explicitly authorized, collaborate on selected sections of a manuscript.

The author always controls whether collaboration is enabled and what can be changed.

Project creation

A writer can:

Create a Story Lab project linked to a book.

Choose the chapter, character, plotline, or section open to collaboration.

Write a collaboration brief.

Define the allowed contribution types.

Decide whether the project is public, private, or invitation-only.

Set participation rules and deadlines.

Enable or disable suggestions, voting, or co-writing independently.

Define who may edit drafts.

Set rules for contributor credit and ownership before participation.

Reader suggestions

Readers can:

Suggest alternative dialogue.

Suggest character decisions.

Propose plot twists.

Suggest alternate scenes or endings.

Explain why an idea might work.

Comment on suggestions.

React to suggestions.

Vote when the author has enabled voting.

View the current project status.

Author-approved co-writing

When the author enables co-writing:

Only authorized contributors can edit the designated draft sections.

Provide an editor for the permitted text.

Save revisions.

Show tracked changes or a meaningful revision comparison.

Preserve earlier versions.

Attribute contributions to the correct user.

Allow authors to accept, reject, or edit proposed changes.

Prevent unauthorized changes to the original manuscript.

Publish revised story content only through an explicit author action.

Workflow

Use this basic workflow:

Author opens a collaboration.

Readers submit suggestions or request contributor access.

The community discusses and votes if enabled.

The author selects suggestions or authorizes collaborators.

Contributors work on permitted draft sections.

The author reviews proposed changes.

The author accepts, rejects, or modifies revisions.

The author explicitly publishes the approved version.

The project records the published version and relevant history.

Version history

Record:

Version number.

Author or contributor responsible for a change.

Timestamp.

Relevant change summary.

Review status.

Approval or rejection.

Published status.

The original manuscript must remain recoverable.

Ownership and attribution

Before allowing collaborative contributions, present clear terms covering:

What rights contributors retain.

What permissions they grant the author or platform.

How contributions may be credited.

Whether contributors may receive payment or other benefits.

How accepted contributions can be used in published or commercial editions.

How disputes are handled.

Do not silently transfer ownership of reader contributions. Obtain any legally necessary agreement before incorporating contributions into commercial publication.

Use a secure, author-controlled workflow instead of allowing arbitrary users to overwrite a published manuscript.

15. NOTIFICATIONS AND SOCIAL CONNECTIONS

Implement in-app notifications for:

New followers.

Book purchases and order updates.

Replies to comments.

Reactions to posts.

Hub invitations and membership approvals.

New hub activity, where enabled.

Story Lab votes and suggestions.

Author approvals or revision requests.

Publication announcements.

Moderation outcomes.

Allow users to configure notification preferences.

Email notifications can be added through a configured provider. Do not pretend emails have been sent if the service is unconfigured.

Use sensible notification grouping to avoid overwhelming users.

16. WISHLISTS, FOLLOWING, AND PERSONALIZATION

Allow users to:

Follow authors.

Save books to a wishlist.

Follow hubs.

View new publications from followed authors.

Track reading progress.

Maintain a personal reading list.

Discover similar books.

Start with understandable recommendations based on genres, tags, ratings, and reading activity.

If recommendation data is insufficient, show popular or editorially featured books instead. Never display fabricated personalization metrics.

17. INTERNATIONAL MARKETPLACE

Bookiess is intended for readers and writers globally.

Design the system for:

Internationally formatted names and addresses.

Multiple languages as a future-ready capability.

Currency-aware pricing.

Correct currency formatting.

Time zones and localized timestamps.

Configurable tax and shipping integrations.

Region-specific payment availability.

Accessible, responsive layouts.

Clear pricing before checkout.

Do not assume one payment provider supports every country or that every author can receive payouts everywhere.

For the initial release, choose a practical supported launch region and payment configuration, while making the architecture extensible.

Use one clearly defined internal currency representation for calculations and store currency codes with prices. Use integer minor units where appropriate and avoid floating-point errors in money calculations.

Do not promise automatic global tax compliance. Document the integrations and policies needed before launch.

18. ADMIN DASHBOARD AND MODERATION

Create a protected administrative area.

Include:

User management.

Writer and publication management.

Book categories and genre management.

Review and discussion reports.

Hub reports.

Story Lab reports.

Copyright complaints.

Order and payment status visibility.

Commission configuration.

Basic platform analytics.

Moderation history.

Provide actions such as:

Review a report.

Remove or restrict content when justified.

Warn or suspend an account under defined policies.

Restore content when appropriate.

Record an internal moderation reason.

Review repeat reports and abuse patterns.

Restrict these operations to authorized administrators and moderators.

Do not expose private messages, private drafts, or personal data unnecessarily to ordinary users.

19. DATA MODEL

Design a relational database and implement migrations or schema setup.

At minimum, model these entities and their relationships:

Users.

User profiles.

Roles and permissions.

Author profiles.

Books.

Book editions.

Book categories and genres.

Book tags.

Book files and chapters.

Book publication status.

Book prices and currencies.

Inventory for physical editions.

Shopping carts and cart items.

Orders and order items.

Payments and refunds.

Shipping addresses and fulfillment status.

Reader libraries and reading progress.

Reviews and ratings.

Comments and replies.

Wishlists.

Author follows.

Hubs.

Hub memberships and invitations.

Hub moderators.

Hub posts and replies.

Hub reactions and polls.

Hub messages.

User blocks and reports.

Story Lab projects.

Story suggestions.

Votes.

Collaborator permissions.

Manuscript revisions and version history.

Notifications.

Audit logs.

Payout records, if supported.

Application settings.

Use appropriate foreign keys, unique constraints, indexes, timestamps, deletion policies, and ownership checks.

Examples:

A user cannot review the same book multiple times simultaneously.

A cart item must reference a valid product or edition.

An order item preserves the price and edition details at purchase time.

A library entitlement must be linked to a legitimate free-access rule or confirmed purchase.

A private hub's content must be accessible only to authorized members and moderators.

A Story Lab revision must reference a project and a permitted contributor.

A book's writer must be authorized to edit that book.

Avoid storing duplicate data without a reason. Explain any denormalized data used for performance.

20. RECOMMENDED TECHNICAL ARCHITECTURE

Prefer a modern, maintainable TypeScript stack.

Recommended baseline:

Frontend: Next.js with React and TypeScript.

Styling: Tailwind CSS with reusable design tokens and accessible UI components.

Database: PostgreSQL.

Authentication: a mature provider such as Supabase Auth or an equivalent secure service.

Database access: secure server-side queries or a well-supported ORM.

File storage: private object storage for manuscripts and protected digital content; public storage only for appropriate public assets.

Realtime messaging: a supported realtime service or WebSocket-based implementation.

Payments: a provider supported by the chosen launch region, with server-side verification and webhooks.

Validation: shared schemas and server-side validation.

Testing: unit, integration, and end-to-end tests appropriate to the stack.

Supabase can be a practical choice for authentication, PostgreSQL, file storage, and realtime features if supported by the deployment environment.

Use the latest stable versions that are compatible with one another at implementation time.

If the chosen AI builder uses another stack that is better supported by its environment, it may adapt the implementation, but it must preserve the same functionality, security, and database integrity.

Do not introduce unnecessary dependencies or split the MVP into microservices without a strong reason.

Keep secrets in environment variables. Never expose private service keys, database passwords, or payment secrets in browser code or source control.

21. FILE UPLOADS AND SECURITY

Implement secure upload handling for covers, manuscripts, and other permitted content.

Requirements:

Validate file type, size, and ownership.

Generate safe storage paths.

Do not trust client-provided MIME types alone.

Restrict access to protected manuscript files.

Avoid exposing private storage URLs.

Use signed access URLs or authenticated delivery where appropriate.

Apply rate limits to authentication, chat, reviews, comments, and publishing operations.

Validate all user inputs on the server.

Sanitize rendered user-generated content.

Protect against common injection, cross-site scripting, cross-site request forgery where applicable, and authorization vulnerabilities.

Use secure session and cookie settings.

Prevent users from modifying other users' records.

Add spam and abuse protections.

Maintain appropriate audit logs for privileged actions.

If rich text or Markdown is supported, sanitize it before rendering.

Do not use arbitrary HTML execution for book descriptions, posts, or comments.

22. UI/UX QUALITY REQUIREMENTS

Every page must look like part of the same product.

Build reusable components for:

Buttons.

Inputs and validation messages.

Search bars.

Book cards.

Author cards.

Hub cards.

Story Lab cards.

Ratings.

Reviews.

Comments.

Dialogs.

Toasts.

Dropdowns.

Pagination.

Loading skeletons.

Empty states.

Error states.

Confirmation dialogs.

Create:

A consistent design-token system.

Accessible keyboard navigation.

Semantic headings.

Visible focus states.

Descriptive labels.

Accessible color contrast.

Responsive typography.

Mobile-friendly controls.

Proper loading and failure feedback.

Do not use emoji as the main icon system. Use a consistent icon library.

Avoid oversized dashboards full of meaningless statistics. Every metric must come from real data or be explicitly identified as sample data.

23. DEMO DATA

Seed the development environment with fictional demo data:

Several fictional books across multiple genres.

Fictional author profiles.

Reader accounts.

Public and private sample hubs.

Example posts, comments, polls, and discussions.

A sample Story Lab project with suggestions and voting.

Example reading progress.

Sample order records clearly labeled as demo data.

Create a straightforward way to reset demo data.

Do not create fake verified purchases, fake real customer reviews, fake payment confirmations, or fabricated live sales metrics.

Any sample accounts and credentials must be documented as development-only.

24. REQUIRED ROUTES AND PAGES

Implement and connect at least the following pages.

Public:

/

/explore

/search

/genres/[slug]

/books/[slug]

/authors/[username]

/hubs

/hubs/[slug]

/story-lab

/story-lab/[projectId]

/login

/register

/forgot-password

/terms

/privacy

/community-guidelines

/contact

Authenticated reader:

/library

/library/[bookId]

/reader/[bookId]

/wishlist

/reading-activity

/purchases

/cart

/checkout

/orders/[orderId]

/notifications

/settings

Writer:

/studio

/studio/books

/studio/books/new

/studio/books/[bookId]/edit

/studio/books/[bookId]/chapters

/studio/analytics

/studio/earnings

/studio/story-lab

/studio/profile

Administration:

/admin

/admin/users

/admin/books

/admin/reports

/admin/hubs

/admin/orders

/admin/settings

Adapt route conventions to the selected framework, but retain the required functionality and access controls.

25. BUSINESS MODEL

Design the system to support:

A configurable platform commission on eligible sales.

Writer earnings reporting.

Optional future reader or writer subscriptions.

Potential future premium hub features, if explicitly introduced.

For the MVP:

Make commission rates configurable.

Clearly show the commission and estimated net amount in writer-facing sales summaries.

Do not hardcode a final commercial rate without documenting it as a configuration.

Keep subscriptions disabled until their billing, entitlement, cancellation, and refund behavior is implemented.

Do not advertise payouts as available until a payout provider and onboarding process are configured.

Platform revenue calculations must be server-side and auditable.

26. TESTING AND ACCEPTANCE CRITERIA

Test real workflows rather than only isolated UI rendering.

Authentication

A user can register, log in, log out, and reset a password.

Protected pages reject unauthenticated requests.

Users cannot promote themselves to higher roles.

Publishing

A writer can create a draft, edit it, upload a permitted cover, preview it, and publish it.

Another writer cannot edit that book.

Published books appear in Explore and search.

Purchasing

A reader can add products to the cart.

Checkout validates prices, availability, and totals on the server.

A verified successful digital purchase creates a library entitlement.

A failed or canceled payment does not grant paid access.

Duplicate payment notifications do not create duplicate orders or entitlements.

Reading

Authorized users can read accessible books.

Unauthorized users cannot access protected paid content.

Reading progress persists after navigation and subsequent sessions.

Community

Users can create or join permitted hubs.

Posts, comments, and messages persist.

Private hub content is inaccessible to non-members.

Moderators cannot access administrative powers outside their scope.

Reporting and blocking work.

Story Lab

An author can create a project and configure permissions.

Readers can submit suggestions and vote where allowed.

Only authorized collaborators can edit permitted draft sections.

The author can review changes.

Rejected changes do not alter the published manuscript.

Approved changes become public only after explicit publication.

Earlier versions remain recoverable.

Responsive design

Test desktop, tablet, and mobile widths.

Confirm the carousel works on touch devices and with keyboard navigation.

Confirm navigation and essential workflows remain usable on small screens.

General quality

No dead navigation links.

No buttons that claim to work but have no implementation.

No silent form failures.

No uncontrolled client-side access to privileged operations.

No unhandled loading or empty states.

No secrets committed to source code.

No fake success states for unconfigured services.

Create automated tests where practical and manually verify the critical workflows in the available environment.

If a test cannot be run because of missing credentials or unavailable infrastructure, report the limitation explicitly.

27. IMPLEMENTATION ORDER

Build in the following order, but continue through all phases rather than stopping after the first.

Phase 1: Project foundation, design tokens, navigation, database, and authentication.

Phase 2: Homepage, opening carousel, Explore, search, genres, book detail pages, and author profiles.

Phase 3: Writer Studio, book creation, manuscript uploads, chapters, publishing, and storage permissions.

Phase 4: Reader library, reading interface, cart, checkout integration, orders, and entitlements.

Phase 5: Reviews, comments, following, notifications, and wishlists.

Phase 6: Hubs, memberships, discussion posts, group chat, moderation, and blocking.

Phase 7: Story Lab suggestions, voting, contributor permissions, manuscript revisions, author approval, and version history.

Phase 8: Administration, reporting, analytics, and commission configuration.

Phase 9: Responsive polish, accessibility, automated tests, security review, and deployment documentation.

Use migrations and incremental changes. Keep the application runnable throughout development where practical.

28. FINAL DELIVERABLES

Deliver a complete project with:

All frontend and backend source code.

A clear project directory structure.

Database schema and migrations.

Seed scripts for fictional demo data.

Authentication and authorization implementation.

Environment variable template such as .env.example, containing placeholders only.

Setup and local development instructions.

Database setup instructions.

File-storage configuration instructions.

Payment integration and webhook instructions.

Realtime chat configuration instructions.

Testing commands and test results.

Production build and deployment instructions.

A README explaining the architecture and main workflows.

A list of integrations requiring external accounts, credentials, or paid services.

A list of any features that remain incomplete.

Do not include real credentials or secrets.

If the environment supports file creation and terminal execution, create the actual files, install compatible dependencies, run migrations, seed the database, launch the application, and fix implementation errors.

If you cannot execute a step, provide the exact command and clearly state what remains to be done.

29. FINAL INSTRUCTION

Build Bookiess as a cohesive, modern, bookish, globally oriented product.

Prioritize the original approved visual direction: warm editorial surfaces, forest green, parchment, restrained gold accents, elegant typography, realistic book imagery, and clean contemporary interfaces.

The homepage carousel is mandatory.

The bookstore, Writer's Studio, Hubs, and Story Lab must be connected by real application data and permissions.

Do not sacrifice security, data integrity, or essential functionality for visual polish.

Do not claim the project is production-ready merely because it runs locally. Clearly identify any remaining work for legal compliance, payment configuration, content rights, international tax and shipping, security review, and deployment.

Begin by creating the project and implementing the complete application. Do not return only a plan or a design description.

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/7021e569-5c0c-4498-a708-b4734c3762ae).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
