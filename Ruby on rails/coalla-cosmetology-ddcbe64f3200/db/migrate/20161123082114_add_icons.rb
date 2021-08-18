class AddIcons < ActiveRecord::Migration
  def up
    Advantage.destroy_all
    %w(bag book check doc-gerb doc-plus doctor dov-shtamp group guarantee hypodermic light people uniform).each do |icon_name|
      Advantage.create!(title: icon_name, icon: icon_name)
    end
  end

  def down
    Advantage.destroy_all
  end
end
