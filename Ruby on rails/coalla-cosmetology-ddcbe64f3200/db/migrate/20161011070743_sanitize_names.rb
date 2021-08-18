class SanitizeNames < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.sanitize_name
      user.save
    end
  end

  def down
  end
end
