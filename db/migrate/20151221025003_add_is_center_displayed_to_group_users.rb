class AddIsCenterDisplayedToGroupUsers < ActiveRecord::Migration
  def change
    add_column :group_users, :is_center_displayed, :boolean
  end
end
