export function StatsCards({ invited = 0, attending = 0, gifts = 0 }) {
  const container = document.createElement("div");
  container.className = "flex gap-4";

  container.innerHTML = `
    <div
      class="bg-surface-light dark:bg-surface-dark px-6 py-4 rounded-xl border border-border-light dark:border-border-dark flex flex-col items-center min-w-[120px] shadow-sm"
    >
      <span
        class="text-3xl font-serif font-bold text-text-main-light dark:text-text-main-dark"
        >${invited}</span
      >
      <span
        class="text-xs text-primary uppercase tracking-widest font-display font-semibold mt-1"
        >Invited</span
      >
    </div>
    <div
      class="bg-surface-light dark:bg-surface-dark px-6 py-4 rounded-xl border border-border-light dark:border-border-dark flex flex-col items-center min-w-[120px] shadow-sm"
    >
      <span
        class="text-3xl font-serif font-bold text-emerald-600 dark:text-emerald-400"
        >${attending}</span
      >
      <span
        class="text-xs text-primary uppercase tracking-widest font-display font-semibold mt-1"
        >Attending</span
      >
    </div>
    <div
      class="bg-surface-light dark:bg-surface-dark px-6 py-4 rounded-xl border border-border-light dark:border-border-dark flex flex-col items-center min-w-[120px] shadow-sm"
    >
      <span class="text-3xl font-serif font-bold text-rose-500">${gifts}</span>
      <span
        class="text-xs text-primary uppercase tracking-widest font-display font-semibold mt-1"
        >Gifts</span
      >
    </div>
  `;

  return container;
}
