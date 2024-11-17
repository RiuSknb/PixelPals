class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    # if resource.admin? # 管理者の場合
      # admin_dashboard_path
    # else # 一般ユーザーの場合
    mypage_users_path
    # end
  end

  protected

  def configure_permitted_parameters
    # サインアップ時にnameとis_activeを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end