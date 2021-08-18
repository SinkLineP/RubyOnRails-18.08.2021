$ ->
  GroupSubscriptionForm = Backbone.View.extend
    el: '#group_subscription_form'

    events:
      'change .js-group-select': 'onGroupSelect'
      'change .js-education-form-select': 'loadGroupPrices'
      'cocoon:after-insert .js-subscription-stages': 'insertFields'
      'cocoon:after-insert .js-subscription-documents': 'insertFields'
      'cocoon:after-insert .js-payments': 'insertFields'
      'click .js-recalculate-payments': 'recalculatePayments'
      'click .js-generate-documents': 'generateDocuments'
      'change .js-practice': 'showPracticeBasis'

    initialize: ->
      @.initDatePicker(@.$el)

    onGroupSelect: (e)->
      @.loadGroupInfo()
      @.loadGroupPrices()

    loadGroupInfo: ()->
      id = $('.js-group-select').val()

      $.get Routes.info_admin_group_path(id), (responce)->
        _.each ['course_name', 'start_time', 'end_time'], (field)->
          $("[data-#{field.replace('_', '-')}]").text(responce[field])

        _.each ['begin_on', 'end_on'], (field)->
          $("[data-#{field.replace('_', '-')}]").datepicker('setDate', responce[field]);

    insertFields: (e, insertedItem)->
      insertedItem.find('.selectordie').selectOrDie()
      checkboxes = insertedItem.find('input:checkbox').customForm();
      @.initDatePicker(insertedItem)

    initDatePicker: ($el)->
      initDatepicker($el.find('.js-datepicker'))

    loadGroupPrices: ()->
      groupId = $('.js-group-select').val()
      educationFormId = $('.js-education-form-select').val()
      $groupPriceSelect = $('.js-group-price-select')
      $groupPriceSelect.html('')
      $groupPriceSelect.append($('<option>', {text: 'не выбрано', value: ''}))

      $.get Routes.admin_group_group_prices_path(groupId, education_form_id: educationFormId), (groupPrices)->
        _.each groupPrices, (groupPrice)->
          $groupPriceSelect.append($('<option>', {text: groupPrice.display_text, value: groupPrice.id}))

        $groupPriceSelect.find('option:first').attr('selected', 'selected')
        $groupPriceSelect.selectOrDie('update')

    recalculatePayments: (e)->
      $link = $(e.currentTarget)
      groupId = $('.js-group-select').val()
      groupPriceId = $('.js-group-price-select').val()
      discountId = $('.js-discount-select').val()

      if groupPriceId.length == 0
        return false

      that = @

      $.get Routes.recalculate_admin_student_payments_path($link.data('student-id'), data: {group_subscription_id: $link.data('group-subscription-id'), group_id: groupId, group_price_id: groupPriceId, discount_id: discountId}), (responce)->
        if responce.price == undefined
          return false

        $('.js-price').val(responce.price)
        $('.js-payments').replaceWith($(responce.html))
        that.initDatePicker($('.js-payments'))

      return false;

    showPracticeBasis: (e)->
      if $(e.currentTarget).val() == 'practice'
        $('.js-practice-basis').show()
      else
        $('.js-practice-basis').hide()

    generateDocuments: (e)->
      $link = $(e.currentTarget)
      groupId = $('.js-group-select').val()
      amoModuleId = $('.js-amo-module-select').val()

      if groupId.length == 0
        return false

      that = @

      $.get Routes.generate_admin_student_subscription_documents_path($link.data('student-id'), group_id: groupId, amo_module_id: amoModuleId), (responce)->
        if responce.html == undefined
          return false

        $html = $(responce.html)
        $('.js-subscription-documents-list').html($html)
        that.initDatePicker($html)
        $html.find('.selectordie').selectOrDie()

      return false


  new GroupSubscriptionForm()
  
  $(document).on 'click', '.js-generate-document', ->
    $(@).closest('.grid').find('.js-generate').val(true)
    $(@).closest('form')[0].submit()
    return false

  $(document).on 'click', '.js-has-debts', ->
    alert 'Невозможно сгенерировать документ, т.к. имеется задолженность по оплате!'
    return false

  $(document).on 'click', '.module span', ->
    if $(this).text() == '+'
      $(this).html('-')
    else
      $(this).html('+')
    $(this).closest('.grid__collapse').find('.module_hidden').toggle()
