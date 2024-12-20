class Public::DiariesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]  # indexとshowのみログインなしでアクセス可能
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_background_image
  
  def new
    @diary = Diary.new
  end

  def index
    @diaries = Diary.where(is_deleted: false)
                    .includes(:user, :game, :genre)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(10)
  end

  def show
    @diary = Diary.find_by(id: params[:id])

    if @diary.nil?
      flash[:alert] = "その投稿は存在しません。"
      redirect_to root_path # もしくは他の任意のページ
    end
  end


  def create
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
      redirect_to mypage_users_path, notice: '投稿が削除されました。'
    else
      redirect_to root_path, alert: '削除権限がありません。'
    end
  end


  private

  def set_background_image
    @background_image = 'cat_y.jpg'
  end
  
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