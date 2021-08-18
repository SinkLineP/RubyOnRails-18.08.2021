var $siteFooter = $("#site-footer");

function siteFooterInit() {
  if ($siteFooter.length) {
    $("#main").css("padding-bottom", $siteFooter.outerHeight());

    $siteFooter.css({
      opacity: 1,
      visibility: "visible"
    });
  }
}

$(window)
  .load(function() {
    siteFooterInit();
  })
  .smartresize(function() {
    siteFooterInit();
  });

$(document).ready(function() {
  var scrollTop = $("#return-to-top");
  var topPos = $(this).scrollTop();
  var banner = $(".js-banner-call");
  var banner_height = banner.height() + 5;
  if (topPos > 200) {
    $(scrollTop).css({"opacity": "1", "display": "block"});
  } 
  if (!getParameterByName('banner') && banner.length){
    $(scrollTop).css("bottom", banner_height)
  }
  $(window).scroll(function() {
    topPos = $(this).scrollTop();
    if (topPos > 200) {
      $(scrollTop).css({"opacity": "1", "display": "block"});
    } else {
      $(scrollTop).css({"opacity": "0", "display": "none"});
    }
  });

  $(scrollTop).click(function() {
    $('html, body').animate({
      scrollTop: 0
    }, 800);
    return false;
  }); 

  $(".js-banner-call .banner__close").click(function(){
    $(scrollTop).css("bottom", "70px")
  });
});
