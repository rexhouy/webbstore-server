class Card < ActiveRecord::Base

        belongs_to :user
        belongs_to :specification
        belongs_to :order
        has_many :card_history

        enum status: [:open, :closed, :unpaid, :canceled]

end
