class CreateUserPhones < ActiveRecord::Migration
  def up
    create_table :user_phones do |t|
      t.references :user
      t.string :number
      t.timestamps null: false
    end

    User.where.not(phones: "{}").each do |user|
      user.phones.each do |phone|
        next if phone.length > 15
        phone = PhoneSanitizer.sanitize(phone)
        phone = "7#{phone}" if phone.length == 10
        user.user_phones << UserPhone.new(number: phone)
        user.save(validate: false)
      end 
    end
  end

  def down
    drop_table :user_phones
  end
end
