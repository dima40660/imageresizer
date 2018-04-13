Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :images do
        get ':image_id',     to: 'images#download'
        post '',             to: 'images#upload'
        delete ':image_id',  to: 'images#delete'
      end
    end
  end
end
