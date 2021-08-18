# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  active     :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  delta      :boolean          default(TRUE), not null
#  cloned     :boolean          default(FALSE), not null
#  shop_id    :integer
#  course_id  :integer
#
# Indexes
#
#  index_blocks_on_active   (active)
#  index_blocks_on_name     (name)
#  index_blocks_on_shop_id  (shop_id)
#

class Block < ActiveRecord::Base
  include DeepDup

  attribute :course_id, Type::Integer.new

  alias_attribute :search_content, :name

  has_many :course_blocks, -> { order(:position) }, inverse_of: :block, dependent: :destroy
  has_many :courses, through: :course_blocks
  has_many :lectures, -> { order(:position) }, dependent: :destroy, inverse_of: :block

  accepts_nested_attributes_for :lectures, allow_destroy: true

  validates :name, presence: true

  after_create do
    course_blocks.create!(course: course) if attribute_present?(:course_id)
  end

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  def course
    Course.find(course_id) if attribute_present?(:course_id) && course_id > 0
  end

  def display_name
    "(#{active ? 'А' : 'Н'})#{name}"
  end

  def to_backbone
    as_json(only: %i(id name active course_id), methods: %i(editable))
  end

  def lectures_attributes=(lectures_attributes)
    lectures_attributes ||= []
    lectures.each do |lecture|
      unless lectures_attributes.any? { |lecture_attributes| lecture_attributes[:id] == lecture.id }
        lectures_attributes << {
            id: lecture.id,
            '_destroy' => true
        }
      end
    end
    super
  end

  def time
    @hours ||= lectures.sum(:time) || 0
  end

  def deep_dup
    result = super(associations: [:lectures])
    result.cloned = true
    result
  end

  def editable
    @has_results ||= (lectures.blank? || lectures.all?(&:editable))
  end

end
