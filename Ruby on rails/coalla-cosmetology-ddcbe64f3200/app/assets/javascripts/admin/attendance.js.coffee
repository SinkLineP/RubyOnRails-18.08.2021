#= require ./base_form
window.AttendanceReportForm = Views.BaseForm.extend
  el: '#attendance_report_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    @.$el.customForm();
    initDatepicker()

    intializedAutocomplete = @.$el.find('.js-users-autocomplete').autocomplete
      minLength: 0
      source: Routes.admin_search_users_path()
      appendTo: $('.autocomplete_variants')
      open: ->
        $(this).addClass 'open'
      select: (e, ui) ->
        $input = $(this)
        $id = $(this).parent().find('input:hidden')
        if !ui.item
          $input.val('')
          $id.val('')
          return
        $id.val(ui.item.id)

    intializedAutocomplete.focus ->
      $input = $(this)
      $input.autocomplete('search', $input.val())