class Diary < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable
  # アソシエーション設定
  belongs_to :user
  belongs_to :genre, optional: true
  belongs_to :game, optional: true
  belongs_to :group, optional: true
  # optional: true は、この関連が必須でないことを示します。
  # つまり、Post インスタンスは Game に関連付けられなくてもよい、ということです。Game が nil の場合でも Post を保存することができます。

  # バリデーション設定
  validates :title, presence: true, unless: :is_deleted, length: { maximum: 100 }
  validates :body, presence: true, unless: :is_deleted, length: { maximum: 1000 }
  validates :deleted_by, inclusion: { in: %w(user admin), allow_blank: true } # 削除者は 'user' または 'admin' のみ許容
  # with_options if: -> { post_type == 'event' } do |post|
  #   post.validates :place, presence: true
  #   post.validates :date, presence: true
  # end

  # スコープ設定
  scope :active, -> { where(is_deleted: false) } # 論理削除されていない投稿のみを取得
  # scope :deleted, -> { where(is_deleted: true) } # 論理削除された投稿のみを取得

  # メソッド例(削除実行者 (by) と削除理由 (reason) を記録するメソッド)
  def mark_as_deleted(by:, reason: nil)
    update(is_deleted: true, deleted_by: by, deleted_reason: reason)
  end

  enum deleted_by: { user: 0, admin: 1 }
end

class Public::PostsController < ApplicationController
  before_action :authenticate_user!  # ログイン必須


  def new
    @game = Game.find(params[:game_id])
    @genre = Genre.find(@game.genre_id)
    @diary = Diary.new
  end

  def index
    @diaries = Diary.where(is_deleted: false, post_type: 'diary').includes(:user, :game, :genre).order(created_at: :desc)
  end

  def show
    @diary = Diary.find(params[:id])
  end

  def create
    @game = Game.find(params[:game_id])
    @genre = Genre.find(@game.genre_id)

    diary_params = diary_params()
    @diary = current_user.diaries.new(diary_params)  # current_userを投稿に関連付け

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
      if @diary.update(genre_id: nil,
                      game_id: nil,
                      group_id: nil,
                      title: "",
                      body: "",
                      place: "",
                      date: "",
                      is_deleted: true,
                      deleted_by: 0)
        if @diary.post_type == "diary"
          redirect_to index_diaries_path, notice: '投稿が削除されました。'
        else
          redirect_to events_posts_path, notice: '投稿が削除されました。'
        end
      else
        # バリデーションエラーメッセージをログに表示
        Rails.logger.error @diary.errors.full_messages.join(", ")
        redirect_to index_diaries_path, alert: '削除に失敗しました。'
      end
    else
      redirect_to diaries_posts_path, alert: '削除権限がありません。'
    end
  end


  private
  
  # `post_params` で、date や他のフィールドを許可
  def diary_params
    params.require(:diary).permit(:title, :body, :date, :place, :user_id, :game_id, :post_type, :genre_id, :group_id)
  end
end