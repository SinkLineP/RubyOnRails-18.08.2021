class AddPositionToVacancy < ActiveRecord::Migration
  def change
    add_column :vacancies, :position, :integer, default: 0
  end
end
