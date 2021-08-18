var $siteHeader = $("#site-header");
var $siteLogo = $("#site-logo");
var $siteLogoLarge = $("#site-logo-lg");
var $sitePhone = $("#site-phone");
var $pagePromo = $("#page-promo");
var siteHeaderHeight = 0;
var $dropdown = $(".site-header__nav-dropdown");
function siteHeaderShow() {
  $siteHeader.css({
    opacity: 1,
    visibility: "visible"
  });
}

function siteHeaderInit() {
  if ($siteHeader.length) {
    if ($pagePromo.length) {
      $siteHeader.transitionEnd(function() {
        if (siteHeaderHeight === 0) {
          siteHeaderHeight = $siteHeader.outerHeight();
        }
      });

      if (windowScrollTop > $pagePromo.outerHeight() - siteHeaderHeight) {
        $siteHeader.removeClass("site-header--lg");

        $siteLogo.parent("a").css("pointer-events", "auto");
        $siteLogoLarge.css("opacity", "1");

        siteHeaderShow();
      } else {
        $siteHeader.addClass("site-header--lg").transitionEnd(function() {
          siteHeaderShow();
        });

        if (windowScrollTop == 0) {
          $siteLogo.parent("a").css("pointer-events", "auto");
          $siteLogoLarge.css("opacity", "1");

          $sitePhone.parent("a").css("pointer-events", "auto");
          $sitePhone.css("opacity", "1");
        } else {
          $siteLogo.parent("a").css("pointer-events", "none");
          $siteLogoLarge.css("opacity", "0");

          $sitePhone.parent("a").css("pointer-events", "none");
          $sitePhone.css("opacity", "0");
        }
      }
    } else {
      siteHeaderShow();
    }
  }
}

var windowScrollTop = $(window).scrollTop();

$(window)
  .load(function() {
    siteHeaderInit();
  })
  .smartresize(function() {
    windowScrollTop = $(window).scrollTop();
    siteHeaderInit();
  })
  .scroll(function() {
    windowScrollTop = $(window).scrollTop();
    siteHeaderInit();
  });

$(".is-dropdown").hover(function() {
  $dropdown.find("> ul").css("width", $dropdown.find("> ul").outerWidth());
  $dropdown
    .find("> ul > li > ul")
    .css("left", $dropdown.find("> ul").outerWidth());
  $dropdown.find("> ul");
});

$(".is-dropdown ul > li").hover(
  function() {
    $dropdown.css(
      "width",
      $dropdown.find("> ul").outerWidth() +
        $dropdown.find("> ul > li > ul").outerWidth()
    );
    $(this).addClass("is-active");
  },
  function() {
    $dropdown.css("width", "auto");
    $(this).removeClass("is-active");
  }
);

$(".mobile-menu span.arrow").click(function() {
  $(this)
    .find("span")
    .css({
      top: $(this)
        .find("span")
        .css("top")
    })
    .toggleClass("is-active");
  $(this)
    .siblings("ul")
    .toggleClass("is-active");
});
