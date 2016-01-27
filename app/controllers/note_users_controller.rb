class NoteUsersController < ApplicationController
  before_action :group_identified_user

  def create
    #binding.pry
    
    ActiveRecord::Base.transaction do
      @note = current_group.notes.find(params[:note_id])
      @related_user = User.find(params[:related_user_id])
      @related_user.regist_related_note(@note)
      group_user = current_group.group_users.find_by(user_id: @related_user.id)
      @note.user_number_sum = @note.user_number_sum | group_user.user_number
      @note.save!
    end
  end

  def destroy
    #binding.pry
    
    ActiveRecord::Base.transaction do
      related_note_user = NoteUser.find(params[:id])
      @note = related_note_user.note
      @related_user = related_note_user.user
      @related_user.release_related_note(@note)
      group_user = current_group.group_users.find_by(user_id: @related_user.id)
      @note.user_number_sum = @note.user_number_sum & (~group_user.user_number)
      @note.save!
    end
  end
end
