FactoryGirl.define do
  factory :student do
    email { Faker::Internet.email }
    password { Faker::Internet.password(Devise.password_length.first) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
