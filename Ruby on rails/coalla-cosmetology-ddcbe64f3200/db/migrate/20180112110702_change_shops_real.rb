class ChangeShopsReal < ActiveRecord::Migration
  def up
    if column_exists?(:shops, :subdomain)
      rename_column :shops, :subdomain, :code
    end
  end

  def down
    if column_exists?(:shops, :code)
      rename_column :shops, :code, :subdomain
    end
  end
end