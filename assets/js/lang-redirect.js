// assets/js/lang-redirect.js
(function () {
    if (!localStorage.getItem('langRedirected')) {
        const lang = (navigator.language || '').split('-')[0];
        const slavicLangs = ['ru', 'uk', 'kk', 'be']; // Russian, Ukrainian, Kazakh, Belarusian
        
        if (slavicLangs.includes(lang)) {
            window.location.href = '/ru/';
        }
        localStorage.setItem('langRedirected', '1');
    }
})();