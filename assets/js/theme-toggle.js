// Dark mode functionality
class ThemeToggle {
  constructor() {
    this.init();
  }

  init() {
    // Get saved theme from localStorage or default to 'light'
    const savedTheme = localStorage.getItem('theme') || 'light';
    this.setTheme(savedTheme);

    // Add event listener to toggle button
    const toggleButton = document.getElementById('theme-toggle');
    if (toggleButton) {
      toggleButton.addEventListener('click', () => this.toggleTheme());
    }

    // Update button icon based on current theme
    this.updateIcon();
  }

  setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    this.currentTheme = theme;
    this.updateIcon();
  }

  toggleTheme() {
    const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
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

// Handle system theme preference changes
if (window.matchMedia) {
  const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
  
  // Set initial theme based on system preference if no saved theme
  if (!localStorage.getItem('theme')) {
    const initialTheme = mediaQuery.matches ? 'dark' : 'light';
    document.documentElement.setAttribute('data-theme', initialTheme);
  }
  
  // Listen for system theme changes
  mediaQuery.addEventListener('change', (e) => {
    if (!localStorage.getItem('theme')) {
      const newTheme = e.matches ? 'dark' : 'light';
      document.documentElement.setAttribute('data-theme', newTheme);
    }
  });
}
