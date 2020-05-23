class Shoppingcart < ApplicationRecord
  has_many :shoppingcart_items
  has_many :orders
end
