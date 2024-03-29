Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post "/users" => "users#create"
  post "/login" => "session#login"
  post "/groups" => "groups#create"
  put "/groups/:id" => "groups#assign_user_to_group"
end
