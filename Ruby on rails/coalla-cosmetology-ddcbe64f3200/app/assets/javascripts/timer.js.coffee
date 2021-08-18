class Timer

  constructor: (selector)->
    @secondsInMinute = 60
    @$el = $(selector)
    @taskId = @$el.data('task-id')
    @courseId = @$el.data('course-id')
    @userActivityId = @$el.data('activity-id')
    @.initTimer()

  initTimer: ->
    maxInterval = @$el.val() * @secondsInMinute
    that = @
    @$el.knob
      readOnly: true
      max: maxInterval
      width: 102
      thickness: .04
      fgColor: '#fff'
      dynamicDraw: false
      bgColor: '#b02048'
      fontWeight: 22
      format: (value)->
        minutes = Math.floor(value / that.secondsInMinute)
        seconds = value % that.secondsInMinute
        return "#{that.formatTime(minutes)}:#{that.formatTime(seconds)}"

    intervalId = setInterval (->
      newVal = --maxInterval
      that.$el.val(newVal).trigger('change')
      if newVal <= 0
        that.timeExpired(intervalId)
      return
    ), 1000

  formatTime: (value)->
    return ("0" + value).slice(-2)

  timeExpired: (intervalId)->
    clearInterval(intervalId)
    $.ajax
      type: 'POST',
      async: false,
      url: Routes.expire_task_results_path(@taskId, activity_id: @userActivityId, course_id: @courseId),
      success: (data)->
        window.location.replace(data.redirectUrl)
        return

@Timer = Timer

$ ->
  new Timer('.js-timer')
  return
