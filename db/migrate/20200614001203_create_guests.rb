class CreateGuests < ActiveRecord::Migration[6.0]
  def change
    create_table :guests do |t|
      t.string :email
      t.boolean :authenticated
      t.string :name

      t.timestamps
    end
  end
end
