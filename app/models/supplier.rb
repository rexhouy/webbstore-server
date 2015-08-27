class Supplier < ActiveRecord::Base

	belongs_to :group
	
	#validations
        validates :name, presence: true

	def self.owner(owner)
		where(group_id: owner)
	end

end
