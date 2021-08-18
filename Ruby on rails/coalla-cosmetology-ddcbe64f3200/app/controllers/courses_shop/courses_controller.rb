module CoursesShop
  class CoursesController < BaseController
    include CoursesShop::AlternativeUrlsHelper

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def show
      speciality = Speciality.find_by_friendly!(params[:speciality_id])
      raise ActionController::RoutingError.new('Not Found') if speciality.parent_id.present? 
      @course = speciality.all_courses.find_by_friendly!(params[:id])
      set_meta_tags(canonical: alternative_course_url(@course)) if speciality != @course.root_speciality
      @groups = @course.nearest_groups
      if @groups.blank?
        Rails.logger.error("Not find groups on this course. #{request.referer}")
        redirect_to root_path
      end
      @instructors = @course.instructors
      @similars = @course.similars.displayed
      @recalls = @course.recalls.to_a.sort_by{|recall| recall[:lock_on_top] ? 0 : 1}.first(3)
      @faqs = Faq.ordered
      set_meta_tags_for_item(@course, @course.image_url(:thumb))
    end
  end
end