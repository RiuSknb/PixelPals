class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_members
  has_many :groups, through: :group_members
  has_many :diaries, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :profile_image

  
  # バリデーションを追加
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :status_reason, length: { maximum: 30 }

  # is_activeがデフォルトでtrueになるように
  after_initialize :set_default_is_active, if: :new_record?
  
  # アクティブユーザーかどうかをチェックするメソッド
  def active_for_authentication?
    super && is_active
  end

  # アカウントが無効化された場合のメッセージ
  def inactive_message
    is_active ? super : :account_inactive
  end
  # プロフィール画像
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no-image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
  end


  private

  def set_default_is_active
    self.is_active ||= true
  end
end