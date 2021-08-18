# == Schema Information
#
# Table name: subscription_documents
#
#  id                    :integer          not null, primary key
#  group_subscription_id :integer          not null
#  education_document_id :integer          not null
#  issued_at             :date
#  registration_number   :integer
#  created_at            :datetime
#  updated_at            :datetime
#  document              :text
#  first_appendix        :text
#  second_appendix       :text
#  ready_to_issue        :boolean          default(FALSE)
#  issued                :boolean          default(FALSE)
#  blank_number          :string
#  course_id             :integer
#  decline_first_name    :boolean          default(TRUE), not null
#  decline_last_name     :boolean          default(TRUE), not null
#  decline_middle_name   :boolean          default(TRUE), not null
#
# Indexes
#
#  index_subscription_documents_on_course_id              (course_id)
#  index_subscription_documents_on_education_document_id  (education_document_id)
#  index_subscription_documents_on_group_subscription_id  (group_subscription_id)
#  index_subscription_documents_on_registration_number    (registration_number) UNIQUE
#

class SubscriptionDocument < ActiveRecord::Base

  belongs_to :course, inverse_of: :subscription_documents
  belongs_to :group_subscription, inverse_of: :subscription_documents
  belongs_to :education_document, inverse_of: :subscription_documents
  acts_as_sequenced column: :registration_number, start_at: 12000, skip: lambda { |r| r.registration_number.present? }

  mount_uploader :document, PrivateFileUploader
  mount_uploader :first_appendix, PrivateFileUploader
  mount_uploader :second_appendix, PrivateFileUploader

  scope :ready, -> { where(ready_to_issue: true) }
  scope :issued, -> { where.not(issued_at: nil) }

  delegate :title, to: :education_document, allow_nil: true, prefix: :document
  delegate :builder_class, to: :education_document, allow_nil: true
  delegate :student_full_name, to: :group_subscription
  delegate :name, to: :course, prefix: :course, allow_nil: true

  attr_accessor :generate
  alias_method :generate?, :generate

  validates :registration_number, uniqueness: true, allow_blank: true

  before_save do
    self.issued_at = Time.now if !issued_at && generate?
  end

  after_save :generate!, if: :generate?

  def generate=(value)
    value = ActiveRecord::Type::Boolean.new.type_cast_from_user(value)
    @generate = value
  end

  def generate!
    self.generate = false
    return unless builder_class
    builder = builder_class.new(self)
    attributes = { document: builder.generate }
    %w(first_appendix second_appendix).each do |appendix_name|
      appendix = builder.send(appendix_name)
      if appendix
        attributes[appendix_name] = appendix
      else
        attributes["remove_#{appendix_name}"] = true
      end
    end
    update!(attributes)
  end
end
