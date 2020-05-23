class Order < ApplicationRecord
  belongs_to :order_status
  has_one :shoppingcart
end
