class CreateShoppingcarts < ActiveRecord::Migration[6.0]
  def change
    create_table :shoppingcarts do |t|

      t.timestamps
    end
  end
end
