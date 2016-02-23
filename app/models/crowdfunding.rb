class Crowdfunding < ActiveRecord::Base
        belongs_to :product

        validates_presence_of :threshold, :start_date, :end_date, :delivery_date, :price_km, :price_bj

        enum status: [:unknown, :succeed, :failed]

end
