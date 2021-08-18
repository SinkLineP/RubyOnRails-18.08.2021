var Popups = function () {
    var mfpPopupDefaultOptions = {
        preloader: false,
        showCloseBtn: false,
        autoFocusLast: false,
        removalDelay: BASE_TRANSITION_DURATION,
        callbacks: {
            open: mfpPopupOpenCallback,
            close: mfpPopupCloseCallback,
            ajaxContentAdded: mfpPopupAjaxContentAddedCallback
        }
    };

    function mfpPopupOpenCallback() {
        $('body').addClass('is-clipped');

        $('.js-select').select2('close'); // Close select2 dropdown to prevent wrong repositioning
        setSelect2ContainerProperWidth();

        $('#site-header').css('right', this.scrollbarSize + 'px');
        $('.js-page-next').css('display', 'none');

        if (Modernizr.mq(BREAKPOINT_MOBILE)) {
            $('#site-footer').css('visibility', 'hidden');
        }

        if (Modernizr.mq(BREAKPOINT_DESKTOP)) {
            if (this.currItem && (this.currItem.type === 'inline' || this.currItem.type === 'ajax')) {
                $(this.contentContainer).css('width', 'auto');
            }
        }

        // Init jwPlayer if exists

        var $jwPlayerDiv = $('#jw_player_popup');
        if ($jwPlayerDiv.length > 0 && this.st.el) {
            var $contentVideo = $jwPlayerDiv.closest('.content__video');

            if (this.st.el.attr('data-player-options')) {
                $contentVideo.empty().append('<div class="jw_player" id="jw_player_popup" data-options=' + this.st.el.attr('data-player-options') + '></div>');
                initPlayer($('#jw_player_popup'));
            } else if(this.st.el.attr('data-script')){
                jwplayer.key = "yBOok1Qnh5M3wQJ1lAA2dPlwQIkB/3WEH4470nE8m4E=";
            }
        }
    }

    function mfpPopupCloseCallback() {
        $('body').removeClass('is-clipped');

        $('#site-header').css('right', '');
        $('.js-page-next').css('display', '');

        if (Modernizr.mq(BREAKPOINT_MOBILE)) {
            $('#site-footer').css('visibility', 'visible');
        }

        if (Modernizr.mq(BREAKPOINT_DESKTOP)) {
            if (this.currItem.type === 'inline' || this.currItem.type === 'ajax') {
                $(this.contentContainer).css('width', '');
            }
        }

        if ($.magnificPopup.instance.content.data('location')) {
            window.location = $.magnificPopup.instance.content.data('location');
        }

        var blogPopupId = $.magnificPopup.instance.content.data('blog-popup-id');
        if (blogPopupId) {
            var blogPopupIds = $.cookie('blog_popup_ids');
            if (typeof blogPopupIds === 'undefined')
                blogPopupIds = [];
            else
                blogPopupIds = blogPopupIds.split(',');
            if (!blogPopupIds.includes(blogPopupId)) {
                blogPopupIds.push(blogPopupId);
                $.cookie('blog_popup_ids', blogPopupIds, {expires: 1 / 24});
            }
        }
    }

    function mfpPopupAjaxContentAddedCallback() {
        select2Init();
        setSelect2ContainerProperWidth();
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
        $(document).on('click', '.js-mail-button', function () {
            mfpPopupCloseCurrent();

            return false;
        });

        $(document).on('click', '[data-mfp-action="close"]', function () {
            mfpPopupCloseCurrent();

            return false;
        });

        // Content: content
        $('[data-mfp-type="inline"]').magnificPopup(popupOptions(
            {
                disableOn: 0,
                mainClass: 'mfp-fade',
                type: 'inline'
            }
        ));

        // Content: video
        $('[data-mfp-type="iframe"]').magnificPopup(popupOptions(
            {
                disableOn: BREAKPOINT_MOBILE_INT - scrollSize().width, // Somehow, Magnific Popup counts breakpoint with scrollbar size
                mainClass: 'mfp-fade mfp-dark',
                type: 'iframe',
                iframe: {
                    patterns: {
                        youtube: {
                            index: 'https://youtu.be/',
                            id: 'https://youtu.be/',
                            src: '//www.youtube.com/embed/%id%'
                        }
                    }
                }
            }
        ));

        // Content: jwPlayer video
        $('[data-mfp-type="jwplayer"]').magnificPopup(popupOptions(
            {
                disableOn: 0,
                mainClass: 'mfp-fade mfp-dark',
                type: 'inline'
            }
        ));

        // Content: image
        $('[data-mfp-type="image"]').magnificPopup(popupOptions(
            {
                disableOn: BREAKPOINT_MOBILE_INT - scrollSize().width, // Somehow, Magnific Popup counts breakpoint with scrollbar size
                mainClass: 'mfp-fade mfp-dark',
                type: 'image'
            }
        ));

        // Content: ajax
        $('[data-mfp-type="ajax"]').magnificPopup(popupOptions(
            {
                disableOn: 0,
                type: 'ajax'
            }
        ));

        // Content: gallery
        $('.js-images-gallery').each(function () {
            $(this).magnificPopup(popupOptions(
                {
                    delegate: 'a',
                    disableOn: BREAKPOINT_MOBILE_INT - scrollSize().width, // Somehow, Magnific Popup counts breakpoint with scrollbar size
                    mainClass: 'mfp-fade mfp-dark',
                    type: 'image',
                    gallery: {
                        arrowMarkup: '<button title="%title%" type="button" class="mfp-arrow-custom mfp-arrow-custom--%dir%"><svg class="icon" role="img" data-size="18"><use xlink:href="/assets/courses_shop/icons.svg#arrow-left"></use></svg></button>',
                        enabled: true,
                        navigateByImgClick: true,
                        preload: [0, 1], // Will preload 0 - before current, and 1 after the current image
                        tCounter: '',
                        tPrev: 'Предыдущее изображение',
                        tNext: 'Следующее изображение'
                    }
                }
            ));
        });
    };

    this.mfpShowContent = function (popupContent, popupName) {
        var $el = $(popupName);
        if ($el.length) {
            $el.replaceWith(popupContent);
        } else {
            $('body').append(popupContent);
        }

        var options = popupOptions({
            items: {
                src: popupName
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
    };

    this.mfpShowInfo = function (title, text, popupName, link) {
        if (popupName === undefined) {
            popupName = '#popup-info';
        }

        if (link === undefined) {
            link = '#';
        }

        var $el = $(popupName);
        if ($el.length) {

            $el.find('[data-popup-title]').html(title);
            $el.find('[data-popup-text]').html(text);
            $el.find('.js-link-ok').attr('href', link);
            $el.find('.js-url-field').val(link);

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

    this.mfpOpenPopup = function (name, link) {
        var $el = $(name);
        if ($el.length) {
            $el.find('.js-link-button').attr('href', link);

            var options = popupOptions({
                items: {
                    src: $el
                },
                type: 'inline'
            });

            mfpPopupCloseCurrent();

            // workaround for close/open
            setTimeout(function () {
                $.magnificPopup.instance = null;
                $.magnificPopup.open(options);
            }, 300);
        }
    }
};

var popups = new Popups();
popups.initializeEvents();