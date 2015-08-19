class Ability
	include CanCan::Ability

	def initialize(user)
		if user.admin?
			can :manage, [User, Group]
		elsif user.seller?
			can :manage, [Product, Order, Article]
		end
	end
	
end
