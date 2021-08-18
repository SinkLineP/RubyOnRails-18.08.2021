module CoursesShop
  class ConfiguratorController < BaseController

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def show
      @configurator = CourseConfigurator.new(configurator_params)
      @courses = @configurator.filtered_courses.paginate(page: (params[:page].presence || 1).to_i,
                                                         per_page: PER_PAGE)
      if request.xhr?
        if @current_shop.barbershop?
          render_ajax_collection(@courses, 'courses_shop/courses/course_li',
                                 '#courses_list', false)
        else
          render_ajax_collection(@courses, 'courses_shop/courses/course_li_grid',
                                 '#courses_list_grid', false)
        end
        return
      end
    end

    private

    def configurator_params
      if params[:c].blank?
        return {}
      end

      params.require(:c).permit(:education_period,
                                :medical_education,
                                :work_in_cosmetology,
                                subject: []).tap do |h|
        h[:subject] ||= []
      end
    end
  end
end