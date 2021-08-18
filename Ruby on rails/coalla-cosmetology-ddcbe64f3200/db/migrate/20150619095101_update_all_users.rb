class UpdateAllUsers < ActiveRecord::Migration
  def up
    User.where(type: nil).update_all(type: 'Student')
  end

  def down
    User.where(type: 'Student').update_all(type: nil)
  end
end
