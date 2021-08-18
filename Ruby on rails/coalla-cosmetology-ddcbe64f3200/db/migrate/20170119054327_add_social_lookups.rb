class AddSocialLookups < ActiveRecord::Migration
  def up
    Lookup.create!(code: :facebook_link, value: '', type_code: :string, category: :socials)
    Lookup.create!(code: :vkontakte_link, value: '', type_code: :string, category: :socials)
    Lookup.create!(code: :youtube_link, value: '', type_code: :string, category: :socials)
    Lookup.create!(code: :instagram_link, value: '', type_code: :string, category: :socials)
    Lookup.create!(code: :slideshare_link, value: '', type_code: :string, category: :socials)
  end

  def down
    Lookup.where(category: :socials).destroy_all
  end
end
