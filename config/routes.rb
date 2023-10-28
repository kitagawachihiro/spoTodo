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
    #reviews
    resource :review
  end

  #currentlocations
  resources :currentlocations, only: [:index, :new, :create]
  post 'currentlocation_add_todo', to: 'currentlocations#add_todo' 

  #toppage
  root to: 'explanations#top'

  #achieved_todos
  get 'achievedtodos', to: 'achieved_todos#index'

  #everyone_todos
  get 'everyonetodos', to: 'everyone_todos#index'
  post 'add_todo', to: 'everyone_todos#add_todo'    

end
