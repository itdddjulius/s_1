Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'widgets#index'

  resources :authentication, only: %i[create] do
    post :revoke, on: :collection
  end

  resources :users, except: %i[index new edit update destroy] do
    get :me, on: :collection
    patch :update_my_profile, on: :collection
    post :change_password
    get :check_email
    post :reset_password, on: :collection
    get :search_widgets
  end

  resources :widgets, except: %i[new edit show] do
    get :search, on: :collection
    get :mine, on: :collection
  end
end
