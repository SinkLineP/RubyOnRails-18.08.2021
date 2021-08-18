class AddLookupFromAdminEmail < ActiveRecord::Migration
  def change
    Lookup.create!(code: :admin_email, value: 'dev@coalla.ru', type_code: :string)
  end
end
