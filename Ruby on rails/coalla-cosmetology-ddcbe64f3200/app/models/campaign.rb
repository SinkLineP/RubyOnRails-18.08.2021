# == Schema Information
#
# Table name: campaigns
#
#  id            :integer          not null, primary key
#  co_magick_id  :text             not null
#  name          :text
#  phone_type    :text
#  phone         :text
#  utm_sources   :text             default([]), is an Array
#  utm_mediums   :text             default([]), is an Array
#  utm_campaigns :text             default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  seopult_id    :string
#

class Campaign < ActiveRecord::Base
  has_many :indices, inverse_of: :campaign, dependent: :destroy, class_name: :CampaignIndex
  has_many :students, inverse_of: :campaign, dependent: :nullify

  scope :seopult, -> { where.not(seopult_id: nil) }
  scope :ordered, -> { order(:created_at) }

  def self.search_promotion
    find_by(co_magick_id: "4985")
  end

  def related?(link)
    params = Rack::Utils.parse_nested_query(URI(link).query)
    utm_sources.include?(params['utm_source']) &&
        utm_mediums.include?(params['utm_medium']) &&
        utm_campaigns.include?(params['utm_campaign'])
  end

  def human_name
    self.class.model_name.human
  end
end
