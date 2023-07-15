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
  get "/members", to: "members#show"

  get 'books/search', to: 'books#search', as: 'book_search'
  get 'books/list', to: 'books#all', as: 'books_all'
  resources :books
  resources :categories

  post 'reservar-livro', to: 'book_borrow#create', as: 'book_borrow_create'
  get 'livros-emprestados', to: 'book_borrow#all', as: 'book_borrow_all'
  get 'livros-emprestados/:id', to: 'book_borrow#show', as: 'book_borrow_show'
  put 'livros-emprestados/:id', to: 'book_borrow#update', as: 'book_borrow_update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
