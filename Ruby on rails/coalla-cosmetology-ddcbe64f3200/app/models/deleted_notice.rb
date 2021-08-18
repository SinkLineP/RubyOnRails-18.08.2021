# == Schema Information
#
# Table name: deleted_notices
#
#  id         :integer          not null, primary key
#  student_id :integer
#  notice_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_deleted_notices_on_notice_id                 (notice_id)
#  index_deleted_notices_on_student_id                (student_id)
#  index_deleted_notices_on_student_id_and_notice_id  (student_id,notice_id) UNIQUE
#


class DeletedNotice < ActiveRecord::Base
  belongs_to :student, inverse_of: :deleted_notices
  belongs_to :notice, inverse_of: :deleted_notices
end
