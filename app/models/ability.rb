class Ability
	include CanCan::Ability

	def initialize(user)
		if user.admin?
			can :manage, [User, Product, Order, Article, Supplier, Channel, Category, Trade, Coupon]
		elsif user.seller?
			can :manage, [Product, Order]
		elsif user.group_admin?
			can :manage, [Group]
		end
	end

end
