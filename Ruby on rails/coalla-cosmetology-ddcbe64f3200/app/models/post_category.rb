# == Schema Information
#
# Table name: post_categories
#
#  id         :integer          not null, primary key
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :text
#
# Indexes
#
#  index_post_categories_on_title  (title) UNIQUE
#


class PostCategory < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: [:slugged, :finders]

  has_many :post_category_links, inverse_of: :post_category
  has_many :posts, through: :post_category_links

  alias_attribute :name, :title

  validates :title, presence: true

  scope :ordered_by_title, ->() { order(:title) }
  scope :with_posts, ->() { joins(:post_category_links).distinct }

  before_save do
    self.name = name.mb_chars.strip.squish.downcase
  end
end
