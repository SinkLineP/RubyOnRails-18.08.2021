# == Schema Information
#
# Table name: another_group_places
#
#  group_number            :integer
#  id                      :integer
#  course_id               :integer
#  course_short_name       :text
#  title                   :text
#  schedule                :text
#  min_begin_practice_date :date
#  dates                   :text
#  times                   :text
#  distances_place         :integer
#  distances_count         :integer
#  remaining_seats_count   :integer
#

class AnotherGroupPlace < ActiveRecord::Base
  include WithPlaces
end
