B.LectureHeaderView = Backbone.View.extend
  tagName: 'div'
  className: 'course_block'

  events:
    'click': 'select'
    'click .icon_del': 'delete'
    'lecturePositionUpdated': 'updatePosition'

  initialize: (lecture)->
    @.lecture = lecture
    @.listenTo(@.lecture, 'change:description', @.updateDescription)
    @.render()

  render: ->
    template = _.template($('#lecture-header-template').html(), {name: @.lecture.get('description')})
    @.$el.html(template)

  activate: ->
    @.$el.addClass('course_block__current')

  deactivate: ->
    @.$el.removeClass('course_block__current')

  updateDescription: (lecture, description) ->
    @.$('.course_block_innner').text(description)

  select: ->
    @.trigger('lecture:select', @.lecture)
    false

  delete: ->
    @.trigger('lecture:remove', @.lecture)
    false

  updatePosition: (e, position)->
    @.lecture.set('position', position)
