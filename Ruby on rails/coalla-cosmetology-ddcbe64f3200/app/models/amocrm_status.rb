# == Schema Information
#
# Table name: amocrm_statuses
#
#  id                 :integer          not null, primary key
#  title              :text             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  amocrm_id          :integer          not null
#  amocrm_pipeline_id :integer
#  status_action      :string
#

class AmocrmStatus < ActiveRecord::Base
  SUCCESS = 142
  FAIL = 143
  FEEDBACK = 14787777

  belongs_to :pipeline,
             class_name: 'AmocrmPipeline',
             inverse_of: :statuses,
             foreign_key: :amocrm_pipeline_id
  has_many :group_subscriptions,
           inverse_of: :amocrm_status,
           dependent: :nullify

  validates :title, presence: true

  scope :ordered, ->() { order(:amocrm_pipeline_id, :amocrm_id) }

  class << self
    def success
      find_by(amocrm_id: SUCCESS)
    end

    def primary_treatment_statuses
      where(status_action: :primary_treatment)
    end

    def meeting_statuses
      where(status_action: :meeting)
    end
  end

  def display_title
    return title unless pipeline
    "#{title} (#{pipeline.title})"
  end

  def success?
    amocrm_id == SUCCESS
  end
end
