# == Schema Information
#
# Table name: finished_materials
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  material_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_finished_materials_on_material_id                 (material_id)
#  index_finished_materials_on_student_id                  (student_id)
#  index_finished_materials_on_student_id_and_material_id  (student_id,material_id) UNIQUE
#


class FinishedMaterial < ActiveRecord::Base
  belongs_to :student, inverse_of: :finished_materials
  belongs_to :material, inverse_of: :finished_materials

  validates :student_id, uniqueness: { scope: :material_id }
end
