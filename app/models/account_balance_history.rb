class AccountBalanceHistory < ActiveRecord::Base

        def self.owner(owner)
                where(user_id: owner)
        end

end
