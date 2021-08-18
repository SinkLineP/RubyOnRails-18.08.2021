function resizePageWithSidebar() {
    var $page = $('#page'),
        $main = $page.find('.main'),
        $columns = $main.children('.grid').children('.grid_i'),
        minHeight = $(window).outerHeight() - $('#header').outerHeight() - $('#footer').outerHeight(),
        maxHeight = $columns.maxHeight();

    if ($page.hasClass('with_sidebar')) {
        if (maxHeight > minHeight) {
            $columns.css('min-height', maxHeight + 'px');
        } else {
            $columns.css('min-height', minHeight + 'px');
        }
    }
}

function resizeBlockName() {
    var $blockName = $('.js-block-name'),
        $blockNameText = $blockName.find('.js-block-name-text'),
        blockNameHeight = $blockName.outerHeight(),
        blockNameTextLineHeight = parseInt($blockNameText.css('line-height'));

    if ((blockNameHeight % blockNameTextLineHeight) != 0) {
        $blockName.find('.js-social-links').addClass('social_links__h--not-center');
    }
}


//****************************************************************************************************
//
// .. READY
//
//****************************************************************************************************
$(function () {
    var BOOKS_PER_SLIDER = 5;

    // Slider
    $('.slider').owlCarousel({
        nav: true,
        items: 1,
        navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>'],
        loop: true,
        smartSpeed: 600,
        mouseDrag: false
    });

    // Library slider
    $('.slider_book-js').owlCarousel({
        nav: true,
        items: BOOKS_PER_SLIDER,
        navText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>'],
        loop: true,
        mouseDrag: false,
        dots: false
    });

    var bookSliders = $('.js-books-slider');
    bookSliders.each(function (_, book) {
        $book = $(book);
        if ($book.find('.js-item').length <= BOOKS_PER_SLIDER) {
            $book.find('.owl-controls').hide();
        }
    });

    // Dashborad sidebar
    $('.nav_block').not('.disabled').children('.block_name')
        .on('click', function () {
            var lections = $(this).siblings('.lections_list');
            var parent = $(this).parent();

            parent.siblings('.nav_block.open')
                .removeClass('open')
                .children('.lections_list')
                .animate({height: 'toggle'});

            if (parent.hasClass('open')) {
                lections.animate({height: 'toggle'});
            } else {
                lections.animate({height: 'toggle'});
            }
            parent.toggleClass('open')
        });

    // Password show
    $('.js-show_pass').on("mousedown", function () {
        $(this)
            .parents('.form')
            .find("[data-type=password]")
            .attr("type", "text");
        $('.fa-eye-slash').removeClass('fa-eye-slash').addClass('fa-eye')
    }).on("mouseup", function () {
        $(this)
            .parents('.form')
            .find("[data-type=password]")
            .attr("type", "password");
        $('.fa-eye').removeClass('fa-eye').addClass('fa-eye-slash')
    });

    // Table select
    $('.can_select').find('.point__voice').on('click', function () {
        $(this).toggleClass('js-checked')
    });

    // Modal
    $('.modal').on('click', function () {
        var modalOptions = {
            closeOnOverlayClick: false,
            overlay: {
                css: {
                    backgroundColor: '#000',
                    opacity: .3
                }
            }
        };

        if ($(this).data('url')) {
            modalOptions.url = $(this).data('url');
            modalOptions.type = 'ajax';
            $.arcticmodal(modalOptions);

        } else {
            var target = $(this).data('modal');
            $('#' + target).arcticmodal(modalOptions);
        }
    });

    $('.popup_close').on('click', function () {
        $(this).parent().fadeOut();
    });

    // Selectordie
    $('.selectordie').selectOrDie();
    //****************************************************************************************************
    //
    // .. SCROLL
    //
    //****************************************************************************************************
    $(window).scroll(function () {
    });


    //****************************************************************************************************
    //
    // .. RESIZE
    //
    //****************************************************************************************************
    $(window).smartresize(function () {
        resizePageWithSidebar();
    });

    //****************************************************************************************************
    //
    // .. SOCIAL LINKS
    //
    //****************************************************************************************************
    $('.social_links-a').click(function () {
        var $this = $(this),
            social = $this.data('target');

        $this.parent().find('.social-likes > .social-likes__widget_' + social).trigger('click');
        return false;
    });

    //****************************************************************************************************
    //
    // .. TOKENINPUT
    //
    //****************************************************************************************************
    $('[data-multi-field]').each(function () {
        var options = {
            crossDomain: false,
            preventDuplicates: true,
            hintText: 'Введите строку для поиска',
            noResultsText: 'Ничего не найдено',
            searchingText: 'Поиск...',
            theme: 'facebook',
            showAllOnFocus: $(this).data('show-all-on-focus'),
            useCache: $(this).data('use-cache'),
            onAdd: function (item) {
                if (item.html != undefined) {
                    $('.results').append(item.html);
                }
            },
            onDelete: function (item) {
                if (item.html != undefined) {
                    $('.results').find('#' + item.id).remove();
                }
            }
        };

        var objectUrlName = $(this).data('object-url-name');
        if (objectUrlName) {
            var formatter_options = {
                tokenFormatter: function (item) {
                    return "<li><p>" + item[this.propertyToSearch] + "</p></li>"
                }
            };
            options = $.extend(options, formatter_options);
        }

        $(this).tokenInput($(this).data('source'), options);
    });
});


//****************************************************************************************************
//
// .. LOAD
//
//****************************************************************************************************
$(window).load(function () {
    resizePageWithSidebar();
    resizeBlockName();
});

//****************************************************************************************************
//
// .. DATEPICKER
//
//****************************************************************************************************
function initDatepicker($selector) {
    if ($selector == undefined) {
        $selector = $('.js-datepicker');
    }

    $selector.datepicker({
        dateFormat: "dd.mm.yy",
        showAnim: 'fadeIn',
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true
    });
};

//****************************************************************************************************
//
// .. AUTOCOMPLETE
//
//****************************************************************************************************
function initBankAutocomplete() {
    $('.js-bic').change(function () {
        var bic = $(this).val();

        if (bic.length == 0) {
            return;
        }

        $.get(Routes.admin_search_bank_path(), {bic: bic}, function (responce) {
            if (responce.bank) {
                $('.js-bank').val(escapeHtml(responce.bank.name));
                $('.js-ca').val(responce.bank.ks);
            }
        });
    })
}


function escapeHtml(unsafe) {
    if (unsafe) {
        return unsafe
            .replace(/&amp;/g, "")
            .replace(/&lt;/g, "<")
            .replace(/&gt;/g, ">")
            .replace(/&quot;/g, '"')
            .replace(/&#039;/g, "'");
    } else {
        return '';
    }
}

function initFileUpload() {
    $('.js-user-file').fileupload(
        {
            url: Routes.admin_private_file_path(),
            dataType: 'json',
            type: 'POST',
            paramName: 'file',
            formData: {},
            replaceFileInput: false,
            done: function (e, data) {
                if (data.result.error) {
                    alert(data.result.error);
                    return;
                }

                var $userFile = $(this).closest('.form_file');
                $userFile.find('[data-file-cache]').val(data.result.cache);
                $userFile.find('.form_file_inner').text(data.result.filename);
            }
        });
}