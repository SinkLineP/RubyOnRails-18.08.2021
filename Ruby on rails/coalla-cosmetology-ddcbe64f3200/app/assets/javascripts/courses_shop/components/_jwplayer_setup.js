jwplayer.key = "yBOok1Qnh5M3wQJ1lAA2dPlwQIkB/3WEH4470nE8m4E=";

function initPlayer($el) {
    var id = $el.attr('id'),
        options = $el.data('options'),
        player = jwplayer(id);

    player.setup(options);
}

$(function () {
    $('.jw-player-item').each(function () {
        initPlayer($(this));
    });

    var $player = $('#jw_player');
    if ($player.length > 0) {
        initPlayer($player);
    }

});