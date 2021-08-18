$ ->
  LoginForm = Backbone.View.extend
    el: '#new_user'

    events:
      'ajax:success': 'onLoginFinished'
      'ajax:error': 'onLoginFailed'

    onLoginFinished: (e, data)->
      if data.error
        emailField = @.$el.find('#user_email')
        emailField.closest('.form_el').attr('data-valid', false)
        emailField.attr('title', data.error)
      else
        window.location = data.path

    onLoginFailed: ->
      alert('Ошибка при обращении к серверу')

  new LoginForm()