class Admin::DiariesController < Admin::BaseController
  before_action :set_diary, only: [:edit, :update, :destroy]

  def index
    @diaries = Diary.all
  end

  def show
    @diary = Diary.find(params[:id])
  end

  def edit
  end

  def update
    @diary = Diary.find(params[:id])
    if @diary.update(diary_params)
      redirect_to admin_diary_path(@diary), notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    # 削除理由が送信されている場合のみ処理を実行
    if params[:reason].present?
      if @user.update(is_deleted: true, deleted_reason: params[:reason])
        redirect_to admin_user_path(@user), notice: '日記が削除されました。'
      else
        redirect_to admin_user_path(@user), alert: '日記の削除に失敗しました。'
      end
    else
      redirect_to admin_user_path(@user), alert: '削除理由を入力してください。'
    end
  end

  private

  def set_diary
    @diary = Diary.find(params[:id])
  end

  def diary_params
    params.require(:diary).permit(:title, :body, :user_id, :game_id, :genre_id, :group_id)
  end
end