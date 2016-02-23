class CrowdfundingService

        def update_status
                Crowdfunding.where("end_date <= ? and status = ?", Time.now, Crowdfunding.statuses[:unknown]).all.each do |c|
                        status = c.product.sales >= c.threshold ? Crowdfunding.statuses[:succeed] : Crowdfunding.statuses[:failed]
                        c.update(status: status)
                end
        end

end
