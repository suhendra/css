Rails.application.routes.draw do
  resources :entries do
    collection do
      get "send_feedback/:feedback", to: "entries#send_feedback", as: :send_feedback
    end
  end
  resources :counters
  root to: "pages#index"
  devise_for :users, skip: [:sessions]
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
  get 'survey', to: 'pages#survey', as: :survey
end
