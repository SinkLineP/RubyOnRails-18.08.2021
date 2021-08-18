$(function () {
    $('.fotorama').on('fotorama:showend', function (e, fotorama) {
        $(this).closest('.grid_i').find('.tx-center').html('Страница ' + (fotorama.activeIndex + 1) + ' из ' + fotorama.size);
    });

    $('.fotorama').on('fotorama:fullscreenexit', function (e, fotorama) {
        $(this).closest('.grid_i').find('.tx-center').html('Страница ' + (fotorama.activeIndex + 1) + ' из ' + fotorama.size);
    });
});
