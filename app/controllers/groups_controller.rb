class GroupsController < ApplicationController
  before_action :logged_in_user

  def new
    @group = Group.new
  end
  
  # サインアップ画面でのユーザー登録
  def create
    @user = User.new(create_group_params)
    if @group.save
      #TODO リダイレクト先検討
      redirect_to root_path, notice: "グループ登録が完了しました"
    else
      render 'new'
    end
  end
  
  def create_group_params
    params.require(:group).permit(:name)
  end
end
