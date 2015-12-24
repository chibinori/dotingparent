class AddUserNumberSumIndexToNotes < ActiveRecord::Migration
  def change
    add_index :notes, [:group_id, :created_at, :user_number_sum]
  end
end
