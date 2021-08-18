module WithPlaces
  extend ActiveSupport::Concern

  included do
    GROUP_FIELDS = %i[min_begin_practice_date times schedule group_number].freeze

    scope :statistics, -> {
      select("json_agg(json_build_object('title',title,
                                       'dates', dates,
                                       'distances_place', distances_place,
                                       'distances_count', distances_count)) as groups_information,
            times,
            schedule,
            min_begin_practice_date,
            group_number,
            SUM(distances_place) as total_distances_place,
            SUM(distances_count) as total_distances_count")
          .group(GROUP_FIELDS)
          .group("course_short_name = 'K-WSR', course_short_name = 'ML-WSR', course_short_name = 'AK-WSR'")
          .order(GROUP_FIELDS)
    }
    scope :with_courses, ->(courses) { where(course_short_name: courses) }
  end
end
