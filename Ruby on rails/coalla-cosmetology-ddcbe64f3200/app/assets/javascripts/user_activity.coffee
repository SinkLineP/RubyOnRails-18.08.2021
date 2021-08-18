if typeof gon != 'undefined' && gon.activity
  recordActivity = (asynchronous = true) ->
    $.ajax
      url: Routes.user_activities_path()
      type: 'post'
      data: gon.activity
      async: asynchronous

  recordActivity()

  ifvisible.setIdleDuration(60)
  setInterval ->
    if ifvisible.now('active')
      recordActivity()
  , 60000

  recordLeavingActivity = ->
    gon.activity.event_type = 'leaving'
    recordActivity(false)

  valid = false

  captureKeyPress = (e)->
    valid = e.which == 116
    return true

  document.onkeydown = captureKeyPress
  document.onkeyup = captureKeyPress
  document.onkeypress = captureKeyPress

  $('a').on 'click', ->
    valid = !$(@).hasClass('js-sign-out')
    return true

  $('form').submit (e) ->
    valid = true

  window.onbeforeunload = (e) ->
    if !valid
      recordLeavingActivity()
else
  alert('У вас заблокирован js, обратитесь в техническую поддержку!')
  window.location.reload()
