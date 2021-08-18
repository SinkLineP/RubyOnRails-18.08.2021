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

class Blog < Article
  extend SimpleIdsList

  has_many :blog_categories, inverse_of: :category, dependent: :destroy, foreign_key: :article_id
  has_many :categories, through: :blog_categories
  has_many :blog_courses, -> { order(:position) }, inverse_of: :course, dependent: :destroy, foreign_key: :article_id
  has_many :courses, through: :blog_courses

  scope :with_category, ->(category_id) { joins(:blog_categories).where(blog_categories: { category_id: category_id }).uniq }
  scope :by_date_range, ->(date_start, date_end) { where(created_at: date_start..date_end) }

  accepts_nested_attributes_for :blog_categories, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :blog_courses, allow_destroy: true

  simple_ids_list :courses

  def self.dates
    @dates ||= published.pluck("DISTINCT date_trunc('month', created_at at TIME ZONE '#{Time.zone.formatted_offset}')").sort
  end
end
