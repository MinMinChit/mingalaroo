import { signOut } from "../utils/auth.js";

export function Header() {
  const header = document.createElement("header");
  header.className =
    "sticky top-0 z-50 w-full bg-surface-light dark:bg-surface-dark border-b border-border-light dark:border-border-dark px-6 py-3";

  header.innerHTML = `
    <div class="max-w-[1200px] mx-auto flex items-center justify-between">
      <div
        class="flex items-center gap-4 text-text-main-light dark:text-text-main-dark"
      >
        <div
          class="size-8 flex items-center justify-center bg-primary/10 rounded-lg text-primary"
        >
          <span class="material-symbols-outlined !text-[24px]">favorite</span>
        </div>
        <h2
          class="text-xl font-serif font-bold leading-tight tracking-tight text-primary-dark dark:text-primary"
        >
          Mingalaroo
        </h2>
      </div>
      <div class="flex items-center gap-6">
        <button
          id="settings-btn"
          class="flex items-center justify-center rounded-lg p-2 text-text-secondary-light dark:text-text-secondary-dark hover:bg-background-light dark:hover:bg-background-dark transition-colors"
          title="Settings"
        >
          <span class="material-symbols-outlined">settings</span>
        </button>
        <button
          id="logout-btn"
          class="flex items-center justify-center rounded-lg p-2 text-text-secondary-light dark:text-text-secondary-dark hover:bg-background-light dark:hover:bg-background-dark transition-colors"
          title="Logout"
        >
          <span class="material-symbols-outlined">logout</span>
        </button>
        <div
          class="size-10 rounded-full bg-cover bg-center border-2 border-primary/20"
          data-alt="User profile avatar image"
          style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCkfkjDvJOP0wowNNOMF711x7J7XHHUgql08dmTmainJPqZaAXImNrEoKEpmCk5KhGM5riQQyBEBLRRkns4G8SfFYlYbXG1RhAX9edktw6U64eeLXcZIpvY6-FF7XuxuDJswL5BXPSONf8_IoIle9vgU_AEMtmPEUrhZQVC6GOvIOWhoZlyUh0RG8K0Zm3GU6JDCw5RIg2yyrc53qxJxFlGZkPNdrcpeqE0fCh6iEHuEUYDkBeID38Fd4ey4kQhbpWOCzk9Q-m7HQ');"
        ></div>
      </div>
    </div>
  `;

  const logoutBtn = header.querySelector("#logout-btn");
  logoutBtn.addEventListener("click", async () => {
    await signOut();
    window.location.reload();
  });

  return header;
}
