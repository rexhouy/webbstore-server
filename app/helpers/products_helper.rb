# -*- coding: utf-8 -*-
module ProductsHelper

        def specification_group(specifications)
                specifications.reduce(Hash.new) do |group, spec|
                        (group[spec.name] ||= []) << spec
                        group
                end
        end

        def title(category)
                return "所有产品" if category.nil?
                category.name
        end

        def user_price(product)
                price = nil
                if product.is_bulk && current_user.location.eql?("昆明市")
                        price = product.price_km
                elsif product.is_bulk && current_user.location.eql?("北京市")
                        price = product.price_bj
                elsif product.is_bulk && current_user.nil?
                        return "￥#{product.price_km}起"
                else
                        price = product.price
                end
                number_to_currency(price, locale: :'zh-CN', precision: 2)
        end

        def graph_datetime(date)
                date.strftime("%m-%d %H") if date.present?
        end
end
