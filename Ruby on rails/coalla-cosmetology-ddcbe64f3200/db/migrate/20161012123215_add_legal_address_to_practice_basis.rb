class AddLegalAddressToPracticeBasis < ActiveRecord::Migration
  def change
    add_column :practice_bases, :legal_address, :text
  end
end
