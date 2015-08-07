class Ability
	include CanCan::Ability

	def initialize(user)
		if user.nil?
		elsif user.admin?
			can :manage, [User, Group]
		elsif user.seller?
			can :manage, [Product, Order]
		end
	end
	
end
