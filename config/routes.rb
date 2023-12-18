Rails.application.routes.draw do

  #admin
  namespace :admin do
    root to: 'dashboards#index'
    resources :users, only: %i[index destroy]
    resources :todos, only: %i[index edit update destroy]
    resources :spots, only: %i[index destroy]
    resources :reviews, only: %i[index destroy]
  end

  #documents
  get 'privacy_policy', to: 'documents#privacy_policy'
  get 'terms_of_service', to: 'documents#terms_of_service'

  scope module: :oauths do
    get 'login'
  end

  #user
  get 'usersetting', to: 'users#edit'
  post 'usersetting', to: 'users#update'

  # OAuth
  get 'oauth/oauth', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  delete 'logout', to: 'oauths#destroy'

  #line_events webhookを受けるURL
  post :line_events, to: 'line_events#recieve'

  # todos
  resources :todos do
    #ルートの追加。memberはidが付与される。collectionは付与されない。
    member { patch 'finish' => 'todos#finish' }
    member { patch 'continue' => 'todos#continue' }
    #reviews
    resource :review
  end

  #currentlocations
  resources :currentlocations, only: [:index, :new, :create]

  #toppage
  root to: 'explanations#top'

end
