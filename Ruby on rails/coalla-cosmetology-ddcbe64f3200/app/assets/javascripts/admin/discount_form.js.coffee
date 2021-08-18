#=require ./base_form
DiscountForm = Views.BaseForm.extend
  el: '#discount_form'

  events:
    'ajax:success': 'afterSave'
    'cocoon:before-insert .grid': 'insertFields'
    'change .js-discount-type': 'onChangeDiscountType'

  initialize: ->
    @.initSelectOrDie(@.$el)
    $('.js-form').customForm();

  insertFields: (e, $insertedItem)->
    $insertedItem.find('.selectordie').selectOrDie()

  onChangeDiscountType: (e)->
    discountType = $(e.currentTarget).val()

    if (discountType == 'CompositeDiscount')
      $('.js-discount-add').show()
      $('.js-discount-value').hide()
    else
      $('.js-discounts').remove()
      $('.js-discount-add').hide()
      $('.js-discount-value').show()

new DiscountForm()