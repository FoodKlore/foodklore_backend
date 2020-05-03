class MakeEmailUniques < ActiveRecord::Migration[6.0]
  def change
    add_index :subscribers, :email, unique: true
  end
end
