class Supplier < ActiveRecord::Base

	belongs_to :group
	
	#validations
        validates :name, presence: true

	def self.owner(owner)
		where(groups_id: owner)
	end

end
