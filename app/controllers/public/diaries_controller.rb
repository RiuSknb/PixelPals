class Public::DiariesController < ApplicationController
  before_action :authenticate_user!  # ログイン必須
  before_action :ensure_correct_user, only: [:edit, :update]


  def new
    @game = Game.find(params[:game_id])
    @genre = Genre.find(@game.genre_id)
    @diary = Diary.new
  end

  def index
    @diaries = Diary.where(is_deleted: false).includes(:user, :game, :genre).order(created_at: :desc)
  end

  def show
    @diary = Diary.find(params[:id])
  end


  def create
    @game = Game.find(params[:game_id])
    @genre = Genre.find(@game.genre_id)
    @diary = Diary.new(diary_params)

    if @diary.save
      redirect_to @diary, notice: '投稿が作成されました。'
    else
      flash[:error] = @diary.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    @diary = Diary.find(params[:id])
  end

  def update
    @diary = Diary.find(params[:id])
    if @diary.update(diary_params)
      redirect_to diary_path(@diary), notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @diary = Diary.find(params[:id])
    if @diary.user == current_user
      @diary.destroy # データベースから削除
      redirect_to diaries_path, notice: '投稿が削除されました。'
    else
      redirect_to root_path, alert: '削除権限がありません。'
    end
  end


  private
  
  # `post_params` で、date や他のフィールドを許可
  def diary_params
    params.require(:diary).permit(:title, :body, :user_id, :game_id, :genre_id, :group_id)
  end

  # 編集しようとする投稿の所有者がログインユーザーか確認
  def ensure_correct_user
    @diary = Diary.find(params[:id])
    if @diary.user != current_user
      redirect_to diaries_path
    end
  end
end