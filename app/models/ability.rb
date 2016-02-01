class Ability
	include CanCan::Ability

	def initialize(user)
		if user.admin?
			can :manage, [User, Product, Order, Article, Supplier, Channel, Category, Trade, Coupon, Group, Reservation, DinningTable]
		elsif user.seller?
			can :manage, [Product, Order, DinningTable]
		elsif user.waiter?
			can :manage, [Order]
		elsif user.shop_manager?
			can :manage, [Shop, Product, Order]
		end
	end

end
