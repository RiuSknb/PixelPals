class Public::GroupMessagesController < ApplicationController
  before_action :set_group

  def index
    @group_messages = @group.group_messages.includes(:user) # グループ内のメッセージを取得
  end

  def create
    @group_message = @group.group_messages.new(group_message_params)
    @group_message.user = current_user
    if @group_message.save
      redirect_to group_group_messages_path(@group), notice: "メッセージを送信しました。"
    else
      render :index, alert: "メッセージの送信に失敗しました。"
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id]) # ネストされたgroup_idを取得
  end

  def message_params
    params.require(:group_message).permit(:content) # 必要なパラメータのみ許可
  end
end
