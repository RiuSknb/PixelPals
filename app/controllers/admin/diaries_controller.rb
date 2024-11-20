class Admin::DiariesController < ApplicationController
  before_action :set_diary, only: [:edit, :update, :destroy]

  def index
    @diaries = Diary.all
  end

  def show
  end

  def edit
  end

  def update
  end

  # destroy アクション
  def destroy
    if @diary.update(is_deleted: true, deleted_by: current_admin.id)
      redirect_to admin_diaries_path, notice: '日記を削除しました（論理削除）'
    else
      redirect_to admin_diaries_path, alert: '日記の削除に失敗しました'
    end
  end

  private

  def set_diary
    @diary = Diary.find(params[:id])
  end
end