#=require ./base_form
MagazinePaymentTypeForm = Views.BaseForm.extend
  el: '#magazine_payment_type_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    $('.js-form').customForm();

new MagazinePaymentTypeForm()