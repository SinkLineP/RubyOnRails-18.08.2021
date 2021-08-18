B.LecturesHeaderView = Backbone.View.extend
  el: '#lectures-header'

  events:
    'click .course_block__add': 'addLecture'

  initialize: (block)->
    @.headerViews = []
    @.block = block
    @.listenTo(@.block.lectures, 'add', @.lectureAdded)
    @.listenTo(@.block.lectures, 'remove', @.lectureRemoved)
    @.listenTo(@.block.lectures, 'reset', @.lecturesReset)
    @.listenTo(@block, 'change:selectedLecture', @.lectureSelected)

  addLecture: ->
    @.block.addLecture()

  lectureAdded: (lecture, lectures, options)->
    lectureHeaderView = new B.LectureHeaderView(lecture)
    @.headerViews.push(lectureHeaderView)
    @.$('.course_block__add').before(lectureHeaderView.$el)
    @.listenTo(lectureHeaderView, 'lecture:select', @.selectLecture)
    @.listenTo(lectureHeaderView, 'lecture:remove', @.removeLecture)

  selectLecture: (lecture)->
    @.block.selectLecture(lecture)

  lectureSelected: (block, lecture, options)->
    @.activeHeaderView.deactivate() if @.activeHeaderView
    if lecture
      @.activeHeaderView = @.headerByLecture(lecture)
      @.activeHeaderView.activate()
    else
      @.activeHeaderView = null

  removeLecture: (lecture)->
    @.block.removeLecture(lecture)

  lectureRemoved: (lecture, lectures)->
    headerView = @.headerByLecture(lecture)
    @.headerViews = _.filter @.headerViews, (el) ->
      el != headerView
    headerView.remove()

  lecturesReset: (lectures)->
    lectures.each (lecture)->
      @.lectureAdded(lecture, lectures)
    , @

  headerByLecture: (lecture)->
    _.find @.headerViews, (view)->
      view.lecture == lecture
