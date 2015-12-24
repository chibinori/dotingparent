class CreateNoteUsers < ActiveRecord::Migration
  def change
    create_table :note_users do |t|
      t.references :note, index: true
      t.references :user, index: true

      t.timestamps null: false

      t.index [:note_id, :user_id], unique: true
    end
  end
end
