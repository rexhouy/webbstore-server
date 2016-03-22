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
                unless product.is_bulk?
                        return number_to_currency(product.price, locale: :'zh-CN', precision: 2)
                end
                started = product.start_date <= Time.now
                return price_range(product) unless started
                if current_user.location.eql?("昆明市")
                        return number_to_currency(product.price_km, locale: :'zh-CN', precision: 2)
                else
                        return number_to_currency(product.price_bj, locale: :'zh-CN', precision: 2)
                end
        end

        def price_range(product)
                unless product.is_bulk?
                        return number_to_currency(product.price, locale: :'zh-CN', precision: 2)
                end
                return number_to_currency(product.min_price, locale: :'zh-CN', precision: 2) + " ~ " + number_to_currency(product.max_price, locale: :'zh-CN', precision: 2)
        end

        def graph_datetime(date)
                date.strftime("%m月%d日%H时") if date.present?
        end
end
