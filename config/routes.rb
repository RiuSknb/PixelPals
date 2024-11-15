Rails.application.routes.draw do
  namespace :public do
    get 'users/mypage'
    get 'users/new'
    get 'users/index'
    get 'users/show'
    get 'users/create'
    get 'users/edit'
    get 'users/update'
    get 'users/destroy'
  end
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # 利用者側
  scope module: :public do
    root to: "homes#top"

    # Usersコントローラ
    resources :users, only: [:index, :new, :show, :edit, :update, :destroy] do
      collection do
        get 'mypage', to: 'users#mypage', as: 'mypage' # マイページ用のカスタムルート
      end
    end

    # Diariesコントローラ
    resources :diaries, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      # resources :comments, only: [:create, :destroy], param: :id, defaults: { commentable_type: 'Post' }
      resources :likes, only: [:create, :destroy], param: :id, defaults: { likeable_type: 'Post' }
      # , param: :id, defaults: { commentable_type: 'Event' }を追記


    end

    # Eventsコントローラ
    resources :events, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      resources :comments, only: [:create, :destroy], param: :id, defaults: { commentable_type: 'Event' }
      resources :likes, only: [:create, :destroy], param: :id, defaults: { likeable_type: 'Post' }
    end

    # Genresコントローラ
    resources :genres, only: [:index, :show] do
      resources :posts, only: [:new, :create]
    end

    # Gamesコントローラ
    resources :games, only: [:index, :show]

    # Groupsコントローラ
    resources :groups, only: [:new, :index, :show, :create, :edit, :update, :destroy]

    # Group_membersコントローラ
    resources :group_members
  end

  # --------------------------------------------------

  # 管理者側
  namespace :admin do
    root to: "homes#top"
    # Usersコントローラ
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        patch :deactivate  # ユーザーを非アクティブにするアクション
        patch :activate    # ユーザーをアクティブにするアクション
      end
    end

    # Postsコントローラ
    resources :diaries, only: [:index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy], param: :id, defaults: { commentable_type: 'Post' }
    end

    # Eventsコントローラ
    resources :events, only: [:index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy], param: :id, defaults: { commentable_type: 'Event' }
    end

    # Genresコントローラ
    resources :genres, only: [:index, :show, :edit, :update, :destroy]

    # Gamesコントローラ
    resources :games, only: [:index, :show, :edit, :update, :destroy]

    # Groupsコントローラ
    resources :groups, only: [:index, :show, :edit, :update, :destroy]

    # Group_membersコントローラ
    resources :group_members, only: [:index, :show, :edit, :update, :destroy]
  end
end