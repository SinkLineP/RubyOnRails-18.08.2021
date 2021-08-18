var $historyCardsSlider = $('#history-cards-slider');

function historyCardsSliderInit() {
    if ($historyCardsSlider.length) {
        $('#history-cards-slider-prev').on('click', function () {
            $historyCardsSlider.slick('slickPrev');

            return false;
        });

        $('#history-cards-slider-next').on('click', function () {
            $historyCardsSlider.slick('slickNext');

            return false;
        });

        $historyCardsSlider.slick({
            arrows: false,
            cssEase: 'linear',
            draggable: false,
            fade: true,
            infinite: true
        });
    }
}

$(window).load(function() {
    historyCardsSliderInit();
});