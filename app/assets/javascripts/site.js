//= require jquery-1.12.2.min
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails.js
//= require lightbox-2.6.min
//= require bootstrap
//= require horizon-swiper
//= require swiper
//= require mine
//= require custom

function popupwindow(url, w, h) {
  title = "Live Chat"
  var left = (screen.width/2)-(w/2);
  var top = (screen.height/2)-(h/2);
  return window.open(url, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
} 