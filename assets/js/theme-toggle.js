// Dark mode functionality
class ThemeToggle {
  constructor() {
    this.init();
  }

  init() {
    // Check for saved theme preference or default to system preference
    const savedTheme = localStorage.getItem('theme');
    
    if (savedTheme) {
      // User has manually set a preference
      this.setTheme(savedTheme);
    } else {
      // Use system preference
      const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      this.setTheme(systemPrefersDark ? 'dark' : 'light');
    }

    // Add event listener to toggle button
    const toggleButton = document.getElementById('theme-toggle');
    if (toggleButton) {
      toggleButton.addEventListener('click', () => this.toggleTheme());
    }

    // Listen for system theme changes (only if user hasn't manually set preference)
    if (window.matchMedia) {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
      mediaQuery.addEventListener('change', (e) => {
        // Only update if user hasn't manually set a preference
        if (!localStorage.getItem('theme')) {
          this.setTheme(e.matches ? 'dark' : 'light');
        }
      });
    }

    // Update button icon based on current theme
    this.updateIcon();
  }

  setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    this.currentTheme = theme;
    this.updateIcon();
  }

  toggleTheme() {
    const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
    // Save user's manual choice
    localStorage.setItem('theme', newTheme);
    this.setTheme(newTheme);
  }

  updateIcon() {
    const button = document.getElementById('theme-toggle');
    if (button) {
      button.textContent = this.currentTheme === 'light' ? '🌚' : '🌝';
    }
  }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  new ThemeToggle();
});
