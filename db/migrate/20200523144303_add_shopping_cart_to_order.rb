class AddShoppingCartToOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :shoppingcart, foreign_key: true
  end
end
