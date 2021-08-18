$ ->
  AmoModulesForm = Backbone.View.extend
    el: '#amo_module_form'

    events:
      'click .js-remove-course': 'removeCourse'

    initialize: ->
      $('.js-autocomplete-courses').autocomplete
        minLength: 3
        source: Routes.list_admin_courses_path()
        appendTo: $('.autocomplete_variants.js-courses-variants')

        open: ->
          $(this).addClass('open')

        select: (e, ui) ->
          if !ui.item
            $(this).val('')
            return false

          if $('[data-course-id][value="' + ui.item.id + '"]').length > 0
            $(this).val('')
            return false

          $course = $($('#course_template').html())
          $('.js-courses-list').append($course)
          $course.find('[data-course-id]').val(ui.item.id)
          $course.find('[data-edit-course-link]').attr('href', ui.item.link).text(ui.item.value)
          $(this).val('')
          return false

    removeCourse: (e)->
      $(e.target).closest('.course_block').remove()

  new AmoModulesForm()