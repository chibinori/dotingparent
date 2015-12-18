class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :current_user_number

      t.timestamps null: false
    end
  end
end
