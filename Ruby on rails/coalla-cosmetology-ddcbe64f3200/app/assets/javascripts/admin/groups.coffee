@.initializeDatepicker = (selector) ->
  initDatepicker($(selector))

@.initializeTimepicker = (selector) ->
  $(selector).mask('AB:CB', {'translation': {
      A: {pattern: /[0-2]/},
      B: {pattern: /[0-9]/},
      C: {pattern: /[0-5]/}
    }
  });

@.initializeNumberMask = (selector) ->
  $(selector).mask('0#');


@.maskPaymentOptions = {
  'translation': {
    A: {pattern: /[0-9;]/, recursive: true}
  },
  onChange: (val, e) ->
    s = val.replace(/;+/g, ';')
    $(e.target).val( s )
}
@.initializePaymentMask = (selector) ->
  $(selector).mask('A', maskPaymentOptions);

initializeDatepicker('.js-datepicker')
initializeTimepicker('.js-timepicker')
initializeNumberMask('.js-number-mask')
initializePaymentMask('.js-payment-mask')

$('.selectordie').selectOrDie()

$('.admin_body').on 'cocoon:after-insert', (e, inserted_item) ->
  $(inserted_item).find('.selectordie').selectOrDie()
  initializeDatepicker( $(inserted_item).find('.js-datepicker') )
  initializeTimepicker( $(inserted_item).find('.js-timepicker') )
  initializeNumberMask( $(inserted_item).find('.js-number-format') )
  initializePaymentMask( $(inserted_item).find('.js-payment-mask') )
  $(inserted_item).customForm()

$('.js-hide-week_days').change (e) ->
  $('#week_days').hide()
  $('#shift_work_on').show()

  checkboxes = $('#week_days').find('input:checkbox')
  $.each checkboxes, (idx, el) ->
    $(el).closest('.form_el').data('checked', false)

  checkboxes.removeAttr('checked')
  checkboxes.customForm();

$('.js-show-week_days').change (e) ->
  $('#week_days').show()
  $('#shift_work_on').hide()

  $('#shift_work_on').find('input').val('')

$(document).on 'change', '.js-number-format', (e) ->
  $('.js-timepicker').mask('0', {reverse: true});
