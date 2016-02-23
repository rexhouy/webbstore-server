module Crowdfundings::ProductsHelper

        def corwdfunding_progress(product)
                product.sales * 100 / product.crowdfunding.threshold
        end

end
