class CourseNearestGroupUpdater

  def self.run
    Course.find_each do |course|
      course.change_nearest_group unless course.nearest_group_id == course.nearest_groups.first.try(:id)
    end
  end

end