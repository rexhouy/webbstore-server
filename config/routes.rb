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
        get 'articles/catering_cm' => 'articles#catering_cm'
        get 'articles/game' => 'articles#game'
        get 'articles/:id' => 'articles#index'

        # 留言
        post "messages" => "messages#create"

        # User address
        resources :addresses
        # Products
        get 'products' => 'products#index', as: :products
        get 'products/search' => 'products#search'
        get 'products/:id' => 'products#show', as: :products_detail
        get "products/:id/price_hist" => "products#price_hist"

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
        get 'orders/confirm_bulk/:id' => 'orders#confirm_bulk'
        post "orders/bulk" => "orders#add_bulk"

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
                put 'orders/cancel/:id' => 'orders#cancel', as: :orders_cancel
                put 'orders/shipping/:id' => 'orders#shipping', as: :orders_shipping
                put 'orders/deliver/:id' => 'orders#deliver', as: :orders_deliver
                # Register wechat notification page
                get 'orders/notification/wechat' => 'orders#notification', as: :order_notification_registry
                get 'orders/notification_redirect/wechat' => 'orders#notification_redirect_page'
                # Register wechat notification callback
                get 'orders/wechat_register_notification/:uid' => 'orders#wechat_register_notification'

                #Products
                resources :products do
                        resources :specifications
                end
                post 'product/preview' => 'products#preview', as: :product_preview
                put "products/:id/supplement" => "products#supplement"
                put "products/:id/spec/:spec_id/supplement" => "products#supplement"

                # Trade
                get "trades" => "trades#index", as: :trades

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

                # Message board
                get "messages" => "messages#index"
        end

        # Crowdfundings
        namespace :crowdfundings do
                root "products#index"

                # Products
                get 'products' => 'products#index', as: :products
                get 'products/search' => 'products#search'
                get 'products/:id' => 'products#show', as: :products_detail
                get 'products/:id/buy' => 'products#buy'

                # Orders
                get "orders" => "orders#index", as: :orders
                post "orders" => "orders#create", as: :create_order
                get "orders/:id" => "orders#show", as: :order
                put "orders/:id/cancel" => "orders#cancel"

                # Users
                post "user/setLocation" => "users#set_location"

        end

end
