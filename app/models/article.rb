class Article < ActiveRecord::Base
        validates :title, presence: true
        validates :content, presence: true

        def self.owner(owner)
                where(groups_id: owner)
        end
end
