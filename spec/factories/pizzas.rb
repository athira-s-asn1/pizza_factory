# spec/factories/pizzas.rb
FactoryBot.define do
  factory :pizza do
    name { "Margherita" }
    category { "Vegetarian" }
  end
end
