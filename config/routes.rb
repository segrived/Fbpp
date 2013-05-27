Fbpp::Application.routes.draw do
  root :to => "home#index"
  
  match "login" => "users#login", via: [:get, :post]
  match "register" => "users#register", via: [:get, :post]
  get "logout" => "sessions#logout"

  match "settings" => redirect("/settings/personal")
  match "settings/remove_account", via: [:get, :delete]
  match "settings/change_password", via: [:get, :put]
  match "settings/personal", via: [:get, :put]
  match "settings/lecturer", via: [:get, :put]
  match "settings/student", via: [:get, :put]
  match "settings/api", via: [:get]

  match "admin/mods" => "users#mods", via: [:get, :post]
  delete "admin/mods/:id" => "users#mods", as: :admin_mod

  match "create_admin" => "users#create_admin", via: [:get, :post]
  
  get "profile/(:login)" => "users#profile", as: :profile

  # Личные сообщения
  get "inbox" => "private_messages#inbox"
  get "outbox" => "private_messages#outbox"
  get "messages/:id" => "private_messages#read", as: :messages, :id => /[\d]+/
  get "messages/new/(:id)" => "private_messages#new", as: :messages_new, :id => /[\d]+/
  get "messages/new/(:login)" => "private_messages#new", as: :messages_new, :login => /[A-Za-z][\w\d]+/
  post "messages/new" => "private_messages#new"
  delete "messages/:id/delete" => "private_messages#delete", :as => :messages_delete

  get "feedback/:id" => "subscriptions#show", as: :subscriptions
  get "users" => redirect("/users/all")
  get "users/:filter/(:page)" => "users#list", :as => :users, :page => /\d+/
  post "subjects/:id/subscribe" => "subjects#subscribe", :as => :subject_subscribe
  post "subjects/:id/unsubscribe" => "subjects#unsubscribe", :as => :subject_unsubscribe
  # Комментарии
  get "lecturer/:lid/comments" => "sessions#lecturer_comments", :as => :lecturer_comments
  post "comments/add" => "comments#add", :as => :add_comment
  delete "comments/:id/delete" => "comments#destroy", :as => :delete_comment
  post "comment/:comment_id/:type" => "comments#vote", :as => :comment_vote, constraints: { type: /upvote|downvote/ }

  # Основные статические страницы
  get ":action" => "home#:action", constraints: { action: /index|faq|about/ }, as: :home

  # Кафедры, специальности и дисциплины
  resources :departaments, :specialties, :subjects
  resources :questions, except: [:show]
  resources :feedbacks, controller: 'subscriptions'
  get "feedbacks/:id/new" => "feedbacks#new", as: 'new_feedback'
  post "feedbacks/:id/add" => "feedbacks#add", as: 'add_feedback'
  delete "feedbacks/:id/destroy" => "feedbacks#destroy", as: 'feedback_destroy'
  get "feedbacks/:id/all/(page-(:page))" => "subscriptions#all", as: 'feedbacks_all'
  get "departaments/:id/lecturers" => "departaments#lecturers", :as => :departament_lecturers
  get "departaments/:id/subjects" => "departaments#subjects", :as => :departament_subjects

  get "create_admin" => "users#create_admin"
end