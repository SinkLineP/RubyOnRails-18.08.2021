$ ->
  CoursesForm = Backbone.View.extend
    el: '#course_form'

    events:
      'submit': 'reorderWorks'
      'click .js-remove-block': 'removeBlock'
      'click .js-remove-course-document': 'removeCourseDocument'
      'click .js-add-course-document': 'addCourseDocument'
      'click .course_block[data-course-document]': 'clickOnCourseDocument'
      'change .js-education-level': 'selectLevelOrDocument'
      'change .js-education-document': 'selectLevelOrDocument'
      'click .js-remove-course-work': 'removeCourseWork'
      'click .js-add-course-work': 'addCourseWork'
      'click .course_block[data-course-work]': 'clickOnCourseWork'
      'change .js-work': 'selectWork'
      'change .js-additional-amo-module': 'setAdditionalAmoModule'

    initialize: ->
      @.courseDocumentTemplate = $('#course_document_template').html()
      @.courseDocumentThumbTemplate = $('#course_document_thumb_template').html()

      @.courseWorkTemplate = $('#course_work_template').html()
      @.courseWorkThumbTemplate = $('#course_work_thumb_template').html()

      $('.js-course-works').sortable
        items: '.course_block',
        cancel: 'a,.js-remove-course-work'

      $('.js-autocomplete-blocks').autocomplete
        minLength: 3
        source: Routes.list_admin_blocks_path()
        appendTo: $('.autocomplete_variants.js-blocks-variants')

        open: ->
          $(this).addClass('open')

        select: (e, ui) ->
          if !ui.item
            $(this).val('')
            return false

          if $('[data-block-id][value="' + ui.item.id + '"]').length > 0
            $(this).val('')
            return false

          $block = $($('#block_template').html())
          $('.js-blocks-list').find('.course_block__add').before($block)
          $block.find('[data-block-id]').val(ui.item.id)
          $block.find('[data-edit-block-link]').attr('href', ui.item.link).text(ui.item.value)
          $(this).val('')
          return false

    # documents

    removeCourseDocument: (e)->
      $thumb = $(e.currentTarget).closest('.course_block')
      $prevThumb = $thumb.prev()
      courseDocumentId = $thumb.attr('data-course-document')
      $thumb.remove()
      $courseDocument = $('.add_ctn[data-course-document="' + courseDocumentId + '"]')
      $courseDocument.find('[data-destroy]').val('1')
      $courseDocument.hide()
      @.selectCourseDocument($prevThumb)

    removeBlock: (e)->
      $(e.target).closest('.course_block').remove()

    addCourseDocument: (e)->
      id = (new Date).getTime()

      $courseDocumentThumb = $(@.courseDocumentThumbTemplate)
      $courseDocumentThumb.attr('data-course-document', id)
      $(e.currentTarget).before($courseDocumentThumb)

      $documentsBlock = $(e.currentTarget).parent().parent()
      $courseDocument = $(@.courseDocumentTemplate.replace(new RegExp('__id__', 'g'), id))
      $courseDocument.attr('data-course-document', id)
      $documentsBlock.append($courseDocument)
      $courseDocument.find('.selectordie').selectOrDie()

      @.changeBlockName($courseDocument, $courseDocumentThumb)
      @.selectCourseDocument($courseDocumentThumb)

    clickOnCourseDocument: (e)->
      @.selectCourseDocument($(e.currentTarget))

    selectLevelOrDocument: (e)->
      $courseDocument = $(e.currentTarget).closest('.add_ctn')
      courseDocumentId = $courseDocument.attr('data-course-document')
      @.changeBlockName($courseDocument, $('.course_block[data-course-document="' + courseDocumentId + '"]'))

    selectCourseDocument: ($courseDocumentThumb)->
      $courseDocumentThumb.parent().find('.course_block').removeClass('course_block__current')
      $courseDocumentThumb.addClass('course_block__current')

      $documentsBlock = $courseDocumentThumb.parent().parent()
      $documentsBlock.find('.add_ctn').hide()
      courseDocumentId = $courseDocumentThumb.attr('data-course-document')
      $documentsBlock.find('.add_ctn').hide()
      $documentsBlock.find('.add_ctn[data-course-document="' + courseDocumentId + '"]').show()

    changeBlockName: ($courseDocument, $courseDocumentThumb)->
      educationLevel = $courseDocument.find('.js-education-level > option:selected').text()
      educationDocument = $courseDocument.find('.js-education-document > option:selected').text()
      $courseDocumentThumb.find('.course_block_inner').text("#{educationLevel} - #{educationDocument}")

    #works

    reorderWorks: ()->
      ids = _.map $('.js-course-works').find('.course_block[data-course-work]'), (item)->
          return $(item).data('course-work')

      _.each ids, (id)->
        $('.js-course-works').append($('.js-course-works').find('.add_ctn[data-course-work="' + id + '"]'))

    clickOnCourseWork: (e)->
      @.selectCourseWork($(e.currentTarget))

    selectWork: (e)->
      $courseWork = $(e.currentTarget).closest('.add_ctn')
      courseWorkId = $courseWork.attr('data-course-work')
      @.changeCourseWorkText($courseWork, $('.course_block[data-course-work="' + courseWorkId + '"]'))

    addCourseWork: (e)->
      id = (new Date).getTime()

      $courseWorkThumb = $(@.courseWorkThumbTemplate)
      $courseWorkThumb.attr('data-course-work', id)
      $(e.currentTarget).before($courseWorkThumb)

      $worksBlock = $(e.currentTarget).closest('.js-course-works')
      $courseWork = $(@.courseWorkTemplate.replace(new RegExp('__id__', 'g'), id))
      $courseWork.attr('data-course-work', id)
      $courseWork.customForm()
      $worksBlock.append($courseWork)
      $courseWork.find('.selectordie').selectOrDie()

      @.changeCourseWorkText($courseWork, $courseWorkThumb)
      @.selectCourseWork($courseWorkThumb)

    removeCourseWork: (e)->
      $thumb = $(e.currentTarget).closest('.course_block')
      $prevThumb = $thumb.prev()
      courseWorkId = $thumb.attr('data-course-work')
      $thumb.remove()
      $courseWork = $('.add_ctn[data-course-work="' + courseWorkId + '"]')
      $courseWork.find('[data-destroy]').val('1')
      $courseWork.hide()
      @.selectCourseWork($prevThumb)

    changeCourseWorkText: ($courseWork, $courseWorkThumb)->
      workTitle = $courseWork.find('.js-work > option:selected').text()
      $courseWorkThumb.find('.course_block_inner').text(workTitle)

    selectCourseWork: ($courseWorkThumb)->
      $courseWorkThumb.parent().find('.course_block').removeClass('course_block__current')
      $courseWorkThumb.addClass('course_block__current')
      $worksBlock = $courseWorkThumb.parent().parent()
      $worksBlock.find('.add_ctn').hide()
      courseWorkId = $courseWorkThumb.attr('data-course-work')
      $worksBlock.find('.add_ctn').hide()
      $worksBlock.find('.add_ctn[data-course-work="' + courseWorkId + '"]').show()

    setAdditionalAmoModule: (e)->
      $amoCheckBox = $('#course_with_amo_module')
      if $(e.currentTarget).val() != ''
        $amoCheckBox.removeAttr('checked');
        $amoCheckBox.closest('.form_el').attr('data-checked', false);
        $amoCheckBox.attr('disabled', 'disabled')
      else
        $amoCheckBox.removeAttr('disabled');

  new CoursesForm()