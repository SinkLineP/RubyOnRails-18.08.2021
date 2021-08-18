# == Schema Information
#
# Table name: curriculum_blocks
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  shop_id    :integer
#
# Indexes
#
#  index_curriculum_blocks_on_shop_id  (shop_id)
#

class CurriculumBlock < ActiveRecord::Base
  has_many :course_curriculum_blocks, dependent: :destroy, inverse_of: :curriculum_block
  has_many :courses, ->{ uniq }, through: :course_curriculum_blocks

  scope :alphabetical_order, -> { order(:title) }

  after_save if: :changed? do
    courses.update_all(delta: true)
  end

  validates_presence_of :title

  def items
    return [] if content.blank?

    result = []
    result_item = nil

    content.each_line do |line|
      str_line = line.strip.squish

      if str_line.blank?
        result_item = nil
        next
      end

      if result_item
        result_item.items << OpenStruct.new(title: str_line)
      else
        result_item = OpenStruct.new(title: str_line, items: [])
        result << result_item
      end
    end

    result
  end
end
