# Study Mistake Tracker — accounts and optional attachments

## What is included
- Real Supabase email/password sign-up, login, logout and password reset.
- Per-user database cards, protected by the RLS policies already supplied.
- Overview, My mistakes and Practice sections.
- Separate error, correction and reasoning fields.
- Typed answers before reveal; exact-text comparison only, not semantic AI grading.
- Optional private image uploads (up to 5 MB) and audio uploads (up to 10 MB).
- Microphone recording where supported, with permission and a 60-second limit.
- Daily review queue, subject/progress filters, edits and deletion confirmation.
- Explicit import of earlier browser cards, with no automatic account assignment.

## Complete the Supabase setup
1. The `public.mistakes` table and its user-owned RLS policies must exist (first SQL setup).
2. Run `02-private-attachments.sql` in SQL Editor. This creates the private storage bucket and user-folder access policy. Text-only cards do not require this storage step.
3. Enable Email authentication. Keep email confirmation enabled for verified sign-up.
4. In Authentication → URL Configuration, set Site URL to your actual Netlify app URL. Add that exact URL, ending in `/`, to Redirect URLs. Add any other origin you intentionally test, including the private demo URL if desired. Confirmation and password reset links must return to an allowed app URL.
5. The HTML contains only the supplied public URL and publishable key. Never replace it with a secret key or database password.

## Deploy on Netlify
Upload the extracted folder, containing index.html, to the existing project's deployment area. No build step is needed. Update index.html in your GitHub repository. Styling, public configuration and Supabase JS 2.57.4 are embedded in this standalone HTML file. The SQL and README may stay in your repository; they do not run automatically.

This is a static frontend connected to Supabase's hosted Auth, Database and Storage services. No PHP, XAMPP or local server is required for visitors.

## Important behavior
Cards are private to the signed-in Supabase user. Hiding the app behind the login interface is for navigation; database and storage policies enforce access. Website source remains public.

Attachments are downloaded through the authenticated storage client. Downloads create temporary browser object URLs, cleared on logout. Nothing is published in a public bucket.

The legacy browser entries stay in their original localStorage key until you explicitly choose Import into this account. Only import cards you own. Old cards without separate reasoning need editing. Entries from another site address cannot be read automatically.

Recording needs HTTPS (or localhost) and browser microphone permission. Audio upload remains available when recording is unsupported. Server upload policy allows at most 10 MB per file; the client applies a stricter 5 MB image limit.

Passwords and reset emails are handled by Supabase Auth. Default project email sending limits can affect invitations, confirmation or password resets; configure production email delivery in Supabase when needed.

## Verification
JavaScript syntax and mocked-client interaction tests were run. Anonymous database access was rejected by the actual Supabase project. Real email signup/login and authenticated upload/download require your account and configured redirect URLs, and must be checked after deployment. No test users or emails were created here.

## Manual checks
Create two separate test users yourself. For each, log in and create a card. Confirm neither sees the other's cards or attachments. Check verification and password reset links, reload persistence, edit/delete confirmation, optional image/audio uploads, microphone recording and the reveal step. Log out and confirm cards and previews disappear.

## Standalone packaging fix
All required styling and JavaScript are embedded in index.html, so no separate CSS, JS or vendor file paths are needed. A connection timeout fallback displays the login screen with an error and a reload option.
