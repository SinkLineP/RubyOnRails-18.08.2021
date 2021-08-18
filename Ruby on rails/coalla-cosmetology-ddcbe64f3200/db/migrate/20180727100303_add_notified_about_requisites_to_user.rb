class AddNotifiedAboutRequisitesToUser < ActiveRecord::Migration
  def change
    add_column :users, :notified_about_requisites, :boolean, null: false, default: false
  end
end
