class ShoppingcartItem < ApplicationRecord
  belongs_to :shoppingcart
  belongs_to :menu
end
