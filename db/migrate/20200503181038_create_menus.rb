class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus do |t|
      t.text :name
      t.text :description
      t.text :img
      t.float :total

      t.timestamps
    end
    add_index :menus, :name
  end
end
