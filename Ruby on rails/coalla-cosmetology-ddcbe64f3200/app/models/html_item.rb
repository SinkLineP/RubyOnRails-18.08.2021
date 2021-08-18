# == Schema Information
#
# Table name: html_items
#
#  id          :integer          not null, primary key
#  page        :string
#  title       :text
#  description :text
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  shop_id     :integer
#
# Indexes
#
#  index_html_items_on_shop_id  (shop_id)
#

class HtmlItem < ActiveRecord::Base
  scope :ordered, -> { order(:created_at) }
  scope :offer, -> { ordered.where(page: 'offer') }
  scope :privacy_policy, -> { ordered.where(page: 'privacy_policy') }
  scope :business, -> { ordered.where(page: %w(consulting regional_schools manufacturers_and_dealers mass_media corporate_education mass_media recruitment)) }
  scope :about, -> { ordered.where(page: %w(history diploma cecutient_version home_about)) }
  scope :home_about, ->(shop_id) { find_by(page: 'home_about', shop_id: shop_id).content }

  def display_text
    [title, content].reject(&:blank?).first.to_s.truncate(100)
  end
end
