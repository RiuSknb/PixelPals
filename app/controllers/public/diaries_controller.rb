class Public::DiariesController < ApplicationController
  before_action :authenticate_user!  # ログイン必須


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

    # `post_params` で `date` を組み立てる
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
      @diary.update(genre_id: nil,
                      game_id: nil,
                      group_id: nil,
                      title: "",
                      body: "",
                      is_deleted: true,
                      deleted_by: 0)
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
end