# -*- coding: utf-8 -*-
module Api::ProductsHelper

        def specification_group(specifications)
                specifications.reduce(Hash.new) do |group, spec|
                        (group[spec.name] ||= []) << spec
                        group
                end
        end

        def title(type)
                return "定制产品" if type.eql? "custom"
                return "生态产品" if type.eql? "organic"
                "所有产品"
        end
end
