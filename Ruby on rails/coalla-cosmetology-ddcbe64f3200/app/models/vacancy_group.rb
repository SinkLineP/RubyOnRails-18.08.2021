# == Schema Information
#
# Table name: vacancy_groups
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  created_at :datetime
#  updated_at :datetime
#

class VacancyGroup < ActiveRecord::Base
  has_many :vacancies, ->{ordered}, inverse_of: :vacancy_group, dependent: :destroy

  accepts_nested_attributes_for :vacancies, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
end
