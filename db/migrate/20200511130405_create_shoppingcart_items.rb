class CreateShoppingcartItems < ActiveRecord::Migration[6.0]
  def change
    create_table :shoppingcart_items do |t|
      t.belongs_to :shoppingcart, null: false, foreign_key: true
      t.belongs_to :menu, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
