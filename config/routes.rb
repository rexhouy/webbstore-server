# -*- coding: utf-8 -*-
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

        # 宣传文章
        get 'articles/:id' => 'articles#index'

        # User address
        resources :addresses
        # Products
        get 'products' => 'products#index', as: :products
        get 'products/search' => 'products#search'
        get 'products/:id' => 'products#show', as: :products_detail

        # Cards
        get 'cards' => 'cards#index', as: :cards
        get 'cards/history/:id' => 'cards#history'
        put 'cards/delay/:id' => 'cards#delay'
        post 'cards/gift/:id' => 'cards#gift'
        put 'cards/open/:id' => 'cards#open'

        # Carts
        get 'carts' => 'carts#show', as: :carts
        post 'carts' => 'carts#add', as: :carts_add_product
        put 'carts' => 'carts#update', as: :carts_mod_product
        delete 'carts' => 'carts#delete', as: :carts_del_product

        # Orders
        post 'orders' => 'orders#add'
        get 'orders' => 'orders#index'
        get 'orders/confirm' => 'orders#confirm', as: :orders_confirm
        get 'orders/:id' => 'orders#show'
        put 'orders/:id' => 'orders#cancel', as: :orders_cancel

        # Wechat payment
        get 'orders/payment/wechat_redirect' => 'orders#wechat_pay'

        # User home
        get 'me' => 'me#index'
        get "me/introduce" => "me#introduce"
        get "me/coupons" => "me#coupons"
        get "me/wallet" => "me#wallet"

        # Payment callback
        get 'payment/wechat/front_notify' => 'payments#wechat_front_notify'
        post 'payment/wechat/notify' => 'payments#wechat_notify'
        get 'payment/alipay/front_notify' => 'payments#alipay_front_notify'
        post 'payment/alipay/notify' => 'payments#alipay_notify'

        # About
        get 'about' => 'about#index'

        # Tmp
        get "gift" => "gift#index"

        # Administration
        namespace :admin do
                root "home#index"
                get "sign_in" => "home#sign_in"
                get "unauthorized_access" => "home#unauthorized_access", as: :unauthorized_access

                resources :groups
                resources :articles
                resources :suppliers
                resources :channels
                resources :categories

                # Users
                resources :users
                get "users/:id/coupons" => "users#coupons"
                get "users/:id/account_balance" => "users#account_balance"
                put "users/:id/account_balance" => "users#deposit"
                put "users/:id/coupons" => "users#dispense"

                # Orders
                get "orders/cards" => "orders#cards", as: :orders_cards # cards
                get "orders/cards/:id" => "orders#card"
                put "orders/cards/deliver/:id" => "orders#card_deliver"
                resources :orders
                put 'orders/cancel/:id' => 'orders#cancel', as: :orders_cancel
                put 'orders/shipping/:id' => 'orders#shipping', as: :orders_shipping
                put 'orders/deliver/:id' => 'orders#deliver', as: :orders_deliver
                # Register wechat notification page
                get 'orders/notification/wechat' => 'orders#notification'
                get 'orders/notification_redirect/wechat' => 'orders#notification_redirect_page'
                # Register wechat notification callback
                get 'orders/wechat_register_notification/:uid' => 'orders#wechat_register_notification'

                #Products
                resources :products do
                        resources :specifications
                end
                post 'product/preview' => 'products#preview', as: :product_preview

                # Trade
                get "trades" => "trades#index", as: :trades

                # Coupon
                get "coupons/list_available" => "coupons#list_available"
                post "coupons/dispense/:id" => "coupons#dispense"
                resources :coupons

                # Image
                post 'image' => 'images#create'
        end

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
