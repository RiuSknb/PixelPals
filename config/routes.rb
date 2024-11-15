Rails.application.routes.draw do
  namespace :admin do
    get 'genres/new'
    get 'genres/index'
    get 'genres/show'
    get 'genres/create'
    get 'genres/edit'
    get 'genres/update'
    get 'genres/destroy'
  end
  namespace :public do
    get 'genres/index'
    get 'genres/show'
  end
  namespace :admin do
    get 'homes/top'
    get 'homes/about'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
  end
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # 利用者側
  scope module: :public do
    root to: "homes#top"

    # Postsコントローラ
    resources :posts, only: [:new, :show, :create, :edit, :update, :destroy] do
      resources :comments, only: [:create, :destroy], param: :id, defaults: { commentable_type: 'Post' }
      resources :likes, only: [:create, :destroy], param: :id, defaults: { likeable_type: 'Post' }
      # , param: :id, defaults: { commentable_type: 'Event' }を追記

      collection do
        get 'diaries'  # /public/posts/diaries
        get 'events'   # /public/posts/events
      end
    end
  end
  
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # 管理者側
  namespace :admin do
    root to: "homes#top"
    # Postsコントローラ
    resources :posts, only: [:index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy], param: :id, defaults: { commentable_type: 'Post' }
    end
  end
end
# ここまで11/14