class AddUserAndGuestTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_token, :string
    add_column :guests, :guest_token, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
