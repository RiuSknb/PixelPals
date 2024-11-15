class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  # ログイン必須

  def mypage
    @user = current_user
    @diaries = @user.diaries.includes(:likes, :comments).order(created_at: :desc) # 例：ユーザーの投稿一覧
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
  end

  def update
  end

  def destroy
  end
end
