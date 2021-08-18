B.BlockForm = Backbone.View.extend
  el: '.form__blocks'

  events:
    'click #save': 'save'
    'click #preview': 'preview'
    'click #add-scribd-material': 'addScribdMaterial'
    'click #add-pdf-material': 'addPdfMaterial'
    'sortstop .js-lecture-list': 'updatePosition'

  initialize: ->
    @.block = new B.Block(gon.block)
    @.blockView = new B.BlockView(@.block)
    @.headerView = new B.LecturesHeaderView(@.block)
    @.listenTo(@block, 'change:selectedLecture', @.lectureSelected)
    @.block.loadLectures()
    $('.js-task').customForm()
    if @.block.get('editable')
      $('.js-lecture-list').sortable
        cancel: '.js-lecture-add'

  lectureSelected: (block, lecture)->
    if @.bodyView
      @.bodyView.saveState()
      @.bodyView.remove()
    if lecture
      @.bodyView = new B.LectureBodyView(lecture)
      @.bodyView.getState(lecture)
      @.updateBodyView()
      @.bindLectureEvents(lecture)

      lecture.materials.each (material) ->
        @.createThumbView(material)
      , @

      scribdMaterials = lecture.materials.where({type: 'ScribdMaterial'})
      lecture.selectMaterial(scribdMaterials[0])
      pdfMaterials = lecture.materials.where({type: 'PdfMaterial'})
      lecture.selectMaterial(pdfMaterials[0])

    else
      @.bodyView = null

    $('.js-task').customForm();

  updateBodyView: ->
    @.headerView.$el.after(@.bodyView.$el)
    @.bodyView.afterDomInsert()

  save: ->
    @.beforeSave()
    @.block.save(null, {success: @.blockSaved})
    false

  preview: ->
    @.beforeSave()
    data = {}
    data = @.block.toJSON();
    selectedLecture = @.block.get('selectedLecture')
    data.extras = {commit: 'preview', lecture_id: selectedLecture.get('id')}
    @.block.save(data, {async: false, success: @.blockPreview})
    @.block.unset('extras', silent: true)
    false

  beforeSave: ->
    @.blockView.saveState()
    @.bodyView.saveState() if @.bodyView
    @.pdfMaterialFormView.pushState() if @.pdfMaterialFormView
    @.scribdMaterialFormView.pushState() if @.scribdMaterialFormView

  blockSaved: (block, data)->
    if data.error
      alert(data.error)
    else
      window.location = data.redirect_url

  blockPreview: (block, data)->
    win = window.open(Routes.preview_courses_path(preview: data.preview), '_blank')
    win.document.open()
    win.document.write(data.preview)
    win.document.close()
    false

  bindLectureEvents: (lecture)->
    @stopListening(lecture.materials, 'add')
    @listenTo(lecture.materials, 'add', @materialAdded)

    @stopListening(lecture, 'materialRemoved')
    @listenTo(lecture, 'materialRemoved', @erase)

    @stopListening(lecture, 'change:selectedMaterial')
    @listenTo(lecture, 'change:selectedMaterial', @materialSelected)

  addScribdMaterial: ->
    selectedLecture = @.block.get('selectedLecture')
    selectedLecture.addMaterial()

  addPdfMaterial: ->
    selectedLecture = @.block.get('selectedLecture')
    selectedLecture.addMaterial({type: 'PdfMaterial'})

  materialAdded: (material)->
    @.createThumbView(material)

  createThumbView: (material)->
    materialThumbView = new B.MaterialThumbView(material)
    @.listenTo(materialThumbView, 'material:select', @.selectMaterial)
    if material.get('type') == 'ScribdMaterial'
      @.$('.js-add-scribd-material-btn').before(materialThumbView.$el)
    else
      @.$('.js-add-pdf-material-btn').before(materialThumbView.$el)

  selectMaterial: (material)->
    selectedLecture = @.block.get('selectedLecture')
    selectedLecture.selectMaterial(material)

  materialSelected: (lecture, material)->
    unless material
      return

    if material.get('type') == 'ScribdMaterial'
      materialFormView = 'scribdMaterialFormView'
      $list = @.$('.js-scribd-materials-list')
    else
      materialFormView = 'pdfMaterialFormView'
      $list =  @.$('.js-pdf-materials-list')

    if @[materialFormView] && @[materialFormView].material.get('type') == material.get('type')
        oldArrowPosition = @[materialFormView].$el.find('.js-material-arrow').css('left')
        @[materialFormView].pushState()
        @[materialFormView].remove()

    @[materialFormView] = new B.MaterialFormView(material)
    $list.after(@[materialFormView].$el)

    if oldArrowPosition
      @[materialFormView].$el.find('.js-material-arrow')
      .css(left: oldArrowPosition)
      .stop().animate(@.arrowCssPosition(lecture, material), 400)
    else
      @[materialFormView].$el.find('.js-material-arrow').css(@.arrowCssPosition(lecture, material))

  arrowCssPosition: (lecture, material) ->
    filtredMaterials = lecture.materials.where({type: material.get('type')})
    {left: "#{filtredMaterials.indexOf(material)*64 + 27}px"}

  updatePosition: ()->
    $.map $('.js-lecture-list').find('.course_block'), (el)->
      $(el).trigger('lecturePositionUpdated', $(el).index() + 1)

  erase: (lecture, material)->
    scribdMaterials = lecture.materials.where({type: 'ScribdMaterial'})
    pdfMaterials = lecture.materials.where({type: 'PdfMaterial'})
    @.scribdMaterialFormView.remove() if scribdMaterials.length == 0 && @.scribdMaterialFormView
    @.pdfMaterialFormView.remove() if pdfMaterials.length == 0 && @.pdfMaterialFormView