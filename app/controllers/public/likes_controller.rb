class Public::LikesController < ApplicationController
  def create
    @diary = Diary.find(params[:diary_id])
    @like = current_user.likes.new(likeable: @diary)

    if @like.save
      respond_to do |format|
        format.js # create.js.erb を探して実行
      end
    else
      respond_to do |format|
        format.js { render 'error', status: :unprocessable_entity } # エラーハンドリング用
      end
    end
  end

  def destroy
    @diary = Diary.find(params[:diary_id])
    @like = current_user.likes.find_by(likeable: @diary)

    if @like&.destroy
      respond_to do |format|
        format.js # destroy.js.erb を探して実行
      end
    else
      respond_to do |format|
        format.js { render 'error', status: :unprocessable_entity } # エラーハンドリング用
      end
    end
  end
end