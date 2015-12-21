class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :group, index: true
      t.references :created_user, index: true
      t.string :title
      t.integer :user_number_sum

      t.timestamps null: false
    end
  end
end
