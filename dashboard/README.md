# Wedding Planner Dashboard

A beautiful wedding guest list and RSVP management dashboard built with Vite, vanilla JavaScript, and Supabase.

## Features

- 🔐 Email/password authentication with Supabase
- 👥 Guest list management (Add, Edit, Delete)
- 📊 Real-time statistics (Invited, Attending, Gifts)
- 🔗 Personalized RSVP links for each guest
- 📄 Pagination (20 items per page)
- 📥 Export guest list to CSV
- 🎨 Beautiful UI with dark mode support
- 📱 Responsive design

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Set up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the migration script (see `supabase-migration.sql`)
3. Go to Settings > API and copy your:
   - Project URL
   - Anon public key

### 3. Configure Environment Variables

Create a `.env` file in the root directory:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4. Run the Development Server

```bash
npm run dev
```

The app will open at `http://localhost:3000`

### 5. Build for Production

```bash
npm run build
```

## Database Schema

The `invited_users` table has the following structure:

- `id` (uuid, primary key)
- `guest_name` (text)
- `generated_link` (text, unique) - Format: `mingalaroo.com/{user_id}/{slug}`
- `attendance_state` (text) - Values: `pending`, `attending`, `not_attending`
- `guest_count` (text) - Format: `"1 + 1"`, `"2 + 3"`, `"0"`, `"-"`
- `gift_status` (text) - Values: `not_yet`, `gifted`
- `user_id` (uuid, foreign key to auth.users)
- `created_at` (timestamp)

## Project Structure

```
dashboard/
├── index.html          # Entry HTML file
├── package.json        # Dependencies
├── vite.config.js      # Vite configuration
├── src/
│   ├── main.js        # App entry point & routing
│   ├── lib/
│   │   └── supabase.js    # Supabase client
│   ├── components/    # UI components
│   │   ├── LoginPage.js
│   │   ├── DashboardPage.js
│   │   ├── Header.js
│   │   ├── Footer.js
│   │   ├── StatsCards.js
│   │   ├── AddGuestForm.js
│   │   ├── GuestTable.js
│   │   ├── GuestTableRow.js
│   │   └── Pagination.js
│   └── utils/         # Utility functions
│       ├── auth.js    # Authentication helpers
│       └── helpers.js # General helpers
```

## Usage

1. **Login**: Use your Supabase email/password to sign in
2. **Add Guest**: Enter a guest name and click "Send Invite"
3. **View Guests**: See all guests in the table with their RSVP status
4. **Edit Guest**: Click the edit icon to modify a guest's name
5. **Delete Guest**: Click the delete icon to remove a guest
6. **Copy Link**: Click the copy icon next to a guest's link
7. **Export**: Click "Export" to download a CSV of all guests

## Notes

- Guest links are generated automatically in the format: `mingalaroo.com/{user_id}/{slug}`
- Guest count displays calculation (e.g., "1 + 1 = 2")
- All data is scoped to the logged-in user via Row Level Security (RLS)

