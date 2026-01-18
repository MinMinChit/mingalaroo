import { GuestTableRow } from './GuestTableRow.js';
import { Pagination } from './Pagination.js';

export function GuestTable({ guests = [], currentPage = 1, itemsPerPage = 20, onUpdate, onDelete, onPageChange }) {
  const container = document.createElement('section');
  container.className = 'bg-surface-light dark:bg-surface-dark rounded-xl border border-border-light dark:border-border-dark overflow-hidden shadow-sm';

  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginatedGuests = guests.slice(startIndex, endIndex);

  container.innerHTML = `
    <div
      class="px-6 py-5 border-b border-border-light dark:border-border-dark flex justify-between items-center bg-gray-50/30 dark:bg-gray-800/20"
    >
      <h3
        class="text-text-main-light dark:text-text-main-dark text-lg font-serif font-bold"
      >
        RSVP Responses
      </h3>
      <div class="flex gap-2">
        <button
          id="filter-btn"
          class="flex items-center gap-2 px-3 py-2 text-sm text-text-secondary-light dark:text-text-secondary-dark hover:text-primary dark:hover:text-primary hover:bg-primary/5 rounded-md transition-colors border border-transparent hover:border-primary/20 font-display"
        >
          <span class="material-symbols-outlined text-[18px]"
            >filter_list</span
          >
          <span>Filter</span>
        </button>
        <button
          id="export-btn"
          class="flex items-center gap-2 px-3 py-2 text-sm text-text-secondary-light dark:text-text-secondary-dark hover:text-primary dark:hover:text-primary hover:bg-primary/5 rounded-md transition-colors border border-transparent hover:border-primary/20 font-display"
        >
          <span class="material-symbols-outlined text-[18px]"
            >download</span
          >
          <span>Export</span>
        </button>
      </div>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-left border-collapse">
        <thead class="bg-background-light dark:bg-background-dark/50">
          <tr>
            <th
              class="px-6 py-4 text-xs font-bold text-text-secondary-light dark:text-text-secondary-dark uppercase tracking-wider w-[20%] font-display"
            >
              Guest Name
            </th>
            <th
              class="px-6 py-4 text-xs font-bold text-text-secondary-light dark:text-text-secondary-dark uppercase tracking-wider w-[25%] font-display"
            >
              Personalized Link
            </th>
            <th
              class="px-6 py-4 text-xs font-bold text-text-secondary-light dark:text-text-secondary-dark uppercase tracking-wider w-[15%] font-display"
            >
              Attendance
            </th>
            <th
              class="px-6 py-4 text-xs font-bold text-text-secondary-light dark:text-text-secondary-dark uppercase tracking-wider w-[12%] font-display"
            >
              Guest Count
            </th>
            <th
              class="px-6 py-4 text-xs font-bold text-text-secondary-light dark:text-text-secondary-dark uppercase tracking-wider w-[15%] font-display"
            >
              Gift Status
            </th>
            <th
              class="px-6 py-4 text-xs font-bold text-text-secondary-light dark:text-text-secondary-dark uppercase tracking-wider text-right w-[13%] font-display"
            >
              Actions
            </th>
          </tr>
        </thead>
        <tbody id="table-body" class="divide-y divide-border-light dark:divide-border-dark">
        </tbody>
      </table>
    </div>
  `;

  const tbody = container.querySelector('#table-body');
  
  // Clear and populate table rows
  tbody.innerHTML = '';
  if (paginatedGuests.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="6" class="px-6 py-8 text-center text-text-secondary-light dark:text-text-secondary-dark">
          No guests found. Add your first guest above!
        </td>
      </tr>
    `;
  } else {
    paginatedGuests.forEach(guest => {
      const row = GuestTableRow(guest, onUpdate, onDelete);
      tbody.appendChild(row);
    });
  }

  // Add pagination
  const pagination = Pagination({
    currentPage,
    totalItems: guests.length,
    itemsPerPage,
    onPageChange,
  });
  container.appendChild(pagination);

  // Export functionality
  const exportBtn = container.querySelector('#export-btn');
  exportBtn.addEventListener('click', () => {
    const csv = [
      ['Guest Name', 'Link', 'Attendance', 'Guest Count', 'Gift Status'].join(','),
      ...guests.map(g => [
        `"${g.guest_name}"`,
        g.generated_link,
        g.attendance_state,
        g.guest_count,
        g.gift_status
      ].join(','))
    ].join('\n');

    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `wedding-guests-${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
  });

  return container;
}

