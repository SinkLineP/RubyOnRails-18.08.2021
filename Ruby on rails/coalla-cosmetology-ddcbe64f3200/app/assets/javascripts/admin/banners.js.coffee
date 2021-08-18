$ ->
  BannerForm = Backbone.View.extend
    el: '#banner_form'

    events:
      'change .js-type-banner-select': 'onTypeBannerSelect'

    onTypeBannerSelect: (e)->
      type = $(e.currentTarget).val()

      if type == 'registration'
       $('.js-banner').hide()
      else
       $('.js-banner').show()

  new BannerForm()