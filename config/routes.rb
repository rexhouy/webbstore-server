Rails.application.routes.draw do
        mount RedactorRails::Engine => '/redactor_rails'

        devise_for :users, controllers: {
                sessions: "auth/sessions",
                confirmations: "auth/sessions",
                omniauth: "auth/omniauth",
                passwords: "auth/passwords",
                registrations: "auth/registrations",
                unlocks: "auth/unlocks"
        }

        get 'users/captcha' => 'auth/captcha#index'

        # The priority is based upon order of creation: first created -> highest priority.
        # See how all your routes lay out with "rake routes".

        # You can have the root of your site routed with "root"
        root 'home#index'

        get 'home' => 'home#home'


        namespace :api do
                # User address
                resources :addresses
                # Products
                get 'products' => 'products#index', as: :products
                get 'products/search' => 'products#search'
                get 'products/all' => 'products#all'
                get 'products/:id' => 'products#show', as: :products_detail
                # Cart
                get 'carts' => 'carts#show', as: :carts
                post 'carts' => 'carts#add', as: :carts_add_product
                put 'carts' => 'carts#update', as: :carts_mod_product
                delete 'carts' => 'carts#delete', as: :carts_del_product
                get 'carts/confirm' => 'carts#confirm'

                # Order
                post 'orders' => 'orders#add'
                get 'orders' => 'orders#index'
                get 'orders/:id' => 'orders#show'
                put 'orders/:id' => 'orders#cancel', as: :orders_cancel

                # Wechat payment
                get 'orders/payment/wechat_redirect' => 'orders#wechat_pay'

                # User home
                get 'me' => 'me#index'

                # Payment callback
                post 'payment/notify' => 'payments#notify'
                get 'payment/front_notify' => 'payments#front_notify'

                # About
                get 'about' => 'about#index'
        end

        namespace :admin do
                root 'welcome#index'
                resources :products do
                        resources :specifications
                end
                resources :orders
                resources :users
                resources :groups
                put 'orders/cancel/:id' => 'orders#cancel', as: :orders_cancel
                put 'orders/shipping/:id' => 'orders#shipping', as: :orders_shipping
                put 'orders/deliver/:id' => 'orders#deliver', as: :orders_deliver

                post 'product/preview' => 'products#preview', as: :product_preview

                get 'unauthorized_access' => 'unauthorized_access#index', as: :unauthorized_access

                # Image
                post 'image' => 'images#create'

                get '*path' => 'welcome#index'
        end

        get '*path' => 'home#index'

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
