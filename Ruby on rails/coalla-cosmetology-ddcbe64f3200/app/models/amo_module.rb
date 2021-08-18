# == Schema Information
#
# Table name: amo_modules
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AmoModule < ActiveRecord::Base
  has_many :amo_module_courses, -> { order(:position) }, inverse_of: :amo_module, dependent: :destroy
  has_many :courses, through: :amo_module_courses
  has_many :group_subscriptions, inverse_of: :amo_module, dependent: :nullify
  has_many :module_groups, inverse_of: :amo_module, dependent: :destroy

  validates :title, presence: true

  scope :ordered, -> { order(:title) }
end
