module CoursesShop
  class MarkupController < BaseController
    def demo

    end

    def index
      @body_class = 'index-page'
    end

    def courses

    end

    def course

    end

    def course_added

    end

    def about

    end

    def info

    end

    def contacts

    end

    def promotions

    end

    def licenses

    end

    def faq

    end

    def feedbacks

    end

    def personal_cabinet_courses

    end

    def personal_cabinet_schedule

    end

    def personal_cabinet_documents

    end

    def personal_cabinet_settings

    end

    def basket

    end

    def articles

    end

    def article

    end

    def offer

    end

    def models

    end

    def mass_media

    end

    def for_business

    end

    def search_results

    end

    def configurator_results

    end

    def error
      @body_class = 'error-page'
      render layout: false
    end

    def disability
      render layout: false
    end

  end
end