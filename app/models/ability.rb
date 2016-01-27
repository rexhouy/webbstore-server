class Ability
	include CanCan::Ability

	def initialize(user)
		if user.admin?
			can :manage, [User, Product, Order, Category, Trade, Group, DinningTable]
		elsif user.seller?
			can :manage, [Order, Trade, DinningTable]
		end
	end

end
