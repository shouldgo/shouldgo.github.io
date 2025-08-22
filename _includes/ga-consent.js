// Google Analytics with Consent Mode v2 (Advanced)
// Respects Do Not Track and provides cookieless pings for non-consenting users

// Initialize dataLayer and gtag function
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}

// Set default consent state (all denied initially)
gtag('consent', 'default', {
  'ad_storage': 'denied',
  'analytics_storage': 'denied',
  'ad_user_data': 'denied',
  'ad_personalization': 'denied'
});

// Load Google Analytics script immediately (Advanced mode)
var script = document.createElement('script');
script.async = true;
script.src = 'https://www.googletagmanager.com/gtag/js?id={{ site.google_analytics }}';
document.head.appendChild(script);

// Initialize GA with respect for Do Not Track
if(!(window.doNotTrack === "1" || navigator.doNotTrack === "1" || navigator.doNotTrack === "yes" || navigator.msDoNotTrack === "1")) {
  gtag('js', new Date());
  gtag('config', '{{ site.google_analytics }}');
} else {
  console.log('Google Analytics disabled due to Do Not Track setting');
}

// Function to update consent when user accepts
window.updateGoogleConsent = function() {
  if(!(window.doNotTrack === "1" || navigator.doNotTrack === "1" || navigator.doNotTrack === "yes" || navigator.msDoNotTrack === "1")) {
    gtag('consent', 'update', {
      'analytics_storage': 'granted'
    });
    console.log('Google Analytics consent granted');
  }
};