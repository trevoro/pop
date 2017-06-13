Pop::Application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :teams

  get 'projects/status_index'
  resources :projects

  get 'reports/build'

  resources :team_updates
  resources :project_imports
  resources :jira_sessions
  resources :jira_epic
  resources :reports

  resources :work_items do
      collection do
        get :objective
        put :bulk_update_objective
      end
  end

  get 'analytics/objectives'
  get 'analytics/products'
  get 'analytics/products_by_week'
  get 'analytics/projects'
  get 'analytics/projects_by_week'
  get 'analytics/effort_by_objective'
  get 'analytics/effort_by_product'
  get 'analytics/project_effort_by_objective'
  get 'analytics/weekly_summary'

  post 'teams/copy_epics'
  post 'webhooks/jira_issues'

  # You can have the root of your site routed with "root"

  root :to => 'work_items#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
