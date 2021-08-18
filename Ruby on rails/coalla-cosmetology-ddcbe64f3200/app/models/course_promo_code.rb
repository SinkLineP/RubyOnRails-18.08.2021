# == Schema Information
#
# Table name: course_promo_codes
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  promo_code_id :integer
#  position      :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_course_promo_codes_on_course_id      (course_id)
#  index_course_promo_codes_on_promo_code_id  (promo_code_id)
#

class CoursePromoCode < ActiveRecord::Base

  belongs_to :course, inverse_of: :course_promo_codes
  belongs_to :promo_code, inverse_of: :course_promo_codes

  simple_acts_as_list scope: :course

  scope :ordered, -> { order(:position) }

end
