# == Schema Information
#
# Table name: faculties
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  shop_id    :integer
#
# Indexes
#
#  index_faculties_on_shop_id  (shop_id)
#

class Faculty < ActiveRecord::Base
  has_many :courses, dependent: :nullify, inverse_of: :faculty
  has_many :instructor_faculties, dependent: :destroy, inverse_of: :faculty
  has_many :graduate_faculties, inverse_of: :faculty, dependent: :destroy

  validates :title, presence: true

  scope :ordered, ->(){ order(:title) }
end
