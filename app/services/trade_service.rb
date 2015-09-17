require "json"

class TradeService

        ## Trade from orders
        def generate_trade_info
                balance = get_latest_balance
                supplier_balance = {}

                # handle yesterday paid orders
                get_orders_yesterday.each do |o|
                        trades = order_to_trade(o[0], o[1])

                        trades.each do |trade|
                                # calculate balance
                                balance += trade.receipt
                                trade.balance = balance

                                # calculate supplier balance
                                supplier_balance[trade.supplier] ||= get_latest_supplier_balance(trade.supplier)
                                supplier_balance[trade.supplier] += trade.receipt
                                trade.supplier_balance = supplier_balance[trade.supplier]

                                # save trade info
                                trade.save!
                        end
                end
        end

        def order_to_trade(order, trade_time)
                trade = Trade.new
                trade.payer = order.customer.tel
                trade.order_no = order.order_id
                trade.disbursement = 0
                trade.group_id = order.seller_id
                trade.time = trade_time
                trade.type = trade_type(order)
                trade.trade_no = trade_no(order.payment)
                split_trade_by_supplier(trade, order)
        end
        private
        ## An order may contain many products from different suppliers. Split order into multiple trades grouped by supplier.
        def split_trade_by_supplier(trade, order)
                # group by supplier
                # {supplier: price}
                orders_grouped_by_supplier = order.orders_products.reduce(Hash.new) do |group, op|
                        supplier = op.product.supplier.name if op.product.supplier.present?
                        group[supplier] ||= 0
                        group[supplier] += op.price * op.count
                        group
                end
                trades = []
                orders_grouped_by_supplier.each do |k, v|
                        t = trade.dup
                        t.supplier = k
                        t.receipt = v
                        trades << t
                end
                trades
        end
        def trade_type(order)
                return "AlipayTrade" if order.alipay?
                return "WechatTrade" if order.wechat?
                return "OfflineTrade" if order.offline_pay?
                nil
        end
        def trade_no(payment)
                info = JSON.parse(payment.trade_info) if payment.present? && payment.trade_info.present?
                return nil if info.nil?
                info["transaction_id"].present? ? info["transaction_id"] : info["trade_no"]
        end
        def get_latest_balance
                trade = Trade.order(time: :desc).first
                return trade.balance  if trade.present?
                0
        end
        def get_latest_supplier_balance(supplier)
                trade = Trade.where(supplier: supplier).order(time: :desc).first
                return trade.supplier_balance  if trade.present?
                0
        end
        ## Get yesterday paid online pay orders and finished offline pay orders.
        # TODO add offline pay orders support
        def get_orders_yesterday
                histories = OrderHistory.where(status: OrderHistory.statuses[:paid])
                        .where(time: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day)
                        .order(time: :asc)
                histories.map do |h|
                        [h.order, h.time]
                end
        end

end
