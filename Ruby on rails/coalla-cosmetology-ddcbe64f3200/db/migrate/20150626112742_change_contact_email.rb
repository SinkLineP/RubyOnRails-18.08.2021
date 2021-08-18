class ChangeContactEmail < ActiveRecord::Migration
  def change
    l = Lookup.find_by_code(:admin_email)
    l.value = 'info@cosmeticru.com'
    l.save!
  end
end
