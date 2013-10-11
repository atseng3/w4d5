Cats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests, :only => [:edit, :update, :destroy, :create, :new] do
    member do
      put 'approve'
      put 'deny'
    end
  end
end
