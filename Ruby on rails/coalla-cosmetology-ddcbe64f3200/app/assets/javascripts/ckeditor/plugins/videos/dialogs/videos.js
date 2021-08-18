CKEDITOR.dialog.add('videosDialog', function (editor) {
    return {

        // Basic properties of the dialog window: title, minimum size.
        title: 'Видео',
        minWidth: 400,
        minHeight: 100,

        // Dialog window content definition.
        contents: [
            {
                id: "videosSettings",
                elements: [
                    {
                        type: 'text',
                        id: 'title',
                        className: 'js-videos-autocomplete',
                        label: 'Введите наименование видео:',
                        'default': ''
                    }

                ]
            }
        ],
        onShow: function () {
            var $autocompleteInput = $('.js-videos-autocomplete').find('input');

            $autocompleteInput.data('id', null);

            $(".cke_dialog").mousedown(function () {
                $autocompleteInput.autocomplete("close");
            });

            $autocompleteInput.autocomplete({
                source: Routes.list_admin_uploaded_videos_path(),
                minLength: 0,
                select: function (e, ui) {
                    $autocompleteInput.data('id', ui.item.id);
                    $autocompleteInput.data('name', ui.item.label);
                    $autocompleteInput.data('image_url', ui.item.imageUrl);
                    $autocompleteInput.data('type', ui.item.type);
                },
                messages: {
                    noResults: '',
                    results: function () {
                    }
                }
            }).focus(function(){
                $(this).autocomplete('search', $(this).val());
            });

            $autocompleteInput.autocomplete('widget').css('z-index', 10011);

        },
        onOk: function () {
            var $autocompleteInput = $('.js-videos-autocomplete').find('input'),
                id = $autocompleteInput.data('id'),
                name = $autocompleteInput.data('name'),
                imageUrl = $autocompleteInput.data('image_url'),
                type = $autocompleteInput.data('type');

            if (id) {
                var html;
                if (imageUrl) {
                    html = '<img style="display: block; max-width: 300px; height: auto"' + ' src=' + imageUrl + ' /><div style="margin-top: 10px; font-weight: 700;">' + name+ '</div>';
                } else {
                    html = name;
                }
                editor.insertHtml('<div class="js-videos-pin" data-type=' + type + ' data-id=' + id + ' style="display: block; margin: 20px 0"><div style="display: inline-block; padding: 10px; border: 1px solid #dddddd;">' + html + '</div></div>');
            }

            $autocompleteInput.autocomplete("destroy");
            $autocompleteInput.removeData("autocomplete");

        },
        onClose: function () {
            this.hide();
        }
    };
});