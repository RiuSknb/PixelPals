class Public::GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  # before_action :authorize_group_admin!, only: [:create, :update, :destroy]

  def new
  end

  def index
  end

  def show
  end

  def create
    @group = Group.find(params[:group_id]) # グループを取得
  
    if params[:user_id].to_i == current_user.id
      # 非加入者が加入申請を行う処理
      if @group.group_members.exists?(user_id: current_user.id)
        redirect_to group_path(@group), alert: '既にこのグループに加入しています。'
        return
      end
  
      group_member = @group.group_members.new(user: current_user, status: 0, role: 2) # 承認待ち
      if group_member.save
        redirect_to group_path(@group), notice: 'グループ加入申請を送信しました。'
      else
        redirect_to group_path(@group), alert: 'グループ加入申請の送信に失敗しました。'
      end
    else
      # 管理者またはモデレーターが他のユーザーを招待する処理
      if @group.owner != current_user && @group.group_members.find_by(user: current_user).role != "モデレーター"
        redirect_to group_path(@group), alert: "この操作を行う権限がありません。"
        return
      end
  
      @user = User.find(params[:user_id])
  
      if @group.group_members.exists?(user_id: @user.id)
        redirect_to group_path(@group), alert: 'このユーザーは既にグループに加入しています。'
        return
      end
  
      group_member = @group.group_members.new(user: @user, status: 4, role: 3)
      if group_member.save
        redirect_to group_path(@group), notice: "#{@user.name} さんをグループに招待しました。"
      else
        redirect_to group_path(@group), alert: '招待に失敗しました。'
      end
    end
  end

  def update
    group_member = @group.group_members.find(params[:id])
  
    if params[:group_member].key?(:role) && @group.owner_id == current_user.id
      # 役割変更処理
      if group_member.update(role_params)
        redirect_to group_path(@group), notice: "メンバーの役割が変更されました。"
      else
        redirect_to group_path(@group), alert: "役割の変更に失敗しました。"
      end
    elsif params[:group_member].key?(:status)
      # ステータス変更処理（承認待ち、承認済みなど）
      if params[:group_member][:status] == "BAN"
        # ステータス変更時、BANが送信された場合、BAN処理を実行
        if group_member.update(status: "BAN")
          redirect_to group_path(@group), notice: "#{group_member.user.name} さんをBANしました。"
        else
          redirect_to group_path(@group), alert: "BAN処理に失敗しました。"
        end
      else
        # その他のステータス変更（承認など）
        if group_member.update(status: params[:group_member][:status])
          redirect_to group_path(@group), notice: "#{group_member.user.name} さんのステータスを変更しました。"
        else
          redirect_to group_path(@group), alert: "ステータスの変更に失敗しました。"
        end
      end
    else
      redirect_to group_path(@group), alert: "ステータス変更が無効です。"
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

    # ユーザーがグループを退出する
  def leave
    group_member = @group.group_members.find_by(user_id: current_user.id)
    if group_member&.destroy
      redirect_to groups_path, notice: "グループから退出しました。"
    else
      redirect_to group_path(@group), alert: "退出に失敗しました。"
    end
  end

  # ユーザーが招待を受け取る（statusを了承待ち→承認済み（参加）へ
  def accept_invitation
    # current_userがグループメンバーであることを確認
    @group_member = @group.group_members.find_by(user_id: current_user.id)
  
    if @group_member.nil?
      redirect_to group_path(@group), alert: "このグループに招待されていません。"
      return
    end
    # Rails.logger.debug "Group: #{@group.inspect}"  # @groupの内容
    # Rails.logger.debug "Group Member: #{@group_member.inspect}"  # @group_memberの内容
  
    if @group_member.status == '了承待ち'
      @group_member.update(status: '承認済み')  # ステータスを更新
      redirect_to group_path(@group), notice: "グループへ参加しました。"
    else
      redirect_to group_path(@group), alert: "この申請は承認待ちではありません。"
    end
  end

  private
  
  def set_group
    @group = Group.find(params[:group_id])
    Rails.logger.debug "Group: #{@group.inspect}"  # デバッグ用ログ
  end

  # def authorize_group_admin!
  #   unless @group.owner == current_user || @group.group_members.find_by(user: current_user)&.role == "モデレーター"
  #     redirect_to group_path(@group), alert: "この操作を行う権限がありません。"
  #   end
  # end
  def set_group_member
    @group_member = @group.group_members.find(params[:id])
    Rails.logger.debug "Group Member: #{@group_member.inspect}"
  end

  def role_params
    params.require(:group_member).permit(:role)
  end
end
