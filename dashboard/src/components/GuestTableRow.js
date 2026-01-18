import { supabase } from '../lib/supabase.js';
import { getInitials, getAvatarColor, calculateGuestCount, copyToClipboard } from '../utils/helpers.js';

export function GuestTableRow(guest, onUpdate, onDelete) {
  const row = document.createElement('tr');
  row.className = 'hover:bg-background-light dark:hover:bg-background-dark/30 transition-colors group';

  const initials = getInitials(guest.guest_name);
  const avatarColor = getAvatarColor(initials);
  const guestCountInfo = calculateGuestCount(guest.guest_count);

  const getAttendanceBadge = (state) => {
    switch (state) {
      case 'attending':
        return `
          <span
            class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-emerald-50 text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400 border border-emerald-100 dark:border-emerald-800/50 items-center gap-1 font-display"
          >
            <span
              class="material-symbols-outlined text-[14px] fill-current"
              >check_circle</span
            >
            Attending
          </span>
        `;
      case 'not_attending':
        return `
          <span
            class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400 border border-gray-200 dark:border-gray-700 items-center gap-1 font-display"
          >
            <span class="material-symbols-outlined text-[14px]"
              >cancel</span
            >
            Not Attending
          </span>
        `;
      default:
        return `
          <span
            class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-amber-50 text-amber-700 dark:bg-amber-900/20 dark:text-amber-400 border border-amber-100 dark:border-amber-800/50 items-center gap-1 font-display"
          >
            <span class="material-symbols-outlined text-[14px]"
              >hourglass_empty</span
            >
            Pending
          </span>
        `;
    }
  };

  const getGiftStatus = (status) => {
    if (status === 'gifted') {
      return `
        <div class="flex items-center text-rose-500 gap-1.5">
          <span
            class="material-symbols-outlined text-[18px] fill-current"
            >favorite</span
          >
          <span
            class="text-xs font-semibold uppercase tracking-wide font-display"
            >Gifted</span
          >
        </div>
      `;
    }
    return `
      <span
        class="text-xs text-text-secondary-light dark:text-text-secondary-dark italic font-display"
        >Not yet</span
    `;
  };

  row.innerHTML = `
    <td class="px-6 py-4 whitespace-nowrap">
      <div class="flex items-center">
        <div
          class="h-9 w-9 rounded-full ${avatarColor} flex items-center justify-center font-display font-bold mr-3 text-sm border"
        >
          ${initials}
        </div>
        <div
          class="text-sm font-medium text-text-main-light dark:text-text-main-dark font-serif text-[15px]"
        >
          ${guest.guest_name}
        </div>
      </div>
    </td>
    <td class="px-6 py-4 whitespace-nowrap">
      <div
        class="flex items-center gap-2 max-w-xs bg-background-light dark:bg-background-dark/50 rounded px-3 py-1.5 border border-border-light dark:border-border-dark/50 group-hover:border-primary/30 transition-colors"
      >
        <span
          class="text-xs text-text-secondary-light dark:text-text-secondary-dark truncate select-all font-display"
          >${guest.generated_link}</span
        >
        <button
          class="copy-link-btn ml-auto text-text-secondary-light dark:text-text-secondary-dark hover:text-primary transition-colors"
          title="Copy Link"
        >
          <span class="material-symbols-outlined text-[14px]"
            >content_copy</span
          >
        </button>
      </div>
    </td>
    <td class="px-6 py-4 whitespace-nowrap">
      ${getAttendanceBadge(guest.attendance_state)}
    </td>
    <td
      class="px-6 py-4 whitespace-nowrap text-sm text-text-main-light dark:text-text-main-dark font-medium pl-10 font-display"
    >
      ${guestCountInfo.display}
    </td>
    <td class="px-6 py-4 whitespace-nowrap">
      ${getGiftStatus(guest.gift_status)}
    </td>
    <td
      class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium"
    >
      <div
        class="flex justify-end gap-1 opacity-60 group-hover:opacity-100 transition-opacity"
      >
        <button
          class="edit-btn text-text-secondary-light dark:text-text-secondary-dark hover:text-primary transition-colors p-1.5 rounded-full hover:bg-primary/5"
          title="Edit"
        >
          <span class="material-symbols-outlined text-[18px]"
            >edit</span
          >
        </button>
        <button
          class="delete-btn text-text-secondary-light dark:text-text-secondary-dark hover:text-red-600 transition-colors p-1.5 rounded-full hover:bg-red-50 dark:hover:bg-red-900/10"
          title="Delete"
        >
          <span class="material-symbols-outlined text-[18px]"
            >delete</span
          >
        </button>
      </div>
    </td>
  `;

  // Copy link functionality
  const copyBtn = row.querySelector('.copy-link-btn');
  copyBtn.addEventListener('click', async () => {
    const success = await copyToClipboard(guest.generated_link);
    if (success) {
      const icon = copyBtn.querySelector('span');
      icon.textContent = 'check';
      setTimeout(() => {
        icon.textContent = 'content_copy';
      }, 2000);
    }
  });

  // Edit functionality
  const editBtn = row.querySelector('.edit-btn');
  editBtn.addEventListener('click', () => {
    if (onUpdate) {
      onUpdate(guest);
    }
  });

  // Delete functionality
  const deleteBtn = row.querySelector('.delete-btn');
  deleteBtn.addEventListener('click', async () => {
    if (confirm(`Are you sure you want to delete ${guest.guest_name}?`)) {
      try {
        const { error } = await supabase
          .from('invited_users')
          .delete()
          .eq('id', guest.id);

        if (error) throw error;
        
        if (onDelete) {
          onDelete(guest.id);
        }
      } catch (error) {
        console.error('Error deleting guest:', error);
        alert('Failed to delete guest: ' + error.message);
      }
    }
  });

  return row;
}

