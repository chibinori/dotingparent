class AddFamilyRelationToGroupUsers < ActiveRecord::Migration
  def change
    add_column :group_users, :family_relation, :string
  end
end
