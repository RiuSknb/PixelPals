class Public::EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]  # indexとshowのみログインなしでアクセス可能
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @event = Event.new
  end

  def index
    @events = Event.where(is_deleted: false).includes(:user, :game, :genre).order(created_at: :desc)
  end

  def show
    @event = Event.find_by(id: params[:id])
  
    if @event.nil?
      flash[:alert] = "そのイベントは存在しません。"
      redirect_to events_path # イベント一覧ページなど、適切なリダイレクト先を指定
      return
    end
  
    # イベントが存在する場合のみ以下の処理を実行
    @game = Game.find(@event.game_id)
    @genre = Genre.find(@event.genre_id)
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
      redirect_to mypage_users_path, notice: '投稿が削除されました。'
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
  def admin_access?
    admin_signed_in? # ここは管理者のログイン判定メソッドに置き換えてください
  end
end
