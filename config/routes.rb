Rails.application.routes.draw do

  devise_for :users,
  defaults: { format: :json },
             controllers: {
                sessions: "users/sessions",
                registrations: "users/registrations"
              },
             path_names: {
                sign_in: "login",
                sign_out: "logout",
                registration: "signup"
              }
  get "/members-data", to: "members#show"

  resources :books
  resources :categories

  post 'reservar-livro', to: 'book_borrow#create', as: 'book_borrow_create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
