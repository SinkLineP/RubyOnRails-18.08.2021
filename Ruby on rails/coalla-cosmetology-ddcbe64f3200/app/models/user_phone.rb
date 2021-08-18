# == Schema Information
#
# Table name: user_phones
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  number     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserPhone < ActiveRecord::Base
  belongs_to :user, class_name: "user", foreign_key: "user_id"
  before_validation :number_sanitizer
  after_save :remove_blank_numbers

  validates :number, presence: true,
                     numericality: true,
                     length: { minimum: 10, maximum: 15 },
                     uniqueness: true

  def remove_blank_numbers
    self.class.destroy(id) if self.number.blank?
  end

  def number_sanitizer
    self.number = self.number.gsub(/[^0-9]/, '')
  end
end
