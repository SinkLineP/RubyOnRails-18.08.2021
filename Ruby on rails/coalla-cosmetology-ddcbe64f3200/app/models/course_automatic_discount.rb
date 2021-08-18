# == Schema Information
#
# Table name: course_automatic_discounts
#
#  id                    :integer          not null, primary key
#  course_id             :integer
#  automatic_discount_id :integer
#  position              :integer          default(0), not null
#  created_at            :datetime
#  updated_at            :datetime
#
# Indexes
#
#  index_course_automatic_discounts_on_automatic_discount_id  (automatic_discount_id)
#  index_course_automatic_discounts_on_course_id              (course_id)
#

class CourseAutomaticDiscount < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_automatic_discounts
  belongs_to :automatic_discount, inverse_of: :course_automatic_discounts

  simple_acts_as_list scope: :course

  scope :ordered, -> { order(:position) }
end
