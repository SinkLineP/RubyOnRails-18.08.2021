# == Schema Information
#
# Table name: banners
#
#  id           :integer          not null, primary key
#  type_banner  :text
#  description  :text             not null
#  image        :text             not null
#  btn_title    :text
#  link_call    :text
#  active       :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  mobile_text  :text
#  mobile_image :text
#  shop_id      :integer
#
# Indexes
#
#  index_banners_on_shop_id  (shop_id)
#

class Banner < ActiveRecord::Base
  extend Enumerize

  enumerize :type_banner, in: %i(call registration without_phone), default: :call, predicates: true

  mount_uploader :image, BannerImageUploader
  mount_uploader :mobile_image, BannerMobileImageUploader

  with_options(presence: true) do
    validates :description
    validates :image
    validates :mobile_image
  end

  with_options(if: :call?,presence: true) do
    validates :btn_title
    validates :link_call
  end

  scope :ordered, -> { order(created_at: :desc) }
  scope :active, -> { where(active: true) }
  scope :call2actions, -> { active.where(type_banner: :call) }
  scope :registrations, -> { active.where(type_banner: :registration) }
  scope :without_phones, -> { active.where(type_banner: [:without_phone, :call]) }

  class << self
    def lucky_call(without_phone = false)
      scope = Banner.all
      scope = without_phone ? scope.without_phones : scope.call2actions
      offset = rand(scope.count)
      scope.offset(offset).first
    end

    def lucky_registration
      offset = rand(Banner.registrations.count)
      Banner.registrations.offset(offset).first
    end
  end

  def call?
    type_banner == :call
  end
end
