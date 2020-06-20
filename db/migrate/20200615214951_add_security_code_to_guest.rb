class AddSecurityCodeToGuest < ActiveRecord::Migration[6.0]
  def change
    add_column :guests, :security_code_digest, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
