var $teachersItemsSlider = $("#teachers-items-slider");
function disableButtons() {
  $("#teachers-items-slider-prev").addClass("d-none");
  $("#teachers-items-slider-next").addClass("d-none");
}
function teachersItemsSliderInit() {
  if ($teachersItemsSlider.length) {
    $("#teachers-items-slider-prev").on("click", function() {
      $teachersItemsSlider.slick("slickPrev");

      return false;
    });

    $("#teachers-items-slider-next").on("click", function() {
      $teachersItemsSlider.slick("slickNext");

      return false;
    });

    $teachersItemsSlider.slick({
      autoplay: false,
      adaptiveHeight: false,
      arrows: false,
      customPaging: function() {
        return "<span/>";
      },
      dots: false,
      draggable: false,
      infinite: true,
      slidesToShow: 3,
      slidesToScroll: 1,
      variableWidth: true,
      responsive: [
        {
          breakpoint: BREAKPOINT_MOBILE_INT,
          settings: {
						dots: true,
            slidesToShow: 1,
						slidesToScroll: 1,
            mobileFirst: true
          }
        }
      ]
    });
  }
}

$(document).ready(function() {
  teachersItemsSliderInit();
  var $length = $(".teachers-items__item").length;
  if (Modernizr.mq(BREAKPOINT_MOBILE) && $length == 1) {
    disableButtons();
  } else if ($length <= 3) {
    disableButtons();
  }
});
