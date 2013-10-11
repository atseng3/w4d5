Cats::Application.routes.draw do

  resources :users
  resource :session, :only => [:destroy, :create, :new]
  resources :cats
  resources :cat_rental_requests, :only => [:edit, :update, :destroy, :create, :new] do
    member do
      put 'approve'
      put 'deny'
    end
  end
end
