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

  get 'books/search', to: 'books#search', as: 'book_search'
  get 'books/list', to: 'books#all', as: 'book_search_by_category'
  resources :books
  resources :categories

  post 'reservar-livro', to: 'book_borrow#create', as: 'book_borrow_create'
  get 'livros-emprestados', to: 'book_borrow#all', as: 'book_borrow_all'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
