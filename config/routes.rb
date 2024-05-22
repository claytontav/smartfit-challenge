Rails.application.routes.draw do
  post 'page/create', to: 'page#create'
  
  root "page#index"
end
