# == Schema Information
#
# Table name: notices
#
#  id            :integer          not null, primary key
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  notice_emails :text             default([]), is an Array
#

class Notice < ActiveRecord::Base
  has_many :notice_groups, inverse_of: :notice, dependent: :destroy
  has_many :groups, through: :notice_groups
  has_many :students, through: :groups
  has_many :deleted_notices, inverse_of: :notice, dependent: :destroy
  has_many :notice_attachments, inverse_of: :notice, dependent: :destroy

  scope :for_student, ->(student) { joins("LEFT JOIN deleted_notices ON deleted_notices.notice_id = notices.id AND deleted_notices.student_id = #{student.id}").where('deleted_notices.id IS NULL') }

  multi_field 'groups', through_collection_name: 'notice_groups'

  validates_presence_of :message, :notice_groups

  delegate :name, to: :course, prefix: true, allow_nil: true
  accepts_nested_attributes_for :notice_attachments, allow_destroy: true

  def course
    @course ||= groups.first.try(:course)
  end

  def notify_students
    Delayed::Job.enqueue NotifyStudents.new(id)
  end
end
