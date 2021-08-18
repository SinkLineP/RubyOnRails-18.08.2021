# == Schema Information
#
# Table name: courses
#
#  id                       :integer          not null, primary key
#  name                     :text             not null
#  active                   :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  syllabus                 :text
#  delta                    :boolean          default(TRUE), not null
#  timetable                :text
#  price                    :integer
#  external_url             :text
#  short_name               :text
#  hours                    :integer          default(0), not null
#  faculty_id               :integer
#  remote_price             :integer          default(0), not null
#  appointment              :text             not null
#  cost                     :integer          default(0)
#  slug                     :string
#  title                    :string
#  image                    :text
#  announcement             :text
#  practice_hours           :float            default(0.0), not null
#  price_per_month          :float            default(0.0), not null
#  total_price              :float            default(0.0), not null
#  limitation               :string
#  video                    :text
#  early_booking            :boolean          default(FALSE), not null
#  economy                  :float            default(0.0), not null
#  job                      :string
#  profit                   :float            default(0.0), not null
#  small_image              :text
#  special_offer            :boolean          default(FALSE), not null
#  nearest_group_id         :integer
#  nearest_education_day    :date
#  education_period         :integer          default(6), not null
#  subject                  :text
#  medical_education        :boolean          default(FALSE), not null
#  work_in_cosmetology      :boolean          default(FALSE), not null
#  tag_title                :text
#  tag_description          :text
#  badge                    :text
#  diplom_title             :text
#  status_notification_name :text             default("other_notification"), not null
#  place_over_notification  :boolean          default(FALSE), not null
#  with_amo_module          :boolean          default(FALSE), not null
#  shop_id                  :integer
#  default_course           :boolean          default(FALSE), not null
#  notification_audio       :text
#  ivr_audio                :text
#  economy_for_several      :float
#  economy_description      :text
#  course_counts            :integer          default(0), not null
#  additional_amo_module_id :integer
#  student_docs_required    :boolean          default(TRUE), not null
#
# Indexes
#
#  index_courses_on_active                    (active)
#  index_courses_on_additional_amo_module_id  (additional_amo_module_id)
#  index_courses_on_faculty_id                (faculty_id)
#  index_courses_on_name                      (name)
#  index_courses_on_nearest_group_id          (nearest_group_id)
#  index_courses_on_shop_id                   (shop_id)
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  include_examples 'all attributes', %i(name practice_hours price_per_month total_price economy profit)
end
