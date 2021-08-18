# == Schema Information
#
# Table name: course_seos
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  place      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_seos_on_course_id  (course_id)
#  index_course_seos_on_place      (place)
#

require 'rails_helper'

RSpec.describe CourseSeo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
