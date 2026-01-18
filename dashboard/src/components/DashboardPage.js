import { supabase } from "../lib/supabase.js";
import { Header } from "./Header.js";
import { Footer } from "./Footer.js";
import { StatsCards } from "./StatsCards.js";
import { AddGuestForm } from "./AddGuestForm.js";
import { GuestTable } from "./GuestTable.js";

export function DashboardPage(user) {
  const container = document.createElement("div");
  container.className = "min-h-screen flex flex-col";

  let currentPage = 1;
  const itemsPerPage = 20;
  let guests = [];

  const loadGuests = async () => {
    try {
      // Verify user is authenticated
      if (!user || !user.id) {
        throw new Error("User not authenticated");
      }

      const { data, error } = await supabase
        .from("invited_users")
        .select("*")
        .eq("user_id", user.id)
        .order("created_at", { ascending: false });

      if (error) {
        console.error("Supabase error:", error);
        throw error;
      }

      guests = data || [];
      render();
    } catch (error) {
      console.error("Error loading guests:", error);

      // More helpful error messages
      let errorMessage = "Failed to load guests: ";
      if (error.message) {
        errorMessage += error.message;
      } else if (error.code) {
        errorMessage += `Error code: ${error.code}`;
      } else {
        errorMessage +=
          "Please check your Supabase configuration and ensure the table exists.";
      }

      // Still render the page with empty state
      guests = [];
      render();

      // Show error after a short delay to allow page to render
      setTimeout(() => {
        alert(errorMessage);
      }, 100);
    }
  };

  const calculateStats = () => {
    const invited = guests.length;
    const attending = guests.filter(
      (g) => g.attendance_state === "attending"
    ).length;
    const gifts = guests.filter((g) => g.gift_status === "gifted").length;
    return { invited, attending, gifts };
  };

  const handleGuestAdded = () => {
    loadGuests();
  };

  const handleGuestUpdate = async (guest) => {
    // Simple edit modal - you can enhance this later
    const newName = prompt("Edit guest name:", guest.guest_name);
    if (newName && newName.trim() !== guest.guest_name) {
      try {
        const { error } = await supabase
          .from("invited_users")
          .update({ guest_name: newName.trim() })
          .eq("id", guest.id);

        if (error) throw error;
        loadGuests();
      } catch (error) {
        console.error("Error updating guest:", error);
        alert("Failed to update guest: " + error.message);
      }
    }
  };

  const handleGuestDelete = () => {
    loadGuests();
  };

  const handlePageChange = (page) => {
    currentPage = page;
    render();
  };

  const render = () => {
    container.innerHTML = "";

    const header = Header();
    container.appendChild(header);

    const main = document.createElement("main");
    main.className = "flex-1 w-full max-w-[1200px] mx-auto px-6 py-8";

    // Title and stats section
    const titleSection = document.createElement("div");
    titleSection.className =
      "flex flex-wrap justify-between items-end gap-4 mb-8";

    const titleDiv = document.createElement("div");
    titleDiv.className = "flex flex-col gap-2";
    titleDiv.innerHTML = `
      <h1
        class="text-text-main-light dark:text-text-main-dark text-4xl md:text-5xl font-serif font-bold italic leading-tight tracking-tight"
      >
        For Your Lovely Wedding
      </h1>
      <p
        class="text-text-secondary-light dark:text-text-secondary-dark text-base font-display font-normal"
      >
        Manage your guest list, RSVPs, and gifts in one place.
      </p>
    `;

    const stats = calculateStats();
    const statsCards = StatsCards(stats);

    titleSection.appendChild(titleDiv);
    titleSection.appendChild(statsCards);

    // Add guest form
    const addGuestForm = AddGuestForm({
      userId: user.id,
      onGuestAdded: handleGuestAdded,
    });

    // Guest table
    const guestTable = GuestTable({
      guests,
      currentPage,
      itemsPerPage,
      onUpdate: handleGuestUpdate,
      onDelete: handleGuestDelete,
      onPageChange: handlePageChange,
    });

    main.appendChild(titleSection);
    main.appendChild(addGuestForm);
    main.appendChild(guestTable);

    container.appendChild(main);

    const footer = Footer();
    container.appendChild(footer);
  };

  // Initial load
  loadGuests();

  return container;
}
