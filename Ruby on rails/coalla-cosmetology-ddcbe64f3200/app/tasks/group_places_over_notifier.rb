class GroupPlacesOverNotifier
  def self.run
    Group.joins(:course).without_free_places.not_notified.
                         where(courses: {place_over_notification: true}).
                         select { |group| group.first_practice_day > Date.current && group.education_form.try(:online?) if group.first_practice_day }.each do |group|
      group.update_column(:places_over_notified, true)
      CosmetologyMailer.group_places_ended(group).deliver
    end
  end
end