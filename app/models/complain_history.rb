class ComplainHistory < ActiveRecord::Base
        belongs_to :complain
        belongs_to :user

        enum status: [:created, :processing, :finished]
end
