Rails.application.routes.draw do

  #get 'line_events/client'
  #get 'line_events/recieve'
  # login
  #helper		path		Controller#Action
  #login_path 	/login	oauths#login
  scope module: :oauths do
    get 'login'
  end

  # OAuth
  get 'oauth/oauth', to: "oauths#callback"
  get 'oauth/callback', to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

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

end
