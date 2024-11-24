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
    Rails.logger.debug "PARAMS: #{params.inspect}"
    Rails.logger.debug "ROLE KEY: #{params[:group_member].key?(:role)}"
    Rails.logger.debug "STATUS KEY: #{params[:group_member].key?(:status)}"
    Rails.logger.debug "PARAMS: #{params.inspect}"
    Rails.logger.debug "STATUS: #{params[:group_member][:status]}"

    group_member = @group.group_members.find(params[:id])
  
    # 開設者がメンバーの役割を変更する場合
    if params[:group_member].key?(:role) && @group.owner_id == current_user.id
      if group_member.update(role_params)
        redirect_to group_path(@group), notice: "メンバーの役割が変更されました。"
      else
        redirect_to group_path(@group), alert: "役割の変更に失敗しました。"
      end
    # ステータス変更（例: 承認）
    elsif params[:group_member].key?(:status)
      if group_member.update(status: params[:group_member][:status])
        redirect_to group_path(@group), notice: "メンバーの承認が完了しました。"
      else
        redirect_to group_path(@group), alert: "承認に失敗しました。"
      end
    else
      redirect_to group_path(@group), alert: "不正なパラメータが送信されました。"
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

  def leave
    group_member = @group.group_members.find_by(user_id: current_user.id)
    if group_member&.destroy
      redirect_to groups_path, notice: "グループから退出しました。"
    else
      redirect_to group_path(@group), alert: "退出に失敗しました。"
    end
  end

  private
  
  def set_group
    @group = Group.find(params[:group_id])
  end

  def authorize_group_admin!
    unless @group.owner == current_user || @group.group_members.find_by(user: current_user)&.role == "モデレーター"
      redirect_to group_path(@group), alert: "この操作を行う権限がありません。"
    end
  end

  def role_params
    params.require(:group_member).permit(:role)
  end

end
