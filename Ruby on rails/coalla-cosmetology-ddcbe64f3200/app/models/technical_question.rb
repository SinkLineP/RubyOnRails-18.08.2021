# == Schema Information
#
# Table name: feedback_questions
#
#  id               :integer          not null, primary key
#  type             :text             not null
#  student_id       :integer
#  instructor_id    :integer
#  index_id         :integer
#  text             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  file             :text
#  student_name     :text
#  groups           :text
#  phone            :text
#  work_title       :text
#  absent_dates     :text
#  new_dates        :text
#  working_off_type :text
#  lecture_id       :integer
#
# Indexes
#
#  index_feedback_questions_on_lecture_id  (lecture_id)
#  index_feedback_questions_on_student_id  (student_id)
#

class TechnicalQuestion < FeedbackQuestion
end
