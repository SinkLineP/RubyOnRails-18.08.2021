class AddConsultationReferencesToUsedTime < ActiveRecord::Migration
  def change
    add_reference :used_times, :consultation, index: true, foreign_key: true
    add_index :used_times, [:date, :time], unique: true
  end
end
