# == Schema Information
#
# Table name: static_pages
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  content    :text
#  slug       :text             not null
#  permanent  :boolean          default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_static_pages_on_slug  (slug) UNIQUE
#


class StaticPage < ActiveRecord::Base
  extend FriendlyId

  friendly_id :slug_candidates, use: [:slugged, :finders]

  validates :title, presence: true
  validates :slug, uniqueness: true

  scope :ordered, -> { order(created_at: :desc) }

  def slug_candidates
    [ :title,  [:title, :id] ]
  end

  def should_generate_new_friendly_id?
    new_record? ? slug.blank? : (!slug? || title_changed?)
  end
end
