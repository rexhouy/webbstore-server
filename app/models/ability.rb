class Ability
	include CanCan::Ability

	def initialize(user)
		if user.admin?
			can :manage, [User, Product, Order, Category, Trade, Group]
		elsif user.seller?
			can :manage, [Order, Trade]
		end
	end

end
