Rails.application.routes.draw do
  resources :tasks do
    resources :comments, only: %i[create destroy], module: :tasks
  end

  resources :projects do
    member do
      get :tasks_panel  # 第13章: 遅延読み込みのタスク一覧
      get :overview     # 第26章: 遅延タブ（概要）
      get :tasklist     # 第26章: 遅延タブ（タスク）
    end
  end

  resource :session
  resources :passwords, param: :token

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # ルート: プロジェクト一覧
  root "projects#index"
end
