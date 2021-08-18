define(['jquery'], function ($) {

    var Controls = function (widget) {
        this.widget = widget;
    };

    Controls.prototype.select = function ($hiddenInput, options) {
        $hiddenInput.attr('readonly', 'readonly');

        var selectOptions = $.extend({
                id: options.id,
                items: options.items
            },
            {
                selected: $hiddenInput.val()
            });

        var selectHtml = this.widget.render(
            {ref: '/tmpl/controls/select.twig'},
            selectOptions);

        var html = '<div class="linked-form__field linked-form__field-select">' +
            '<div class="linked-form__field__label">' +
            '<span>' +
            options.label +
            '</span>' +
            '</div>' +
            '<div class="linked-form__field__value">' +
            selectHtml +
            '</div>' +
            '</div>';

        var $select = $('#' + options.id);

        if ($select.length > 0) {
            $select.closest('.linked-form__field').replaceWith(html);
        } else {
            $hiddenInput.closest('.linked-form__field').before(html);
        }

        $('#' + options.id).change(function () {
            $hiddenInput.val($(this).val());
            $hiddenInput.change();
        });
    };

    Controls.prototype.selectOptionsFromJson = function (json, idMethod, optionMethod) {
        var idMethod = typeof idMethod !== 'undefined' ? idMethod : 'id',
            optionMethod = typeof optionMethod !== 'undefined' ? optionMethod : 'title';

        return [{option: '---', id: ''}].concat(
            _.map(json, function (item) {
                return {
                    option: item[optionMethod],
                    id: item[idMethod]
                }
            })
        );
    };

    Controls.prototype.fileLink = function (object) {
        var html = '<div class="linked-form__field">' +
            '<div>' +
            '<a href="' + this.widget.get_settings().api_host + 'private_files/load?file=' + object.file + '&token=' + this.widget.get_settings().api_key + '" target="_blank">' + object.fileName + '</a>' +
            '</div>' +
            '</div>';

        $('#edit_card').find('.linked-form__field:last').after(html);
    };

    Controls.prototype.documentLink = function ($block, document) {
        var html = '<div class="linked-form__field">' +
            '<div>' +
            '<a href="' + this.widget.get_settings().api_host + 'documents/' + document.id + '/load?token=' + this.widget.get_settings().api_key + '" target="_blank">' + document.title + '</a>' +
            '<span>&nbsp;</span>' +
            (document.file ?
            '<a href="' + this.widget.get_settings().api_host + 'private_files/load?file=' + document.file + '&token=' + this.widget.get_settings().api_key + '" target="_blank">Копия</a>'
                : '') +
            '</div>' +
            '</div>';

        $block.after(html);
    };

    Controls.prototype.leadLink = function ($block, subscription) {
        var html = '<div class="linked-form__field">' +
            '<div>' +
            '<a href="/leads/detail/' + subscription.amocrmId + '" target="_blank">' + subscription.title + '</a>' +
            '</div>' +
            '</div>';

        $block.after(html);
    };

    return Controls;
});
