# == Schema Information
#
# Table name: advantages
#
#  id         :integer          not null, primary key
#  title      :text
#  icon       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Advantage < ActiveRecord::Base
  has_many :course_advantages, dependent: :destroy, inverse_of: :advantage
  has_many :courses, ->{ uniq }, through: :course_advantages

  scope :alphabetical_order, -> { order(:title) }

  validates_presence_of :title, :icon
end
