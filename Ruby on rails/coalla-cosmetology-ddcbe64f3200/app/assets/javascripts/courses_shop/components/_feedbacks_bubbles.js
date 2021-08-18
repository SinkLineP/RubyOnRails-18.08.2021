var $feedbacksBubblesSlider = $('#feedbacks-bubbles-slider');

function feedbacksBubblesSliderInit() {


    $('.is-vimeo a').each(function () {

        var videoURL = $(this).attr('href');

        var str = videoURL;
        var arr = str.split('/');
        var videoID = arr[arr.length - 1];

        $.getJSON('http://vimeo.com/api/v2/video/' + videoID + '.json', function(data){

            $('.is-vimeo img').attr('src' , data[0].thumbnail_large);

        });
    });



    if ($feedbacksBubblesSlider.length) {
        $('#feedbacks-bubbles-slider-prev').on('click', function () {
            $feedbacksBubblesSlider.slick('slickPrev');

            return false;
        });

        $('#feedbacks-bubbles-slider-next').on('click', function () {

            $feedbacksBubblesSlider.slick('slickNext');

            return false;
        });

        $feedbacksBubblesSlider.slick({
            arrows: false,
            cssEase: 'linear',
            draggable: false,
            fade: true,
            infinite: true
        });
    }
}

$(window).load(function() {
    feedbacksBubblesSliderInit();
});