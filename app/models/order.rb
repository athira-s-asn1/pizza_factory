class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  validates :status, presence: true

  def total_price
    order_items.sum(:price)
  end
end
