export function Footer() {
  const footer = document.createElement("footer");
  footer.className =
    "w-full text-center py-6 border-t border-border-light dark:border-border-dark mt-auto bg-surface-light dark:bg-surface-dark";

  footer.innerHTML = `
    <p
      class="text-sm text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center gap-1 font-display"
    >
      Made with
      <span
        class="material-symbols-outlined text-[14px] text-rose-500 fill-current"
        >favorite</span
      >
      for our lovely wedding
    </p>
  `;

  return footer;
}
