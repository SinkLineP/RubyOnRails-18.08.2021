var $tabs = $('#tabs');
var hash = document.location.hash;

function tabsToggle(id) {
    // Toggle active state
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        // Setting neccessary option:selected if loading first time
        if (!$tabs.find('select').next('.select2-container').length) {
            $tabs.find('option').removeAttr('selected');
            $tabs.find('option[data-href="' + id + '"]').attr('selected', 'selected');
        }
    } else {
        $tabs.find('a').removeClass('is-active');
        $tabs.find('a[href="' + id + '"]').addClass('is-active');
    }

    // Toggle tab visibility
    $('.js-tab').not('[data-id="' + id + '"]').fadeOut(BASE_TRANSITION_DURATION);

    // Load tab content via AJAX and call the code below on success:
    $('.js-tab[data-id="' + id + '"]').fadeIn(BASE_TRANSITION_DURATION, function () {
        contentFigureWidth();
    });

    // Setting actual hash of current tab
    document.location.hash = id;
}

if ($tabs.length) {
    // Checking if hash exists
    if (hash) {
        tabsToggle(hash);
    } else {
        tabsToggle($('.js-tab:first-of-type').data('id'));
    }

    // Checking if pushstate changed
    window.onpopstate = function () {
        tabsToggle(document.location.hash);
    };

    // Events for select or link
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        $tabs
            .find('select')
            .on('change', function () {
                tabsToggle($(this).find('option:selected').data('href'));

                return false;
            });
    } else {
        $tabs
            .find('a')
            .on('click', function () {
                tabsToggle($(this).attr('href'));

                return false;
            });
    }
}

$(function () {
    $('.js-buiseness-menu, .js-about-menu, .js-profile-menu').change(function () {
        window.location.href = $(this).val();
    });
});