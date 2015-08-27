# -*- coding: utf-8 -*-
module Api::ProductsHelper

        def specification_group(specifications)
                specifications.reduce(Hash.new) do |group, spec|
                        (group[spec.name] ||= []) << spec
                        group
                end
        end

        def title(channel)
                return "所有产品" if channel.nil?
                channel.name
        end
end
