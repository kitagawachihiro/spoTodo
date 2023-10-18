Rails.application.routes.draw do
  
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
  end

  #currentlocations
  resources :currentlocations, only: [:index, :new, :create]

  #toppage
  root to: 'explanations#top'

  #reviews
  resources :reviews

end
