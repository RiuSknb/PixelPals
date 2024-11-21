class Public::CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy] # 最初に @comment を設定
  before_action :authorize_user, only: [:edit, :update, :destroy] # その後に権限を確認

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
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable # 親オブジェクト（例: Event）
  end

  def update
    @comment = Comment.find(params[:id])
    @event = @comment.commentable  # コメントに関連付けられたイベントを取得
  
    if @comment.update(comment_params)
      redirect_to @event, notice: 'コメントが更新されました'
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @event = @comment.commentable  # コメントに関連付けられたイベントを取得
    if @comment.user == current_user || current_user.admin?
      @comment.update(is_deleted: true, deleted_by: current_user.name, deleted_reason: "ユーザーにより削除")
      redirect_to @comment.commentable, notice: 'コメントが削除されました。'
    else
      redirect_to @comment.commentable, alert: '削除権限がありません。'
    end
  end


  private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      redirect_to root_path, alert: "コメントが見つかりません。"
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    Rails.logger.debug("Current user ID: #{current_user.id}")
    Rails.logger.debug("Comment user ID: #{@comment.user.id}")
    unless @comment.user == current_user
      redirect_to root_path, alert: "他のユーザーのコメントは編集できません。"
    end
  end
end