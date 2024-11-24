class Public::GroupsController < ApplicationController
  before_action :set_group, only: %i[show destroy]

  def new
    @group = Group.new
  end

  def index
    @groups = Group.where(is_public: true).or(Group.where(owner_id: current_user.id))
  end

  def show
    @group = Group.find(params[:id])
    @user = User.find(params[:id])
  end

  def create
    @group = current_user.groups.build(group_params)
    @group.owner = current_user
    if @group.save
      GroupMember.create(group: @group, user: current_user, role: 0, status: 1)
      redirect_to @group, notice: "グループを作成しました。"
    else
      render :new
    end
  end

  def update
  end

  def destroy
    # グループの開設者のみが削除できるように
    if @group.owner_id == current_user.id
      @group.destroy
      redirect_to groups_path, notice: 'グループを削除しました。'
    else
      redirect_to @group, alert: 'グループの削除権限がありません。'
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :is_public)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
