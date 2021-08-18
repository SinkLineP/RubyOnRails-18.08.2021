B.Block = Backbone.Model.extend
  url: ->
    if @.isNew() then Routes.admin_blocks_path() else Routes.admin_block_path(@.id)

  initialize: ->
    @.lectures = new B.Lectures()

  loadLectures: ->
    @.lectures.reset(gon.lectures)
    if @.lectures.length > 0
      @.selectLecture(@.lectures.at(0))

  addLecture: ->
    newLecture = new B.Lecture()
    @.lectures.add(newLecture)
    @.selectLecture(newLecture)

  selectLecture: (lecture)->
    @.set('selectedLecture', lecture)

  removeLecture: (lecture)->
    if lecture == @.get('selectedLecture')
      newSelectedLecture = @.newSelectedLecture(lecture)
      @.lectures.remove(lecture)
      @.selectLecture(newSelectedLecture)
    else
      @.lectures.remove(lecture)

  newSelectedLecture: (lecture)->
    index = @.lectures.indexOf(lecture)
    if index > 0
      @.lectures.at(index - 1)
    else if @.lectures.length > 1
      @.lectures.at(1)

  toJSON: ->
    json = _(@.attributes).clone()
    json.lectures_attributes = @.lectures.toJSON()
    delete json['selectedLecture']
    json