class Ability
	include CanCan::Ability

	def initialize(user)
		if user.admin?
			can :manage, [User, Product, Order, Category, Trade, Group]
		elsif user.seller?
			can :manage, [Product, Order]
		elsif user.shop_manager?
			can :manage, [Shop, Product, Order]
		end
	end

end
