# == Schema Information
#
# Table name: vacancies
#
#  id               :integer          not null, primary key
#  name             :text             not null
#  content_type     :text             not null
#  content          :text
#  file             :text
#  vacancy_group_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#  position         :integer          default(0)
#
# Indexes
#
#  index_vacancies_on_vacancy_group_id  (vacancy_group_id)
#

class Vacancy < ActiveRecord::Base
  extend Enumerize

  belongs_to :vacancy_group, inverse_of: :vacancies
  enumerize :content_type, in: %i(pdf text), default: :text, predicates: true

  mount_uploader :file, PdfUploader

  validates_presence_of :name, :content_type

  scope :ordered, -> { order(:position) }
end
