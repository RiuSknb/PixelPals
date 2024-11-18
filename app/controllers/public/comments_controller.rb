class Public::CommentsController < ApplicationController
  def create
    @event = Event.find(params[:event_id]) # コメント対象のイベントを取得
    @comment = @event.comments.new(comment_params) # コメントをイベントに関連付け
    @comment.user = current_user # コメントしたユーザーを設定
  
    if @comment.save
      redirect_to event_path(@event), notice: 'コメントを投稿しました。'
    else
      flash[:alert] = @comment.errors.full_messages.join(", ")
      redirect_to event_path(@event)
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.update(is_deleted: true, deleted_by: current_user.name, deleted_reason: "ユーザーにより削除")
      redirect_to @comment.commentable, notice: 'コメントが削除されました。'
    else
      redirect_to @comment.commentable, alert: '削除権限がありません。'
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
