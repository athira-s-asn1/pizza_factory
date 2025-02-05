# spec/factories/toppings.rb
FactoryBot.define do
  factory :topping do
    name { "Extra Cheese" }
    price { 2.00 }
    category { "non_vegetarian" }     
  end
end
  