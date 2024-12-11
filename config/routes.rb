Rails.application.routes.draw do
  get 'searches/search'
  devise_for :users, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  get 'search', to: 'searches#search'

  # 利用者側
  scope module: :public do
    root to: "homes#top"

    # Usersコントローラ
    resources :users, only: [:index, :new, :show, :edit, :create, :update, :destroy] do
      collection do
        get 'mypage', to: 'users#mypage', as: 'mypage' # マイページ用のカスタムルート
        get 'find_by_id', to: 'users#find_by_id'
      end
      member do
        put :deactivate
      end
    end

    # Diariesコントローラ
    resources :diaries, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      # resources :comments, only: [:create, :destroy], param: :id, defaults: { commentable_type: 'Post' }
      resources :likes, only: [:create, :destroy], param: :id, defaults: { likeable_type: 'Diary' }
      # , param: :id, defaults: { commentable_type: 'Event' }を追記
    end

    # Eventsコントローラ
    resources :events, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      # イベントに対してコメントを作成・削除するルートを追加
      resources :comments, only: [:create, :edit, :update, :destroy], param: :id, defaults: { commentable_type: 'Event' }
      # イベントに対していいねを作成・削除するルート（もしあれば）
      resources :likes, only: [:create, :destroy], param: :id, defaults: { likeable_type: 'Diary' }
    end

    # Genresコントローラ
    resources :genres, only: [:index, :show] do
      resources :posts, only: [:new, :create]
    end

    # Gamesコントローラ
    resources :games, only: [:index, :show]

    # Groupsコントローラ
    resources :groups do
      resources :group_members, only: [:create, :destroy, :update] do
        member do
          delete :leave
          patch 'accept_invitation'  # 「招待を受け入れる」アクションのルート
        end
      end

      resources :group_messages, only: [:index, :create]
    end
  end

  # --------------------------------------------------

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'  # 管理者用ログイン処理を指定
  }

  namespace :admin do
    root to: "homes#top"
    authenticate :admin do
  
      # Usersコントローラ
      resources :users, only: [:index, :show, :edit, :update, :destroy] do
        member do
          patch :activate
        end
      end

      # dairesコントローラ
      resources :diaries, only: [:index, :show, :edit, :update, :destroy]
        # resources :comments, only: [:destroy], param: :id, defaults: { commentable_type: 'Diary' }

      # Eventsコントローラ
      resources :events, only: [:index, :show, :edit, :update, :destroy] do
        resources :comments, only: [:destroy], param: :id, defaults: { commentable_type: 'Event' }
      end

      # Genresコントローラ
      resources :genres, only: [:new, :index, :show, :create, :edit, :update]

      # Gamesコントローラ
      resources :games, only: [:new, :index, :show, :create, :edit, :update]

      # Groupsコントローラ
      resources :groups, only: [:index, :show, :edit, :update, :destroy] do
        member do
          patch :activate
          patch :deactivate
        end
      end

      # Group_membersコントローラ
      resources :group_members, only: [:index, :show, :edit, :update, :destroy]
    end
  end
end