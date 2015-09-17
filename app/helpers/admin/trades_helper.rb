# -*- coding: utf-8 -*-
module Admin::TradesHelper
        def trade_type(trade)
                return "支付宝" if trade.type.eql? "AlipayTrade"
                return "微信支付" if trade.type.eql? "WechatTrade"
                return "线下支付" if trade.type.eql? "OfflineTrade"
                "未知"
        end
end
