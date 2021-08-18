# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  title      :text
#  price      :string
#  units      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Service < ActiveRecord::Base
  extend Enumerize

  enumerize :units, in: [:rub, :rub_per_meter, :rub_per_month], default: :rub

  validates :title, :price, presence: true

  scope :ordered, ->{ order(:created_at)}
end
