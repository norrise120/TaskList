Rails.application.routes.draw do
  root "tasks#index"

  get "/tasks", to: "tasks#index", as: "tasks"
  post "/tasks", to: "tasks#create"

  get "tasks/new", to: "tasks#new", as: "new_task"

  get "/tasks/:id", to: "tasks#show", as: "task"
  patch "/tasks/:id", to: "tasks#update"
  delete "/tasks/:id", to: "tasks#destroy"

  patch "/tasks/:id/complete", to: "tasks#toggle_complete", as: "toggle_complete_task"
  get "/tasks/:id/edit", to: "tasks#edit", as: "edit_task"
end
