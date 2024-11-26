class Admin::GroupsController < Admin::BaseController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @game = Game.find(@group.game_id)
    @genre = Genre.find(@game.genre_id)

    if @group.nil?
      redirect_to admin_groups_path, alert: "グループが見つかりませんでした"
    else
      # 追加のロジック
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def deactivate
    @group = Group.find(params[:id])
    
    if @group.update(is_deleted: true)
      redirect_to admin_group_path(@group), notice: 'グループが無効化されました（論理削除）。'
    else
      redirect_to admin_group_path(@group), alert: 'グループの削除に失敗しました。'
    end
  end

  def activate
    @group = Group.find(params[:id])

    if @group.update(is_deleted: false)
      redirect_to admin_group_path(@group), notice: 'グループが有効化されました。'
    else
      redirect_to admin_group_path(@group), alert: 'グループの有効化に失敗しました。'
    end
  end
end
