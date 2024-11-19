class Public::EventsController < ApplicationController
  before_action :authenticate_user!  # ログイン必須
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @game = Game.find(params[:game_id])
    @genre = Genre.find(@game.genre_id)
    @event = Event.new
  end

  def index
    @events = Event.where(is_deleted: false).includes(:user, :game, :genre).order(created_at: :desc)
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comments.where(is_deleted: false).order(created_at: :desc)
  end

  def edit
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event), notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def create
    @game = Game.find(params[:game_id])
    @genre = Genre.find(@game.genre_id)
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: '投稿が作成されました。'
    else
      flash[:error] = @event.errors.full_messages.join(', ')
      render :new
    end    
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.user == current_user
      @event.destroy # データベースから削除
      redirect_to events_path, notice: '投稿が削除されました。'
    else
      redirect_to root_path, alert: '削除権限がありません。'
    end
  end

  # コメント作成
  def create_comment
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @event, notice: 'コメントが投稿されました。'
    else
      redirect_to @event, alert: 'コメントの投稿に失敗しました。'
    end
  end

  private
  
  # `post_params` で、date や他のフィールドを許可
  def event_params
    params.require(:event).permit(:title, :body, :place, :date, :user_id, :game_id, :genre_id, :group_id)
  end

  # 編集しようとする投稿の所有者がログインユーザーか確認
  def ensure_correct_user
    @event = Event.find(params[:id])
    if @event.user != current_user
      redirect_to diaries_path
    end
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
