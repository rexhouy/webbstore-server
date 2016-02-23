class Crowdfunding < ActiveRecord::Base
        belongs_to :product

        validates_presence_of :threshold, :start_date, :end_date, :delivery_date, :price_km, :price_bj

        enum status: [:unknown, :succeed, :failed]

        before_save do
                self.end_date = self.end_date.end_of_day
        end


end
