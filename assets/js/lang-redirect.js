// assets/js/lang-redirect.js

(function () {
  if (!localStorage.getItem('langRedirected')) {
    const lang = (navigator.language || '').split('-')[0];
    if (lang !== 'ru') {
      window.location.href = '/en/';
    }
    localStorage.setItem('langRedirected', '1');
  }
})();