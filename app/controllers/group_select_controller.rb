class GroupSelectController < ApplicationController
  before_action :logged_in_user

  def list
    @groups = current_user.groups
    
    if !@groups.any?
      flash[:notice] = "所属するグループはありません。管理者に連絡して下さい。"
      redirect_to root_url
    end

    if @groups.count == 1
      session[:group_id] = @groups.first.id
      redirect_to request.referrer || root_url
    end

  end

  def confirm
    group_id = params[:group_select]
    session[:group_id] = group_id

    redirect_to request.referrer || root_url
  end


end
