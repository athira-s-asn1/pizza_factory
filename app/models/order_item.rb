class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :pizza, optional: true
  belongs_to :side, optional: true
end
