# == Schema Information
#
# Table name: course_works
#
#  id         :integer          not null, primary key
#  hours      :integer
#  main       :boolean          default(FALSE), not null
#  course_id  :integer
#  work_id    :integer
#  lecture_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer          default(0), not null
#  practice   :boolean          default(FALSE), not null
#
# Indexes
#
#  index_course_works_on_course_id   (course_id)
#  index_course_works_on_lecture_id  (lecture_id)
#  index_course_works_on_work_id     (work_id)
#

class CourseWork < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_works
  belongs_to :work, inverse_of: :course_works
  belongs_to :lecture, inverse_of: :course_works

  delegate :title, to: :work, allow_nil: true

  with_options presence: true do
    validates :work_id
    validates :hours,
              numericality: {
                allow_blank: true,
                greater_than_or_equal_to: 0,
                only_integer: true
              }
  end

  scope :ordered, ->() { order(:position) }
  scope :main, ->() { where(main: true) }
  scope :main_ordered, ->() { main.ordered }
end
