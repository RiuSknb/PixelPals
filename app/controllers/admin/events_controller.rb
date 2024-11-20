class Admin::EventsController < Admin::BaseController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comments
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to admin_event_path(@event), notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    # 削除理由が送信されている場合のみ処理を実行
    if params[:reason].present?
      if @event.update(is_deleted: true, deleted_reason: params[:reason])
        redirect_to admin_event_path(@comment.commentable), notice: 'コメントが削除されました。'
      else
        redirect_to admin_event_path(@comment.commentable), alert: 'コメントの削除に失敗しました。'
      end
    else
      redirect_to admin_event_path(@comment.commentable), alert: '削除理由を入力してください。'
    end
  end

  private
  
  def event_params
    params.require(:event).permit(:title, :body, :place, :date, :user_id, :game_id, :genre_id, :group_id)
  end

end
