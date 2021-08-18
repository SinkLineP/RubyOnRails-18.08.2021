# frozen_string_literal: true

# == Schema Information
#
# Table name: instructor_homes
#
#  id            :integer          not null, primary key
#  description   :text
#  active        :boolean          default(FALSE), not null
#  instructor_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# frozen_string_literal: true

class InstructorHome < ActiveRecord::Base
  attr_accessor :rows_count

  belongs_to :instructor

  validates :description, presence: true, if: proc { |inst| inst.active }
  validate :valid_cols_length, if: proc { |inst| inst.active }

  private

  def valid_cols_length
    if rows_count && rows_count.to_i > 5
      errors.add(:description, "Длина превышает 5 строк (#{rows_count} строк)")
    end
  end
end
