class CreateBusinesses < ActiveRecord::Migration[6.0]
  def change
    create_table :businesses do |t|
      t.text :business_name
      t.text :phone_number
      t.text :direction
      t.text :business_description
      t.text :img

      t.timestamps
    end
  end
end
