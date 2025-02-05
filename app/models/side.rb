class Side < ApplicationRecord
  has_many :order_items
  validates :name, :price, presence: true
end
