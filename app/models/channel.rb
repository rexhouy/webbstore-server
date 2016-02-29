class Channel < ActiveRecord::Base
        has_and_belongs_to_many :categories
        has_and_belongs_to_many :products

        def self.owner(owner_id)
                where(group_id: owner_id)
        end

end
