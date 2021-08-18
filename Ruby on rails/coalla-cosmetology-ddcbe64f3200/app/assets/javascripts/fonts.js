$(function() {
    var fontPTSans = new FontFaceObserver('PT Sans');
    var fontPTSerif = new FontFaceObserver('PT Serif');
    var fontPTSansCaption = new FontFaceObserver('PT Sans Caption');

    var fontFontAwesome = new FontFaceObserver('FontAwesome');

    fontPTSans.load();
    fontPTSerif.load();
    fontPTSansCaption.load();

    fontFontAwesome.load();
});
