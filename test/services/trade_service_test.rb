require 'test_helper'

class TradeServiceTest < ActiveSupport::TestCase

        test "it create trades" do
                trades = TradeService.new.order_to_trade(Order.first, nil)
                trades.each do |t|
                        p t.inspect
                end
        end

end
