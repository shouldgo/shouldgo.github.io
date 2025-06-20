// GA Test Script
document.addEventListener('DOMContentLoaded', function() {
  // Create a test event button
  const testButton = document.createElement('button');
  testButton.innerText = 'Test GA Event';
  testButton.style.position = 'fixed';
  testButton.style.bottom = '20px';
  testButton.style.right = '20px';
  testButton.style.zIndex = '9999';
  testButton.style.padding = '10px';
  testButton.style.backgroundColor = '#f44336';
  testButton.style.color = 'white';
  testButton.style.border = 'none';
  testButton.style.borderRadius = '4px';
  testButton.style.cursor = 'pointer';
  
  testButton.addEventListener('click', function() {
    if (typeof gtag === 'function') {
      // Send a test event
      gtag('event', 'test_event', {
        'event_category': 'testing',
        'event_label': 'GA Test ' + new Date().toISOString(),
        'value': 1
      });
      
      alert('Test event sent to Google Analytics. Check your GA dashboard in a few minutes.');
      console.log('Test event sent to Google Analytics');
    } else {
      alert('Google Analytics gtag function not found! GA might not be loaded correctly.');
      console.error('Google Analytics gtag function not found');
    }
  });
  
  document.body.appendChild(testButton);
});
