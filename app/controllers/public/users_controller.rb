class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  # ログイン必須

  def mypage
    @user = current_user
    @diaries = @user.diaries.where(is_deleted: false).includes(:likes, :comments).order(created_at: :desc)
    # 例：ユーザーの投稿一覧
  end

  def new
  end

  def index
  end

  def show
  end

  def create
  end

  def edit
    @user = current_user
  end

  def update
  end

  def deactivate
    current_user.destroy
    sign_out current_user
    reset_session
    
    redirect_to root_path, notice: '退会処理が完了しました。'
  end
end
