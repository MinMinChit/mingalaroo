import { supabase } from "../lib/supabase.js";
import { generateSlug, generateLink } from "../utils/helpers.js";

export function AddGuestForm({ userId, onGuestAdded }) {
  const container = document.createElement("section");
  container.className =
    "bg-surface-light dark:bg-surface-dark rounded-xl border border-primary/20 dark:border-primary/10 p-8 mb-10 shadow-md relative overflow-hidden";

  container.innerHTML = `
    <div
      class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-primary to-transparent opacity-50"
    ></div>
    <h3
      class="text-text-main-light dark:text-text-main-dark text-2xl font-serif italic font-bold mb-6 text-center md:text-left"
    >
      Add a guest to your list
    </h3>
    <div class="flex flex-wrap md:flex-nowrap items-end gap-5">
      <div class="flex-1 w-full">
        <label class="sr-only" for="guest-name">Guest Name</label>
        <div class="relative group">
          <div
            class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-primary/70"
          >
            <span class="material-symbols-outlined font-light"
              >edit_note</span
            >
          </div>
          <input
            class="form-input block w-full pl-12 pr-4 py-4 border-border-light dark:border-border-dark rounded-lg leading-5 bg-background-light dark:bg-background-dark/50 text-text-main-light dark:text-text-main-dark placeholder-text-secondary-light/60 font-display text-lg focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary transition duration-200 ease-in-out h-16 shadow-inner"
            id="guest-name"
            placeholder="Enter guest name (e.g. Mr. &amp; Mrs. Smith)"
            type="text"
          />
        </div>
      </div>
      <button
        id="add-guest-btn"
        class="w-full md:w-auto flex items-center justify-center gap-3 bg-primary hover:bg-primary-dark text-white font-display font-medium tracking-wide py-4 px-10 rounded-lg h-16 transition-all duration-200 min-w-[200px] shadow-md hover:shadow-lg transform hover:-translate-y-0.5"
      >
        <span class="material-symbols-outlined text-[20px]">send</span>
        <span>Add Guest</span>
      </button>
    </div>
  `;

  const input = container.querySelector("#guest-name");
  const button = container.querySelector("#add-guest-btn");

  button.addEventListener("click", async () => {
    const guestName = input.value.trim();

    if (!guestName) {
      alert("Please enter a guest name");
      return;
    }

    button.disabled = true;
    button.innerHTML =
      '<span class="material-symbols-outlined text-[20px] animate-spin">hourglass_empty</span><span>Adding...</span>';

    try {
      const slug = generateSlug(guestName);
      const generatedLink = generateLink(userId, slug);

      const { data, error } = await supabase
        .from("invited_users")
        .insert([
          {
            guest_name: guestName,
            generated_link: generatedLink,
            attendance_state: "pending",
            guest_count: "-",
            gift_status: "not_yet",
            user_id: userId,
          },
        ])
        .select()
        .single();

      if (error) {
        throw error;
      }

      input.value = "";
      if (onGuestAdded) {
        onGuestAdded(data);
      }
    } catch (error) {
      console.error("Error adding guest:", error);
      alert("Failed to add guest: " + error.message);
    } finally {
      button.disabled = false;
      button.innerHTML =
        '<span class="material-symbols-outlined text-[20px]">send</span><span>Add Guest</span>';
    }
  });

  // Allow Enter key to submit
  input.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      button.click();
    }
  });

  return container;
}
