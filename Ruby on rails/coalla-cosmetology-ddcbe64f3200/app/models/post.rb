# == Schema Information
#
# Table name: posts
#
#  id                 :integer          not null, primary key
#  title              :text
#  announcement       :text
#  text               :text
#  published          :boolean          default(FALSE), not null
#  created_at         :datetime
#  updated_at         :datetime
#  announcement_image :text
#  impressions_count  :integer          default(0), not null
#  slug               :text
#  slider_image       :text
#  notified           :boolean          default(FALSE), not null
#  delta              :boolean          default(TRUE), not null
#  inner_image        :text
#  shop_id            :integer
#
# Indexes
#
#  index_posts_on_shop_id  (shop_id)
#

class Post < ActiveRecord::Base
  FILTER_VALUES = %w(newest popular in_january in_february in_march in_april in_may in_june in_july in_august in_september in_october in_november in_december)

  extend FriendlyId

  LAST_MONTHS_COUNT = 3
  SLIDES_COUNT = 3

  friendly_id :title, use: [:slugged, :finders]

  is_impressionable counter_cache: true

  has_one :post_category_link, inverse_of: :post
  has_one :category, through: :post_category_link, source: :post_category, class_name: :PostCategory

  alias_attribute :name, :title

  validates_presence_of :title, :announcement, :text, :category, :announcement_image, :slider_image, :inner_image

  scope :published, ->() { where(published: true) }
  scope :admin_ordered, -> { order(created_at: :desc) }
  scope :published_before, ->(post) { published.newest.where('posts.created_at < ?', post.created_at) }
  scope :published_after, ->(post) { published.newest.where('posts.created_at > ?', post.created_at) }

  #
  # for filter
  scope :newest, -> { order(created_at: :desc) }
  scope :popular, -> { order(impressions_count: :desc) }

  Date::MONTHNAMES.reject(&:nil?).each do |month_name|
    scope "in_#{month_name.downcase}", -> do
      month_number = Date::MONTHNAMES.index(month_name)
      year = LAST_MONTHS_COUNT > Date.today.month ? Date.today.year - 1 : Date.today.year
      date = Date.new(year, month_number)
      where(created_at: [date.beginning_of_month..date.end_of_month]).newest
    end
  end
  # for filter
  #

  after_save :notify_blog_subscribers, if: :notify_blog_subscribers?

  mount_uploader :announcement_image, PostAnnouncementImageUploader
  mount_uploader :slider_image, PostSliderImageUploader
  mount_uploader :inner_image, PostInnerImageUploader

  alias_attribute :search_content, :title

  def self.slides
    published.newest.limit(SLIDES_COUNT)
  end

  def category_title
    category.try(:title)
  end

  def category_title=(value)
    return if value.blank?
    self.category = PostCategory.find_or_initialize_by(title: value.mb_chars.strip.squish.downcase)
  end

  def unpublished?
    !published?
  end

  def publish
    self.published = true
  end

  def withdraw
    self.published = false
  end

  def should_generate_new_friendly_id?
    if !slug? || title_changed?
      true
    else
      false
    end
  end

  def reading_time
    @reading_time ||= ReadingTimeCalculator.calculate(text)
  end

  def related_post
    @related_article ||= load_related_post
  end

  def notify_blog_subscribers
    Delayed::Job.enqueue NotifyBlogSubscribers.new(id)
    update_column(:notified, true)
  end

  private

  def load_related_post
    return [] if category.blank?
    common_scope = Post.published.joins(:category).where('post_categories.id = ?', category.id)
    common_scope.published_before(self).first || common_scope.published_after(self).first
  end

  def notify_blog_subscribers?
    published_changed? && published? && !notified?
  end

end
