# == Schema Information
#
# Table name: classrooms
#
#  id          :integer          not null, primary key
#  title       :text             not null
#  capacity    :integer          default(0), not null
#  external_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Classroom < ActiveRecord::Base
  has_many :work_classrooms, -> { order(:created_at) }, dependent: :destroy, inverse_of: :classroom
  has_many :works, through: :work_classrooms
  has_many :schedule_items, dependent: :nullify, inverse_of: :classroom

  with_options presence: true do
    validates :title
    validates :capacity,
              numericality: {
                allow_blank: true,
                greater_than: 0,
                only_integer: true
              }
  end
  validate :validate_duplicated_works

  accepts_nested_attributes_for :work_classrooms, allow_destroy: true

  scope :ordered, -> { order(:title) }

  def number
    title.to_s[/\d+/].to_i
  end

  def correct_title
    title.mb_chars.strip.squish
  end

  private

  def validate_duplicated_works
    works_ids = work_classrooms.reject(&:marked_for_destruction?).map(&:work_id).compact
    errors.add(:base, 'Занятия не должны повторяться') if works_ids.size != works_ids.uniq.size
  end
end
