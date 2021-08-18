xml.instruct! :xml, version: '1.0'
xml.tag! 'yml_catalog', date: Time.current.strftime('%Y-%m-%d %H:%M') do

  xml.shop do
    xml.name 'Дом Русской Косметики'
    xml.company 'АНО ДПО "Институт косметологии, эстетической медицины и визажного искусства – Дом Русской Косметики"'
    xml.url root_url
  end

  xml.currencies do
    xml.tag! 'currency', id: 'RUR', rate: '1'
  end

  xml.categories do
    @specialities.each do |speciality|
      if speciality.root?
        xml.category speciality.title, id: speciality.id
      else
        xml.category speciality.display_title, id: speciality.id, parentId: speciality.parent_id
      end
    end
  end

  xml.cpa 1

  xml.offers do
    @courses.each do |course|
      xml.offer id: course.id, available: course.displayed? do
        if course.specialities.present?
          xml.url alternative_course_url(course)
        end
        xml.name course.title.presence || course.name
        xml.price course.total_price
        xml.currencyId 'RUR'
        xml.description course.announcement
        course.specialities.each do |speciality|
          xml.categoryId speciality.id
        end
        xml.picture course.small_image? ? URI.join(root_url, course.small_image_url(:thumb)) : asset_url('courses_shop/page_promo/page_promo_index.jpg')
        nearest_group = course.nearest_group
        education_dates = nearest_group ? nearest_group.education_dates : []
        xml.CourseDates education_period(nearest_group)
        xml.Hours education_schedule(nearest_group)
        xml.FreePlaces free_places_text(nearest_group)
        xml.EarlyBookingDiscount economy_text(course)
        fake_group = nearest_group.blank? || nearest_group.fake
        xml.StartCourse fake_group ? '' : feed_date_format(education_dates[0])
        xml.EndCourse fake_group ? '' : feed_date_format(education_dates[1])
        unless fake_group
          xml.FreePlacesDigit nearest_group.free_places
        end
        xml.NewGroup course.groups.active.where('groups.created_at > ?', @update_at).exists?
        xml.StartGroup course.groups.active.ordered.map { |g| feed_start_group_date(g) }.reject(&:blank?).join('|')
        xml.promo false
      end
    end
  end

end