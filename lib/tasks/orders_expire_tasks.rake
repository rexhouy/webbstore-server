desc "Run order expires job"
task expire_orders: :environment do
	OrderService.new.cancel_automate
end
