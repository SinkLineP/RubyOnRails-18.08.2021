# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_skills_on_name  (name) UNIQUE
#

class Skill < ActiveRecord::Base
  has_many :course_skills, dependent: :destroy, inverse_of: :skill
  has_many :courses, -> { uniq }, through: :course_skills

  after_save if: :changed? do
    courses.update_all(delta: true)
  end

  scope :alphabetical_order, -> { order(:name) }

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
