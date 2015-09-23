class Staff < ActiveRecord::Base

        def self.owner(group_id)
                where(group_id: group_id)
        end

end
