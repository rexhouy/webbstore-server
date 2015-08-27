class Channel < ActiveRecord::Base

        def self.owner(owner_id)
                where(group_id: owner_id)
        end

end
