class Topping < ApplicationRecord
  validates :name, :category, :price, presence: true
end
