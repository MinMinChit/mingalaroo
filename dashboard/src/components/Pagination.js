export function Pagination({
  currentPage = 1,
  totalItems = 0,
  itemsPerPage = 20,
  onPageChange,
}) {
  const container = document.createElement("div");
  container.className =
    "px-6 py-4 border-t border-border-light dark:border-border-dark flex items-center justify-between bg-surface-light dark:bg-surface-dark";

  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const startItem = totalItems === 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
  const endItem = Math.min(currentPage * itemsPerPage, totalItems);

  container.innerHTML = `
    <p
      class="text-sm text-text-secondary-light dark:text-text-secondary-dark font-display"
    >
      Showing
      <span
        class="font-medium text-text-main-light dark:text-text-main-dark"
        >${startItem}</span
      >
      to
      <span
        class="font-medium text-text-main-light dark:text-text-main-dark"
        >${endItem}</span
      >
      of
      <span
        class="font-medium text-text-main-light dark:text-text-main-dark"
        >${totalItems}</span
      >
      guests
    </p>
    <div class="flex gap-2 font-display">
      <button
        id="prev-btn"
        class="flex items-center justify-center px-4 py-1.5 rounded border border-border-light dark:border-border-dark bg-white dark:bg-surface-dark text-text-secondary-light dark:text-text-secondary-dark text-sm hover:border-primary hover:text-primary transition-colors disabled:opacity-50"
        ${currentPage === 1 ? "disabled" : ""}
      >
        Previous
      </button>
      <button
        id="next-btn"
        class="flex items-center justify-center px-4 py-1.5 rounded border border-border-light dark:border-border-dark bg-white dark:bg-surface-dark text-text-secondary-light dark:text-text-secondary-dark text-sm hover:border-primary hover:text-primary transition-colors"
        ${currentPage >= totalPages ? "disabled" : ""}
      >
        Next
      </button>
    </div>
  `;

  const prevBtn = container.querySelector("#prev-btn");
  const nextBtn = container.querySelector("#next-btn");

  prevBtn.addEventListener("click", () => {
    if (currentPage > 1 && onPageChange) {
      onPageChange(currentPage - 1);
    }
  });

  nextBtn.addEventListener("click", () => {
    if (currentPage < totalPages && onPageChange) {
      onPageChange(currentPage + 1);
    }
  });

  return container;
}
