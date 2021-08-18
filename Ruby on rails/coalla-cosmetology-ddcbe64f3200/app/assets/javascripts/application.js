// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.remotipart
//= require vendor/jquery.ui.touch-punch
//= require vendor/jquery.ui.datepicker-ru
//= require jquery-fileupload/basic
//= require backbone-rails
//= require vendor/accounting
//= require vendor/fontfaceobserver
//= require vendor/imagesloaded.pkgd
//= require vendor/jquery.arcticmodal
//= require vendor/jquery.extensions
//= require vendor/jquery.knob
//= require vendor/jquery.tokeninput.patched
//= require vendor/masonry.pkgd
//= require vendor/modernizr-latest
//= require vendor/owl.carousel
//= require vendor/scribd_api
//= require vendor/selectordie-patched.js
//= require vendor/social-likes
//= require vendor/jquery.mask
//= require vendor/moment
//= require vendor/intl-tel-input/intlTelInput-jquery
//= require vendor/intl-tel-input/utils
//= require fotorama
//= require courses_shop/jwplayer/jwplayer
//= require pdf.js
//= require holder
//= require js-routes
//= require config
//= require fonts
//= require forms
//= require has_many
//= require helpers
//= require project
//= require vendor/ifvisible
//= require cocoon
//= require dropdown
//= require courses_shop/components/_jwplayer_setup
//= require courses_shop/vendor/select2
//= require phone_mask
//****************************************************************************************************
//
// .. INIT
//
//****************************************************************************************************
//
// .. arcticModal
//
window.Modal = {};
window.Modal.openModal = function(url) {
  $.arcticmodal({
    closeOnOverlayClick: false,
    overlay: {
      css: {
        backgroundColor: "#000",
        opacity: 0.3
      }
    },
    url: url,
    type: "ajax"
  });
};

$.arcticmodal("setDefault", {
  overlay: {
    css: {
      backgroundColor: "#000",
      opacity: 0.66
    }
  },
  openEffect: {
    speed: 200
  },
  closeEffect: {
    speed: 200
  }
});

//
// .. Accounting
//
accounting.settings = {
  currency: {
    decimal: ".",
    thousand: " ",
    precision: 2
  },
  number: {
    decimal: ".",
    thousand: " ",
    precision: 0
  }
};

//****************************************************************************************************
//
// .. FUNCTIONS
//
//****************************************************************************************************
//
// .. Accounting
//
function formatNumber() {
  $(".format-number").each(function() {
    var number = parseInt(
        $(this)
          .text()
          .replace(new RegExp(" ", "g"), "")
      ),
      formatNumber = accounting.formatNumber(number);

    $(this).text(formatNumber);
  });
}

function formatMoney() {
  $(".format-money").each(function() {
    var c = accounting.settings.currency;

    if ($(this).hasClass("format-money__rub")) {
      c.format = "%v";
    } else if ($(this).hasClass("format-money__usd")) {
      c.symbol = "$";
      c.format = "%s %v";
    } else if ($(this).hasClass("format-money__eur")) {
      c.symbol = "€";
      c.format = "%s %v";
    }

    var money = parseFloat(
        $(this)
          .text()
          .replace(new RegExp(" ", "g"), "")
      ),
      formatMoney = accounting.formatMoney(money);

    if ($(this).hasClass("format-money__rub")) {
      $(this)
        .text(formatMoney)
        .append("&nbsp;<span class='rub'>Р</span>");
    } else {
      $(this).text(formatMoney);
    }
  });
}

//****************************************************************************************************
//
// .. EVENTS
//
//****************************************************************************************************
//
// .. Open dialog
//
$(document).on("touchend click", "[data-dialog='open']", function() {
  var url = $(this).data("url");

  $.arcticmodal("close");

  $.arcticmodal({
    type: "ajax",
    url: url
  });

  return false;
});

//
// .. Close dialog
//
$(document).on("touchend click", "[data-dialog='close']", function() {
  $.arcticmodal("close");

  return false;
});

//****************************************************************************************************
//
// .. READY
//
//****************************************************************************************************
$(function() {
  //****************************************************************************************************
  //
  // .. DOUBLE HOVER
  //
  //****************************************************************************************************
  doubleHover(".double-hover", "hover");

  //****************************************************************************************************
  //
  // .. FORMS
  // .. $('#checkbox').customForm() to init single element; $('body').customForm() to init all elements
  //
  //****************************************************************************************************
  $(".js-form").customForm();

  //****************************************************************************************************
  //
  // .. ACCOUNTING
  //
  //****************************************************************************************************
  formatNumber();
  formatMoney();

  //****************************************************************************************************
  //
  // .. RESIZE
  //
  //****************************************************************************************************
  $(window).smartresize(function() {
    // if (!Modernizr.touch) {
    //   $('#header').stickyHeader();
    // }
    $("#footer").stickyFooter();
  });
});

//****************************************************************************************************
//
// .. LOAD
//
//****************************************************************************************************
$(window).load(function() {
  // if (!Modernizr.touch) {
  //   $('#header').stickyHeader();
  // }
  $("#footer").stickyFooter();
});
