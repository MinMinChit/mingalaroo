import { signIn } from "../utils/auth.js";

export function LoginPage() {
  const container = document.createElement("div");
  container.className =
    "w-full min-h-screen flex flex-col items-center justify-center p-6 transition-colors duration-200";

  container.innerHTML = `
    <div class="w-full max-w-[440px] flex flex-col gap-8">
      <div class="text-center space-y-3">
        <div
          class="inline-flex items-center justify-center size-12 rounded-full bg-primary/10 text-primary mb-2"
        >
          <span class="material-symbols-outlined !text-[28px]">favorite</span>
        </div>
        <h1
          class="text-4xl md:text-5xl font-serif font-bold italic leading-tight text-text-main-light dark:text-text-main-dark"
        >
          For Your Lovely Wedding
        </h1>
        <p
          class="text-text-secondary-light dark:text-text-secondary-dark font-display text-sm tracking-wide uppercase font-medium"
        >
          Planner Dashboard
        </p>
      </div>
      <div
        class="bg-surface-light dark:bg-surface-dark rounded-xl shadow-lg border border-border-light dark:border-border-dark overflow-hidden p-8 md:p-10 relative"
      >
        <div
          class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-primary to-transparent opacity-60"
        ></div>
        <form id="login-form" class="space-y-6">
          <div id="error-message" class="hidden text-sm text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/20 p-3 rounded-lg"></div>
          <div class="space-y-2">
            <label
              class="block text-sm font-semibold text-text-main-light dark:text-text-main-dark font-display"
              for="email"
            >
              Email Address
            </label>
            <input
              class="form-input block w-full rounded-lg border-border-light dark:border-border-dark bg-background-light dark:bg-background-dark/50 text-text-main-light dark:text-text-main-dark focus:border-primary focus:ring-primary h-12 px-4 transition-all duration-200 shadow-sm"
              id="email"
              name="email"
              placeholder="name@example.com"
              required
              type="email"
            />
          </div>
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <label
                class="block text-sm font-semibold text-text-main-light dark:text-text-main-dark font-display"
                for="password"
              >
                Password
              </label>
            </div>
            <input
              class="form-input block w-full rounded-lg border-border-light dark:border-border-dark bg-background-light dark:bg-background-dark/50 text-text-main-light dark:text-text-main-dark focus:border-primary focus:ring-primary h-12 px-4 transition-all duration-200 shadow-sm"
              id="password"
              name="password"
              placeholder="••••••••"
              required
              type="password"
            />
          </div>
          <button
            class="w-full flex items-center justify-center gap-2 bg-primary hover:bg-primary-dark text-white font-display font-medium tracking-wide py-3 px-4 rounded-lg h-12 transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5 mt-2"
            type="submit"
          >
            Sign In
          </button>
        </form>
        <div class="mt-6 text-center">
          <a
            class="text-sm font-medium text-text-secondary-light dark:text-text-secondary-dark hover:text-primary dark:hover:text-primary transition-colors underline decoration-transparent hover:decoration-current underline-offset-4"
            href="#"
          >
            Forgot Password?
          </a>
        </div>
      </div>
      <p
        class="text-center text-xs text-text-secondary-light/60 dark:text-text-secondary-dark/60"
      >
        Protected area. Authorized access only.
      </p>
    </div>
  `;

  const form = container.querySelector("#login-form");
  const errorMessage = container.querySelector("#error-message");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorMessage.classList.add("hidden");

    const email = form.email.value;
    const password = form.password.value;

    const { error } = await signIn(email, password);

    if (error) {
      errorMessage.textContent = error.message;
      errorMessage.classList.remove("hidden");
    } else {
      // Wait a moment for session to be established, then reload
      setTimeout(() => {
        window.location.reload();
      }, 500);
    }
  });

  return container;
}
