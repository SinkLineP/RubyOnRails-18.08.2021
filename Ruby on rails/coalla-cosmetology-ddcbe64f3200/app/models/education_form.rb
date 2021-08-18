# == Schema Information
#
# Table name: education_forms
#
#  id          :integer          not null, primary key
#  short_title :text             not null
#  title       :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  online      :boolean          default(FALSE), not null
#

class EducationForm < ActiveRecord::Base
  has_many :group_subscriptions, inverse_of: :education_form, dependent: :nullify
  has_many :group_prices, inverse_of: :education_form, dependent: :nullify

  scope :ordered, ->() { order(:title) }

  def self.online
    find_by(online: true)
  end

  def self.offline
    find_by(online: false)
  end

  def offline?
    !online?
  end

  def form_type
    online? ? :online : :offline
  end
end
