class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    user = User.find(params[:id])
    # 削除理由が送信されている場合のみ処理を実行
    if params[:reason].present?
      if @user.update(is_active: false, status_reason: params[:reason])
        redirect_to admin_user_path(@user), notice: 'ユーザーアカウントを停止しました。'
      else
        redirect_to admin_user_path(@user), alert: 'ユーザーアカウントの停止に失敗しました。'
      end
    else
      redirect_to admin_user_path(@user), alert: 'ユーザーアカウント停止理由を入力してください。'
    end
  end

  def activate
    @user = User.find(params[:id])
    if @user.update(is_active: true)
      flash[:notice] = "ユーザーアカウントを有効化しました。"
    else
      flash[:alert] = "ユーザーアカウントの有効化に失敗しました。"
    end
    redirect_to admin_user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
