class AddActiveToSubscribers < ActiveRecord::Migration[6.0]
  def up
    add_column :subscribers, :active, :boolean
  end

  def down
    remove_column :subscribers, :active, :boolean
  end
end
