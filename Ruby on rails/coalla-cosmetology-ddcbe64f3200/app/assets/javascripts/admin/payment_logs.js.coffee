$ ->
  PaymentLogForm = Backbone.View.extend
    el: '#payment_log_form'

    events:
      'change .js-appointment-select': 'onAppointmentSelect'

    initialize: ->
      initDatepicker(@.$el.find('.js-datepicker'))

    onAppointmentSelect: (e)->
      appointment = $(e.currentTarget).val()
      
      if appointment == 'education'
        $('.js-group').show()
        $('.js-comment').hide()
        $('.js-payment').hide()
      else if appointment == 'extraordinary'
        $('.js-group').hide()
        $('.js-comment').show()
        $('.js-payment').hide()
      else if appointment == 'magazine'
        $('.js-group').hide()
        $('.js-comment').hide()
        $('.js-payment').show()

  new PaymentLogForm()