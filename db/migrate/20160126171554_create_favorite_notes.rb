class CreateFavoriteNotes < ActiveRecord::Migration
  def change
    create_table :favorite_notes do |t|
      t.references :note, index: true
      t.references :user, index: true

      t.timestamps null: false
      
      t.index [:note_id, :user_id], unique: true
    end
  end
end
