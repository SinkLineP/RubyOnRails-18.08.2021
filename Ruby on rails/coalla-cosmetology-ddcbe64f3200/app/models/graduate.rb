# == Schema Information
#
# Table name: graduates
#
#  id          :integer          not null, primary key
#  name        :text
#  description :text
#  avatar      :text
#  created_at  :datetime
#  updated_at  :datetime
#  shop_id     :integer
#
# Indexes
#
#  index_graduates_on_shop_id  (shop_id)
#

class Graduate < ActiveRecord::Base
  mount_uploader :avatar, GraduateAvatarUploader

  has_many :graduate_faculties, inverse_of: :graduate, dependent: :destroy
  has_many :faculties, through: :graduate_faculties

  validates :name, presence: true

  scope :ordered, -> { order(:created_at) }
end
