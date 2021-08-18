module CoursesShop
  class InstitutionBlocksController < BaseController

    add_breadcrumb :info, :courses_shop_institution_blocks_path

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def index
      set_page_meta_tags(identifier: '/info')
      @institution_blocks = InstitutionBlock.ordered
      @instructors = Instructor.alphabetical_order
    end

  end
end
