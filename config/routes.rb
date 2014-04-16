App::Application.routes.draw do

 root :to => 'welcome#index'
  
  resources :suppliers

  resources :users

 # resources :layouts

  #resources :uploads
  
  
  #delete "invoices/index"
  delete '/uploads/d', to: 'uploads#destroy'
   
  delete '/layouts', to: 'layouts#destroy'
  get '/layouts/c', to: 'layouts#chose'
  delete '/layouts/d', to: 'layouts#delete_file'
  get '/layouts/show', to: 'layouts#show'
  get '/layouts', to: 'layouts#index'
  post '/layouts', to: 'layouts#create'
  
  get "download/index"
  post "download/download"
  post "layouts/download" , to: 'layouts#download'
  get "/uploads/c", to: 'uploads#create'
  get "/uploads", to: 'uploads#index'
  post "/uploads", to: 'uploads#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #get 'upload', :to=> 'upload#uploadfile'
  #get "upload/uploadFile"
  
  #post "upload/uploadFile"

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
