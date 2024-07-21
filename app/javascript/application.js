// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:load', function() {
  var flashMessages = document.querySelectorAll('.alert');
  flashMessages.forEach(function(flashMessage) {
    setTimeout(function() {
      flashMessage.style.transition = 'opacity 0.5s ease';
      flashMessage.style.opacity = 0;
      setTimeout(function() {
        flashMessage.remove();
      }, 200);
    }, 1500);
  });
});
