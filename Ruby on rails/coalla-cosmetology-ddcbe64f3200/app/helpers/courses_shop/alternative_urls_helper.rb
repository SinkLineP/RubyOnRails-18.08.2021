module CoursesShop
  module AlternativeUrlsHelper
    def alternative_speciality_url(item, options = {})
      return '#' unless item
      url_params = options.merge(root_id: item.parent.try(:slug))
      url_params.merge!(id: item.slug)
      courses_shop_speciality_url(url_params)
    end

    def alternative_course_url(item, parent_speciality = nil, options = {})
      return '#' unless item
      root_speciality = parent_speciality || item.root_speciality
      url_params = options.merge(speciality_id: root_speciality.try(:slug))
      url_params.merge!(id: item.friendly)
      courses_shop_course_url(url_params)
    end
  end
end