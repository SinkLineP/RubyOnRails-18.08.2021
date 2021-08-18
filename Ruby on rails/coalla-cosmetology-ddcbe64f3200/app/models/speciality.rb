# == Schema Information
#
# Table name: specialities
#
#  id                  :integer          not null, primary key
#  title               :text
#  description         :text
#  parent_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  slug                :text             not null
#  announcement        :text
#  icon                :string
#  meta_title          :text
#  meta_description    :text
#  genitive_form       :text
#  shop_id             :integer
#  page_title          :text
#  meta_og_title       :text
#  meta_og_description :text
#  show_on_site        :boolean          default(TRUE), not null
#  for_main            :boolean          default(TRUE), not null
#  level               :integer          default(0), not null
#  block1              :text
#  header2             :text
#  block2              :text
#
# Indexes
#
#  index_specialities_on_parent_id  (parent_id)
#  index_specialities_on_shop_id    (shop_id)
#

class Speciality < ActiveRecord::Base
  extend FriendlyId
  include WithFriendly

  friendly_id :full_title, use: [:slugged, :finders]

  belongs_to :parent, inverse_of: :children, class_name: :Speciality
  has_many :children,
           inverse_of: :parent,
           class_name: :Speciality,
           foreign_key: :parent_id,
           dependent: :destroy
  has_many :course_specialities, dependent: :destroy, inverse_of: :speciality
  has_many :courses, through: :course_specialities
  has_many :children_courses, -> { uniq }, through: :children, source: :courses

  validates :title, presence: true

  scope :alphabetical_order, -> { order(:title) }
  scope :ordered, -> { order(:created_at) }
  scope :root, -> { where(parent_id: nil) }
  scope :sub_specialities, -> { where.not(parent_id: nil) }
  scope :visible, -> { where(show_on_site: true) }
  scope :for_main, -> { where(for_main: true) }
  scope :level, -> { order(level: :asc) }

  def all_courses
    @all_courses ||= (root? ? children_courses : courses).includes(:nearest_group).displayed
  end

  def display_title
    [title, description].reject(&:blank?).join(",\s")
  end

  def full_title
    result = display_title
    [parent.try(:title), result].reject(&:blank?).join(": ")
  end

  def root?
    parent_id.blank?
  end

  def any_seos_present?
    block1.present? || header2.present? || block2.present?
  end
end
