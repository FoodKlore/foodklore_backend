class AddBusinessToMenu < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :business_id, :integer
    add_foreign_key :menus, :businesses
  end
end
