Rails.application.routes.draw do
  namespace :public do
    get 'groups/new'
    get 'groups/index'
    get 'groups/show'
    get 'groups/create'
    get 'groups/update'
    get 'groups/destroy'
  end
  namespace :admin do
    get 'groups/index'
    get 'groups/show'
    get 'groups/edit'
    get 'groups/update'
    get 'groups/destroy'
  end
  namespace :public do
    get 'events/new'
    get 'events/index'
    get 'events/show'
    get 'events/edit'
    get 'events/update'
    get 'events/create'
    get 'events/destroy'
  end
  namespace :admin do
    get 'events/index'
    get 'events/show'
    get 'events/edit'
    get 'events/update'
    get 'events/destroy'
  end
  namespace :public do
    get 'comments/create'
    get 'comments/edit'
    get 'comments/update'
    get 'comments/destroy'
  end
  namespace :admin do
    get 'comments/index'
    get 'comments/show'
    get 'comments/destroy'
  end
  namespace :public do
    get 'games/index'
    get 'games/show'
  end
  namespace :admin do
    get 'games/new'
    get 'games/index'
    get 'games/show'
    get 'games/create'
    get 'games/edit'
    get 'games/update'
    get 'games/destroy'
  end
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

    # Diariesコントローラ
    resources :diaries, only: [:new, :show, :create, :edit, :update, :destroy] do
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
    resources :diaries, only: [:index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy], param: :id, defaults: { commentable_type: 'Post' }
    end
  end
end
# ここまで11/14