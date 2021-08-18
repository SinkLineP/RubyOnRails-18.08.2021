var Popups = function () {
    var mfpPopupDefaultOptions = {
        preloader: false,
        showCloseBtn: false,
        autoFocusLast: false,
        removalDelay: BASE_TRANSITION_DURATION,
        callbacks: {
            open: mfpPopupOpenCallback,
            close: mfpPopupCloseCallback
        }
    };

    function mfpPopupOpenCallback() {
        $('body').addClass('is-clipped');

        $('#site-header').css('right', this.scrollbarSize + 'px');
        $('.js-page-next').css('display', 'none');
    }

    function mfpPopupCloseCallback() {
        $('body').removeClass('is-clipped');

        $('#site-header').css('right', '');
        $('.js-page-next').css('display', '');

        if ($.magnificPopup.instance.content.data('location')) {
            window.location = $.magnificPopup.instance.content.data('location');
        }
    }

    function mfpPopupCloseCurrent() {
        $.magnificPopup.close();
    }

    function popupOptions(customOptions) {
        var result = {};
        $.extend(result, mfpPopupDefaultOptions, customOptions);
        return result;
    }

    this.initializeEvents = function () {

        // Content: content
        $('[data-mfp-type="inline"]').magnificPopup(popupOptions(
            {
                disableOn: 0,
                mainClass: 'mfp-fade',
                type: 'inline'
            }
        ));

        // Content: ajax
        $('[data-mfp-type="ajax"]').magnificPopup(popupOptions(
            {
                disableOn: 0,
                type: 'ajax'
            }
        ));

    };


    this.mfpShowInfo = function (title) {
        var $el = $('#success-popup');
        if ($el.length) {

            $el.find('.popup__title').text(title);

            var options = popupOptions({
                items: {
                    src: $el
                },
                mainClass: 'mfp-fade',
                type: 'inline'
            });

            mfpPopupCloseCurrent();

            // workaround for close/open
            setTimeout(function () {
                $.magnificPopup.instance = null;
                $.magnificPopup.open(options);
            }, 300);
        }
    };
};

var popups = new Popups();
popups.initializeEvents();