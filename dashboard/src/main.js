import { supabase } from './lib/supabase.js';
import { LoginPage } from './components/LoginPage.js';
import { DashboardPage } from './components/DashboardPage.js';

const app = document.getElementById('app');

async function init() {
  // Wait for initial session
  const { data: { session } } = await supabase.auth.getSession();
  render(session?.user || null);

  // Listen for auth state changes
  supabase.auth.onAuthStateChange((event, session) => {
    console.log('Auth state changed:', event, session?.user?.id);
    if (event === 'SIGNED_IN' && session?.user) {
      render(session.user);
    } else if (event === 'SIGNED_OUT') {
      render(null);
    } else if (event === 'TOKEN_REFRESHED' && session?.user) {
      render(session.user);
    }
  });
}

function render(user) {
  app.innerHTML = '';
  
  if (user) {
    console.log('Rendering dashboard for user:', user.id);
    const dashboard = DashboardPage(user);
    app.appendChild(dashboard);
  } else {
    console.log('Rendering login page');
    const login = LoginPage();
    app.appendChild(login);
  }
}

// Initialize app
init();

