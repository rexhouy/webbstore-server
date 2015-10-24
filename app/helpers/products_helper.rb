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
end
