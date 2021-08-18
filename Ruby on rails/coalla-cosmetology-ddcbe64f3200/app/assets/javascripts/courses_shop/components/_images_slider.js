var $imagesSlider = $('.js-images-slider');

function imagesSliderInit() {
    if ($imagesSlider.length) {
        $imagesSlider.each(function() {
            var $this = $(this);
            var $imagesSliderList = $this.find('.js-images-slider-list');

            $this.find('.js-images-slider-prev').on('click', function () {
                $imagesSliderList.slick('slickPrev');

                return false;
            });

            $this.find('.js-images-slider-next').on('click', function () {
                $imagesSliderList.slick('slickNext');

                return false;
            });

            $imagesSliderList.slick({
                arrows: false,
                cssEase: 'linear',
                draggable: false,
                fade: true,
                infinite: true
            });
        });
    }
}

$(window).load(function() {
    imagesSliderInit();
});