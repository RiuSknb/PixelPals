class Admin::BaseController < ApplicationController
  before_action :authenticate_admin! # Deviseで提供される認証メソッド

  # 必要に応じてカスタムエラーハンドリングも追加可能
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end