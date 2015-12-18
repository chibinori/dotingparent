class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :group, index: true
      t.references :user, index: true
      t.integer :user_number

      t.timestamps null: false
      
      t.index [:group_id, :user_id], unique: true
    end
  end
end
