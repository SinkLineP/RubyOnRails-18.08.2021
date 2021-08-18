class AddMoreAdvantages < ActiveRecord::Migration
  def up
    %w(internet diploma).each do |icon_name|
      Advantage.create!(title: icon_name, icon: icon_name)
    end
  end

  def down
    Advantage.where(title: %w(advantage diploma)).destroy_all
  end
end
