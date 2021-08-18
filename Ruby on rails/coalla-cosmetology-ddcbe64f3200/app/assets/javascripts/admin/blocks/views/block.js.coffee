B.BlockView = Backbone.View.extend
  el: '.admin_header'

  initialize: (block)->
    @.block = block

  saveState: ->
    _(['name', 'active', 'course_id']).each (attr_name)->
      valArray = @.$("#block_#{attr_name}").serializeArray()
      value = if valArray.length > 0 then valArray[0].value else '0'
      @.block.set(attr_name, value)
    , @