#=require ./images
$ ->
  InstitutionBlockForm = Backbone.View.extend
    el: '#institution_block_form'

    events:
      'submit': 'reorderInstitutionImages'
      'click .js-remove-institution-image': 'removeInstitutionImage'
      'click .js-add-institution-image': 'addInstitutionImage'
      'click .course_block[data-institution-image]': 'clickOnInstitutionImage'
      'change .js-institution-image-name': 'changeImageText'

    initialize: ->

      @.institutionImageTemplate = $('#institution_image_template').html()
      @.institutionImageThumbTemplate = $('#institution_image_thumb_template').html()

      $('.js-institution-images').sortable
        items: '.course_block',
        cancel: 'a,.js-remove-institution-image'

    #institution images

    reorderInstitutionImages: ()->
      ids = _.map $('.js-institution-images').find('.course_block[data-institution-image]'), (item)->
          return $(item).data('institution-image')

      _.each ids, (id)->
        $('.js-institution-images').append($('.js-institution-images').find('.add_ctn[data-institution-image="' + id + '"]'))

    clickOnInstitutionImage: (e)->
      @.selectInstitutionImage($(e.currentTarget))

    changeImageText: (e)->
      $institutionImage = $(e.currentTarget).closest('.add_ctn')
      institutionImageId = $institutionImage.attr('data-institution-image')
      @.changeInstitutionImageText($institutionImage, $('.course_block[data-institution-image="' + institutionImageId + '"]'))

    selectInstitutionImage: ($institutionImageThumb)->
      $institutionImageThumb.parent().find('.course_block').removeClass('course_block__current')
      $institutionImageThumb.addClass('course_block__current')
      $institutionImagesBlock = $institutionImageThumb.parent().parent()
      $institutionImagesBlock.find('.add_ctn').hide()
      institutionImageId = $institutionImageThumb.attr('data-institution-image')
      $institutionImagesBlock.find('.add_ctn').hide()
      $institutionImagesBlock.find('.add_ctn[data-institution-image="' + institutionImageId + '"]').show()

    addInstitutionImage: (e)->
      id = (new Date).getTime()

      $institutionImageThumb = $(@.institutionImageThumbTemplate)
      $institutionImageThumb.attr('data-institution-image', id)
      $(e.currentTarget).before($institutionImageThumb)

      $imagesBlock = $(e.currentTarget).closest('.js-institution-images')
      $institutionImage = $(@.institutionImageTemplate.replace(new RegExp('__id__', 'g'), id))
      $institutionImage.attr('data-institution-image', id)
      $institutionImage.customForm()
      $imagesBlock.append($institutionImage)
      initImageUpload()

      @.changeInstitutionImageText($institutionImage, $institutionImageThumb)
      @.selectInstitutionImage($institutionImageThumb)

    removeInstitutionImage: (e)->
      $thumb = $(e.currentTarget).closest('.course_block')
      $prevThumb = $thumb.prev()
      institutionImageId = $thumb.attr('data-institution-image')
      $thumb.remove()
      $institutionImage = $('.add_ctn[data-institution-image="' + institutionImageId + '"]')
      $institutionImage.find('[data-destroy]').val('1')
      $institutionImage.hide()
      @.selectinstitutionImage($prevThumb)

    changeInstitutionImageText: ($institutionImage, $institutionImageThumb)->
      institutionImageTitle = $institutionImage.find('.js-institution-image-name').val()
      $institutionImageThumb.find('.course_block_inner').text(institutionImageTitle)

  new InstitutionBlockForm()