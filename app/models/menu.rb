class Menu < ApplicationRecord
  has_many :ingredients
  belongs_to :business
  has_many :shoppingcart_items
end
