//= require ckeditor/init
CKEDITOR.config.skin = 'bootstrapck';
CKEDITOR.config.extraPlugins = 'mediaembed,videos';
CKEDITOR.config.removeButtons = 'About,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,BidiLtr,BidiRtl,Language,Scayt,Smiley,SpellChecker,Templates,Indent,CreateDiv,HorizontalRule,NewPage,Flash,PageBreak,Styles,FontSize,Font,TextColor,BGColor,JustifyLeft,JustifyCenter,JustifyRight,JustifyBlock,Save,Preview,Print,Find,Replace,SelectAll,Iframe,ShowBlocks,Maximize';
CKEDITOR.config.removePlugins = 'scayt,smiley,elementspath,resize';
CKEDITOR.config.width = '100%';
CKEDITOR.config.height = '362px';
CKEDITOR.config.language = 'ru';
CKEDITOR.config.allowedContent = true;

CKEDITOR.on( 'dialogDefinition', function( ev ) {
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;

    if ( dialogName == 'table' ) {
        var infoTab = dialogDefinition.getContents( 'info' );

        infoTab.get('txtWidth')[ 'default' ] = '';
        infoTab.get('txtCellPad')[ 'default' ] = '';
        infoTab.get('txtCellSpace')[ 'default' ] = '';
        infoTab.get('txtBorder')[ 'default' ] = '';
        infoTab.get('selHeaders')['default'] = 'row';
    }
});