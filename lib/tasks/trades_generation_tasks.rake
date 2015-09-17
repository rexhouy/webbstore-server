desc "Run trade generation job"
task gen_trade_info: :environment do
        TradeService.new.generate_trade_info
end
