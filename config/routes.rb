Rails.application.routes.draw do

  # login
  #helper		path		Controller#Action
  #login_path 	/login	oauths#login
  scope module: :oauths do
    get 'login'
  end

  # OAuth
  get 'oauths/oauth', to: "oauths#callback"
  get 'oauths/callback', to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

end
