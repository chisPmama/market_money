Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      get 'markets/search', to: 'markets#search'
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index]
        get '/nearest_atms', to: 'markets#nearest_atms'
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create, :destroy]

      delete "/market_vendors", to: "market_vendors#destroy"
    end
  end
end
