class Admin::CommentsController < Admin::BaseController
  def index
  end

  def show
  end

  def destroy
    @comment = Comment.find(params[:id])

    # 削除理由が送信されている場合のみ処理を実行
    if params[:reason].present?
      if @comment.update(is_deleted: true, deleted_reason: params[:reason])
        redirect_to admin_event_path(@comment.commentable), notice: 'コメントが削除されました。'
      else
        redirect_to admin_event_path(@comment.commentable), alert: 'コメントの削除に失敗しました。'
      end
    else
      redirect_to admin_event_path(@comment.commentable), alert: '削除理由を入力してください。'
    end
  end
end
