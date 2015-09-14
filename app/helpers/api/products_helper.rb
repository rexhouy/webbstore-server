# -*- coding: utf-8 -*-
module Api::ProductsHelper

        def specification_group(specifications)
                specifications.reduce(Hash.new) do |group, spec|
                        (group[spec.name] ||= []) << spec
                        group
                end
        end

        def title(channel)
                return "所有菜品" if channel.nil?
                channel.name
        end

        def cart_count(product, cart)
                return 0 if cart.nil?
                existIndex = cart.index do |p|
                        puts "#{p.inspect}           #{product.id}      eqls ?    #{p['id'].eql? product.id.to_s} "
                        p["id"].eql? product.id.to_s
                end
                return cart[existIndex]["count"] unless existIndex.nil?
                0
        end

end
