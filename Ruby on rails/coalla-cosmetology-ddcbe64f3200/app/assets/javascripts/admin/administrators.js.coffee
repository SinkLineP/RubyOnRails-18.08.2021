$ ->
  $(document).on 'ajax:success', '#edit_admin_form', (e, data)->
    window.location = data.redirect_url

  $(document).on 'ajax:before', '#edit_admin_form', ->
    return $('#user_id').val().length > 0
