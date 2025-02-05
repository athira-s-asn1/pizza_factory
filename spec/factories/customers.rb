# spec/factories/customers.rb
FactoryBot.define do
  factory :customer do
    name { "John Doe" }
    email { "john.doe@example.com" }
    phone { "99999999" }
  end
end
  