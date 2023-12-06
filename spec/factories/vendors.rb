FactoryBot.define do
  factory :vendor do
    name { Faker::Name.name }
    description { Faker::Address.street_address }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end