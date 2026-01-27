export function generateSlug(name) {
  return name
    .toLowerCase()
    .trim()
    .replace(/[^\p{L}\p{N}]+/gu, "-") // Keeps all Unicode letters and numbers
    .replace(/^-+|-+$/g, "");        // Removes leading/trailing hyphens
}


// Generate full link: mingalaroo.com/{user_id}/{slug}
export function generateLink(userId, slug) {
  return `mingalaroo.com/akpcpp/?guest=${slug}`;
}

// Calculate guest count from string like "1 + 1" or "2 + 3"
export function calculateGuestCount(guestCountStr) {
  if (!guestCountStr || guestCountStr === "-" || guestCountStr === "0") {
    return { display: guestCountStr, total: 0 };
  }

  // Match pattern like "1 + 1" or "2 + 3"
  const match = guestCountStr.match(/(\d+)\s*\+\s*(\d+)/);
  if (match) {
    const primary = parseInt(match[1], 10);
    const additional = parseInt(match[2], 10);
    const total = primary + additional;
    return { display: `${guestCountStr} = ${total}`, total };
  }

  // If it's just a number
  const num = parseInt(guestCountStr, 10);
  if (!isNaN(num)) {
    return { display: guestCountStr, total: num };
  }

  return { display: guestCountStr, total: 0 };
}

// Get initials from name
export function getInitials(name) {
  const parts = name.trim().split(/\s+/);
  if (parts.length >= 2) {
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
  return name.substring(0, 2).toUpperCase();
}

// Get color class for avatar based on initials
export function getAvatarColor(initials) {
  const colors = [
    "bg-indigo-50 dark:bg-indigo-900/20 text-indigo-600 dark:text-indigo-400 border-indigo-100 dark:border-indigo-800",
    "bg-amber-50 dark:bg-amber-900/20 text-amber-600 dark:text-amber-400 border-amber-100 dark:border-amber-800",
    "bg-slate-50 dark:bg-slate-800 text-slate-600 dark:text-slate-400 border-slate-200 dark:border-slate-700",
    "bg-purple-50 dark:bg-purple-900/20 text-purple-600 dark:text-purple-400 border-purple-100 dark:border-purple-800",
    "bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400 border-emerald-100 dark:border-emerald-800",
    "bg-rose-50 dark:bg-rose-900/20 text-rose-600 dark:text-rose-400 border-rose-100 dark:border-rose-800",
  ];
  const index = initials.charCodeAt(0) % colors.length;
  return colors[index];
}

// Copy to clipboard
export async function copyToClipboard(text) {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch (err) {
    console.error("Failed to copy:", err);
    return false;
  }
}
