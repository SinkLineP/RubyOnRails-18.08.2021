var $accordion = $('.js-accordion');

// Direct children for nested accordions
$accordion.find('div.dl[data-state] > div.dt').on('click', function() {
    var $dl = $(this).closest('div.dl');

    if ($dl.attr('data-state') == 'collapsed') {
        $dl.find('> div.dd').stop(0).slideDown(SLIDE_TOGGLE_DURATION / 2, function() {
            $dl.attr('data-state', 'expanded');
        });
    } else {
        $dl.find('> div.dd').stop(0).slideUp(SLIDE_TOGGLE_DURATION / 2, function() {
            $dl.attr('data-state', 'collapsed');
        });
    }

    return false;
});

// For images slider reinit on showing accordion item
$accordion.find('div.dl[data-state="collapsed"] > div.dt.js-images-slider-init').one('click', function() {
    setTimeout(function() {
        $('.js-images-slider-list').slick('unslick');
        imagesSliderInit();
    }, SLIDE_TOGGLE_DURATION / 2);

    return false;
});

// For teachers slider reinit on showing accordion item
$accordion.find('div.dl[data-state="collapsed"] > div.dt.js-teachers-items-slider-init').one('click', function() {
    setTimeout(function() {
        $teachersItemsSlider.slick('unslick');
        teachersItemsSliderInit();
    }, SLIDE_TOGGLE_DURATION / 2);

    return false;
});

$(window).load(function() {
	var block, hash, offset_top;
	hash = $(location).attr('hash');
	if (hash.length > 0) {
		block = $(hash);
		var timer = setInterval(function() {
			offset_top = block.offset().top
			console.log(offset_top)
			if(offset_top > 0){
				$('html, body').animate({
					scrollTop: offset_top - 71
				}, 500);
				block.find('> dd').stop(0).slideUp(SLIDE_TOGGLE_DURATION / 2, function() {
					block.attr('data-state', 'expanded');
				});
				clearInterval(timer);
			}
		}, 1000);
	}
});