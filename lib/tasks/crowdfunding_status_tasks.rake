desc "Run crowdfunding status update job"
task update_crowdfunding_status: :environment do
        CrowdfundingService.new.update_status
end
