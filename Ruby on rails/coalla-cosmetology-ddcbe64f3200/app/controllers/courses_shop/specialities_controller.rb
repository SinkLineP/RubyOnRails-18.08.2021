module CoursesShop
  class SpecialitiesController < BaseController

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def show
      @current_speciality = params[:root_id] ? Speciality.find_by_friendly!(params[:root_id]).children.visible.find_by_friendly!(params[:id]) : Speciality.visible.find_by_friendly!(params[:id])
      set_page_meta_tags(site: '',
                         identifier: '/specialities',
                         title: @current_speciality.meta_title,
                         description: @current_speciality.meta_description,
                         og: { title: @current_speciality.meta_og_title,
                               description: @current_speciality.meta_og_description })
      @parent_speciality = @current_speciality.parent || @current_speciality
      @specialities = @parent_speciality.children.visible.level.ordered
    end
  end
end