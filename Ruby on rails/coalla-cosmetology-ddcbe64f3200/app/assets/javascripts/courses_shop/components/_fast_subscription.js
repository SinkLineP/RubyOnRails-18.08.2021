$(function () {
   $('.js-show-registration-popup').on('click', function () {
       popups.mfpOpenPopup('#popup-login', '#');
       return false;
   })
});