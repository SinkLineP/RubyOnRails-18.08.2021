$(function() {
    var $partnersSlider = $('#partners-slider');

    $partnersSlider.slick({
        arrows: true,
        prevArrow: '<button class="slick-prev slick-arrow" aria-label="Previous" type="button"><svg style="width: 24px; height: 24px;" viewBox="0 0 24 24"><path fill="#2a323a" stroke="#2a323a" stroke-width="2" d="M15.41,16.58L10.83,12L15.41,7.41L14,6L8,12L14,18L15.41,16.58Z"/></svg></button>',
        nextArrow: '<button class="slick-next slick-arrow" aria-label="Next" type="button"><svg style="width: 24px; height: 24px;" viewBox="0 0 24 24"><path fill="#2a323a" stroke="#2a323a" stroke-width="2" d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z"/></svg></button>',
        dots: false,
        draggable: false,
        slidesToShow: 5,
        slidesToScroll: 5,
        responsive: [
            {
                breakpoint: 1280,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 4
                }
            },
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3
                }
            },
            {
                breakpoint: 768,
                settings: {
                    arrows: false,
                    dots: true,
                    slidesToShow: 2,
                    slidesToScroll: 2
                }
            }
        ]
    });
});