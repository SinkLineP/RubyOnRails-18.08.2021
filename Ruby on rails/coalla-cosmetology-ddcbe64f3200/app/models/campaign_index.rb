# == Schema Information
#
# Table name: campaign_indices
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  name        :string
#  service     :string
#  value       :float            default(0.0), not null
#  created_on  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_campaign_indices_on_campaign_id  (campaign_id)
#

class CampaignIndex < ActiveRecord::Base
  belongs_to :campaign, inverse_of: :indices

  validates_numericality_of :value, allow_blank: true

  scope :ordered, -> { order(:created_at) }
  scope :sikorsky, -> { where(service: 'sikorsky') }

  before_save do
    self.value = value.to_f.abs
  end

  def human_name
    self.class.model_name.human
  end

end
