class CreateSubscribers < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribers do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :subscribers, :created_at
    add_index :subscribers, :updated_at
  end
end
