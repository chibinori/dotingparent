class AddIsActiveToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :is_active, :boolean, default: false, null: false
  end
end
