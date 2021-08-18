B.Lecture = Backbone.Model.extend
  defaults:
    pdf_editable: true
    read_before_practice: false

  initialize: (json = {}) ->
    @.materials = new B.Materials(json.materials)
    @.downloads = new B.Downloads(json.downloads)
    @.task = new B.Task(json.task)
    @.listenTo(@.materials, 'remove', @.materialRemoved)

  addMaterial: (options)->
    newMaterial = new B.Material(options)
    @.materials.add(newMaterial)
    @.selectMaterial(newMaterial)

  addDownload: (json) ->
    newDownload = new B.Download(json)
    @.downloads.add(newDownload)

  materialRemoved: (material, materials) ->
    filtredMaterials = materials.where({type: material.get('type')})
    nextMaterial = @.nextMaterial(filtredMaterials)
    @.selectMaterial(nextMaterial)
    @.trigger('materialRemoved', @, nextMaterial)

  nextMaterial: (materials) ->
    if materials.length > 0
      materials[materials.length - 1]

  selectMaterial: (material)->
    @.set('selectedMaterial', material)

  toJSON: ->
    json = _(@.attributes).clone()
    json.materials_attributes = @.materials.toJSON()
    delete json['selectedMaterial']
    delete json['materials']
    json.downloads_attributes = @.downloads.toJSON()
    delete json['downloads']
    json.task_attributes = @.task.toJSON()
    delete json['task']
    json

B.Lectures = Backbone.Collection.extend
  model: B.Lecture