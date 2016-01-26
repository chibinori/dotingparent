class FavoriteNotesController < ApplicationController
  before_action :group_identified_user

  def create
    #binding.pry
    
    @note = current_group.notes.find(params[:note_id])
    current_user.regist_favorite_note(@note)
  end

  def destroy
    #binding.pry
    
    @note = current_user.favorite_note_relations.find(params[:id]).note
    current_user.release_favorite_note(@note)
  end
end
