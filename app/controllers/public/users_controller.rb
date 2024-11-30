class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_background_image
  # ログイン必須

  def mypage
    @user = current_user
    @groups = @user.groups.all
    @diaries = @user.diaries.where(is_deleted: false).includes(:likes, :comments).order(created_at: :desc)
    @events = @user.events.where(is_deleted: false).includes(:likes, :comments).order(created_at: :desc)
    # 例：ユーザーの投稿一覧
  end

  def new
  end

  def index
    @users = User.includes(:events, :diaries).all
  end

  def show
    @user = User.includes(:diaries, :events).find(params[:id])
  end

  def create
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      # 更新が成功した場合、mypageにリダイレクト
      redirect_to mypage_users_path, notice: "情報を更新しました。"
    else
      # 更新が失敗した場合は再度編集ページを表示
      render :edit, alert: "更新に失敗しました。"
    end
  end

  def deactivate
    @user = current_user
    begin
      # ユーザーに関連するデータの論理削除
      @user.comments.find_each do |comment|
        comment.delete
      end
      @user.diaries.find_each do |diary|
        diary.destroy
      end
      @user.events.find_each do |event|
        event.delete
      end
      
      @user.update(status_reason: "退会のため")
    
      # ユーザー自身を非アクティブ化
      @user.update(is_active: false)
      redirect_to users_path
    rescue => e
      logger.error "Error during user deactivation: #{e.message}"
      logger.error e.backtrace.join("\n")  # エラーのバックトレースをログに出力
      flash[:alert] = 'ユーザーの非アクティブ化に失敗しました'
      redirect_to mypage_users_path
    end
  end

  def find_by_id
    user = User.find_by(id: params[:id])
    if user
      render json: { success: true, name: user.name }
    else
      render json: { success: false, error: "ユーザーが見つかりませんでした" }, status: 404
    end
  end

  private

  def set_background_image
    @background_image = 'cat_g.jpg'
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  # 編集しようとするユーザーがログイン中のユーザーか確認
  def ensure_correct_user
    # 自分以外のIDでアクセスしている場合、マイページにリダイレクト
    if current_user.id != params[:id].to_i
      redirect_to mypage_users_path(current_user)
    end
  end
end

