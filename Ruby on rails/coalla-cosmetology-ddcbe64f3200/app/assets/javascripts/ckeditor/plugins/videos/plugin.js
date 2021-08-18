'use strict';

( function() {

    CKEDITOR.plugins.add( 'videos', {

        // The plugin initialization logic goes inside this method.
        init: function( editor ) {

            // Define an editor command that opens our dialog window.
            editor.addCommand( 'videos', new CKEDITOR.dialogCommand( 'videosDialog' ) );

            // Create a toolbar button that executes the above command.
            editor.ui.addButton( 'Videos', {

                // The text part of the button (if available) and the tooltip.
                label: 'Добавить видео',

                // The command to execute on click.
                command: 'videos',

                // The button placement in the toolbar (toolbar group name).
                toolbar: 'insert',

                icon: '/assets/ckeditor/video.png'
            });

            // Register our dialog file -- this.path is the plugin folder path.
            CKEDITOR.dialog.add( 'videosDialog', this.path + 'dialogs/videos.js' );
        }
    });
} )();

