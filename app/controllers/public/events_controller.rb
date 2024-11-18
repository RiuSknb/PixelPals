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
  end

  def edit
    @event = Event.find(params[:id])
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
    @event = Diary.find(params[:id])
    if @event.user == current_user
      @event.update(genre_id: nil,
                      game_id: nil,
                      group_id: nil,
                      title: "",
                      body: "",
                      place: "",
                      date: "",
                      is_deleted: true,
                      deleted_by: 0)
      redirect_to events_path, notice: '投稿が削除されました。'
    else
      redirect_to root_path, alert: '削除権限がありません。'
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
end
