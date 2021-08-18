class AddVerificationTutorial < ActiveRecord::Migration
  def up
    Lookup.create!(code: :verification_tutorial, value: '', type_code: :string)
  end

  def down
    Lookup.where(code: :verification_tutorial).delete_all
  end
end
