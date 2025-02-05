class Inventory < ApplicationRecord
  validates :item_name, :quantity, presence: true
end
