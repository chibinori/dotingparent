class PhotoCommentsController < ApplicationController
  before_action :group_identified_user

  def create

    @photo = Photo.find(params[:photo_id])

    ActiveRecord::Base.transaction do
      comment = params.require(:photo_comment).permit(:comment)[:comment]
      if comment.present?
        @photo_comment = current_user.photo_comments.find_or_create_by(photo_id: @photo.id)
        @photo_comment.comment = comment
        @photo_comment.save!
      else
        return head :created
      end
    end
  end

  def destroy
  end
end
