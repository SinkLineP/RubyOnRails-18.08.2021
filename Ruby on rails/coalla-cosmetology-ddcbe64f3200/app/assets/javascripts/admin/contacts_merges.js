$(function () {
    initDatepicker();

    $('.js-student-autocomplete').each(function () {
        var $el = $(this);
        $el.autocomplete({
            minLength: 0,
            source: Routes.list_admin_students_path(),
            appendTo: $el.closest('.js-autocomplete-input').find('.autocomplete_variants'),
            open: function () {
                $(this).addClass('open')
            },
            select: function (e, ui) {
                var $input = $(this),
                    $id = $(this).closest('.js-autocomplete-input').find('input:hidden');

                if (!ui.item) {
                    $input.val('');
                    $id.val('');
                    updateTargetValues();
                    return;
                }

                $id.val(ui.item.id);
                $input.closest('.js-autocomplete-input').parent().find('.js-student-info').html(ui.item.html);
                $('.js-form').customForm();

                updateTargetValues();
            }
        }).focus(function () {
            var $input = $(this);
            $input.autocomplete("search", $input.val());
        });
    });

    $(document).on('change', '[data-source-field]', function () {
        var $this = $(this),
            $otherInputs = $('[data-source-field="' + $this.data('source-field') + '"]').not(this);

        $otherInputs.removeAttr('checked');
        $otherInputs.closest('.form_el').attr('data-checked', false);

        $this.closest('.form_el').attr('data-checked', true);
        $this.attr('checked', 'checked');

        updateTargetValues();
    });

    function updateTargetValues() {
        $('[data-source-field]:checked').each(function () {
            var $sourceField = $(this);

            if ($sourceField.data('group')) {
                var fieldValues = $sourceField.data('fields-values');

                if (!fieldValues) {
                    return;
                }

                _.each(fieldValues, function (fieldValue, fieldName) {
                    var $targetField = $('[data-target-field="' + fieldName + '"]');
                    $targetField.val(fieldValue);
                    $targetField.change();
                });

                return;
            }

            var fieldName = $sourceField.data('source-field'),
                $targetField = $('[data-target-field="' + fieldName + '"]');

            $targetField.val($sourceField.val());
            $targetField.change();
        });
    }
});
