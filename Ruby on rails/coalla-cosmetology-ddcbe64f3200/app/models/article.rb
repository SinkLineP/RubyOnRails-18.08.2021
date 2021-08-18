# == Schema Information
#
# Table name: articles
#
#  id               :integer          not null, primary key
#  type             :text
#  title            :text
#  slug             :text
#  announce         :text
#  main_image       :text
#  main_image_title :text
#  preview_image    :text
#  preview_announce :text
#  content          :text
#  published        :boolean          default(FALSE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  tag_title        :text
#  tag_description  :text
#  shop_id          :integer
#  button_text      :text
#  button_link      :text
#  for_main         :boolean          default(FALSE), not null
#  button_type      :string
#
# Indexes
#
#  index_articles_on_shop_id  (shop_id)
#

class Article < ActiveRecord::Base
  extend FriendlyId
  extend SimpleIdsList

  friendly_id :title, use: [:slugged, :finders]

  mount_uploader :main_image, ArticleMainImageUploader
  mount_uploader :preview_image, ArticlePreviewImageUploader

  has_many :similar_articles, -> { order(:position) }, dependent: :destroy, inverse_of: :article
  has_many :similars, through: :similar_articles
  has_many :blog_square_banners, inverse_of: :article, dependent: :destroy
  has_many :square_banners, through: :blog_square_banners

  validates :title, :slug, :announce, :preview_image, :type, presence: true

  accepts_nested_attributes_for :similar_articles, allow_destroy: true

  simple_ids_list :similars, model: Article, through_association_name: :similar_articles

  scope :ordered, -> { order(:created_at) }
  scope :ordered_desc, -> { order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :for_main, -> { where(for_main: true) }
  scope :ordered_by_change_desc, -> { order(updated_at: :desc) }

  def should_generate_new_friendly_id?
    if !slug? || title_changed?
      true
    else
      false
    end
  end

  def blog?
    is_a?(Blog)
  end

  def mass_media?
    is_a?(MassMedia)
  end

  def science_and_drk?
    is_a?(ScienceAndDrk)
  end
end
