# == Schema Information
#
# Table name: square_banners
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE), not null
#  desktop_text :text             not null
#  mobile_text  :text             not null
#  image        :text
#  mobile_image :text
#  btn_title    :text
#  link         :text
#  shop_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_square_banners_on_shop_id  (shop_id)
#

class SquareBanner < ActiveRecord::Base

  mount_uploader :image, SquareBannerImageUploader
  mount_uploader :mobile_image, SquareBannerMobileImageUploader

  has_many :blog_square_banners, -> { order(:position) }, inverse_of: :square_banner, dependent: :destroy
  has_many :articles, through: :blog_square_banners

  with_options(presence: true) do
    validates :desktop_text
    validates :mobile_text
    validates :image
    validates :mobile_image
  end

  scope :ordered, -> { order(created_at: :desc) }
  scope :active, -> { where(active: true) }

  def article_ids=(article_ids = [])
    article_ids.each_with_index do |id, index|
      blog_square_banners.find_by(article_id: id).try(:update_column, :position, index + 1)
    end
    super
  end

end
