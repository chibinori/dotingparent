class AddOwnerUserToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :owner_user
  end
end
