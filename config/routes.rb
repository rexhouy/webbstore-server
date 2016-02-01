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

        # Shop
        get "shops" => "shops#index"
        get "shops/:id" => "shops#show"
        get "shops/:id/products" => "shops#products"

        # 宣传文章
        get 'articles/:id' => 'articles#index'

        # User address
        resources :addresses
        # Products
        get "menu/:sid" => "menus#index"
        get "menu/:sid/tables/:tid" => "menus#index"
        get "takeout_menu" => "takeout#index"
        get 'products' => 'products#index', as: :products
        get 'products/search' => 'products#search'
        get 'products/:id' => 'products#show', as: :products_detail

        # Reserve
        resources :reservations

        # Categories
        get "categories" => "categories#index"

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
        post "orders/:id/confirm_payment" => "orders#confirm_payment"

        # Payment
        get 'payment/wechat/redirect' => 'payments#wechat_redirect'
        get 'payment/alipay/redirect' => 'payments#alipay_redirect'

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
        post "gift/lottery" => "gift#lottery"

        # Administration
        namespace :admin do
                root "home#index"
                get "sign_in" => "home#sign_in"
                get "unauthorized_access" => "home#unauthorized_access", as: :unauthorized_access

                resources :groups
                get "groups/:id/qrcode" => "groups#qrcode"

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
                put "users/:id/cancel_notification" => "users#cancel_notification"
                put "users/:id/unlock" => "users#unlock"
                # Orders
                get "orders/cards" => "orders#cards", as: :orders_cards # cards
                get "orders/cards/:id" => "orders#card"
                put "orders/cards/deliver/:id" => "orders#card_deliver"
                resources :orders
                get "takeout_orders" => "orders#takeout", as: :takeout_orders
                get "immediate_orders" => "orders#immediate", as: :immediate_orders
                put 'orders/cancel/:id' => 'orders#cancel', as: :orders_cancel
                put 'orders/shipping/:id' => 'orders#shipping', as: :orders_shipping
                put 'orders/deliver/:id' => 'orders#deliver', as: :orders_deliver
                # Register wechat notification page
                get 'orders/notification/wechat' => 'orders#notification', as: :order_notification_registry
                get 'orders/notification_redirect/wechat' => 'orders#notification_redirect_page'
                # Register wechat notification callback
                get 'orders/wechat_register_notification/:uid' => 'orders#wechat_register_notification'
                # Reservations
                get "reservations" => "reservations#index", as: :reservations
                post "reservations/confirm/:id" => "reservations#confirm", as: :reservation_confirm
                post "reservations/cancel/:id" => "reservations#cancel", as: :reservation_cancel

                #Products
                resources :products do
                        resources :specifications
                end
                post 'product/preview' => 'products#preview', as: :product_preview
                put "products/:id/supplement" => "products#supplement"
                put "products/:id/spec/:spec_id/supplement" => "products#supplement"

                # Trade
                get "trades" => "trades#index", as: :trades

                # Table
                resources :dinning_tables

                # Coupon
                get "coupons/list_available" => "coupons#list_available"
                post "coupons/dispense/:id" => "coupons#dispense"
                resources :coupons

                # Shops
                get "shops" => "shops#show", as: :shops
                get "shops/edit" => "shops#edit", as: :shop
                post "shops/preview" => "shops#preview"
                put "shops" => "shops#update"

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
