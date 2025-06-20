(function () {
  // Do not redirect if already done
  if (localStorage.getItem('langRedirected') === '1') return;

  // Browser language
  const userLang = navigator.language || navigator.userLanguage;

  // Language codes to redirect
  const redirectLangs = ['ru', 'uk', 'be', 'kk'];

  // Check against list
  if (redirectLangs.some(code => userLang.toLowerCase().startsWith(code))) {
    localStorage.setItem('langRedirected', '1');
    window.location.href = '/ru/';
  }
})();