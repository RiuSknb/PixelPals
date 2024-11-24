class Public::GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :authorize_group_admin!, only: [:create, :update, :destroy]

  def new
  end

  def index
  end

  def show
  end

  def create
    @user = User.find(params[:user_id])

    if @group.group_members.exists?(user_id: @user.id)
      redirect_to group_path(@group), alert: 'このユーザーは既にグループに加入しています。'
      return
    end

    group_member = @group.group_members.new(user: @user, status: 4, role: 2)
    if group_member.save
      redirect_to group_path(@group), notice: "#{@user.name} さんをグループに招待しました。"
    else
      redirect_to group_path(@group), alert: "招待に失敗しました。"
    end
  end

  def update
    group_member = @group.group_members.find(params[:id])
    if group_member.update(status: 1)
      redirect_to group_path(@group), notice: "メンバーの承認が完了しました。"
    else
      redirect_to group_path(@group), alert: "承認に失敗しました。"
    end
  end

  def destroy
    group_member = @group.group_members.find(params[:id])
    if group_member.destroy
      redirect_to group_path(@group), notice: "メンバーを削除しました。"
    else
      redirect_to group_path(@group), alert: "削除に失敗しました。"
    end
  end

  private
  
  def set_group
    @group = Group.find(params[:group_id])
  end

  def authorize_group_admin!
    unless @group.owner == current_user || @group.group_members.find_by(user: current_user)&.role == "moderator"
      redirect_to group_path(@group), alert: "この操作を行う権限がありません。"
    end
  end

end
