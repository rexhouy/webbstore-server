#coding: utf-8
require 'net/http'

class PrintService

        IP = "http://dzp.feieyun.com"
        HOST = "/FeieServer"


        #方法1，打印订单(内容)============================
        #***方法1返回值有如下几种***
        #{"responseCode":0,"msg":"服务器接收订单成功","orderindex":"xxxxxxxxxxxxxxxxxx"}
        #{"responseCode":1,"msg":"打印机编号错误"};
        #{"responseCode":2,"msg":"服务器处理订单失败"};
        #{"responseCode":3,"msg":"打印内容太长"};
        #{"responseCode":4,"msg":"请求参数错误"};
        def print(order)
                #标签说明："<BR>"为换行符,"<CB></CB>"为居中放大,"<B></B>"为放大,"<C></C>"为居中,"<L></L>"为字体变高
                #"<QR></QR>"为二维码,"<CODE>"为条形码,后面接12个数字

                content = "<CB>#{order.seller.name}</CB><BR>"
                content << "<B>订单号: #{order.simple_order_no}</B><BR>"
                content << "名称　　　　　 单价  数量 金额<BR>"
                content << "--------------------------------<BR>";
                order.orders_products.each do |op|
                        name = ""
                        7.times do |index|
                                if op.product.name.size > index
                                        name << op.product.name[index]
                                else
                                        name << "　"
                                end
                        end
                        content << ("%s %-6s %-2s  %s<BR>" % [name, op.price.to_s, op.count.to_s, (op.price * op.count).to_s])
                end
                content << "--------------------------------<BR>";
                content << "合计：#{order.subtotal}元<BR>";
                content << "订餐时间：#{order.updated_at.strftime('%Y-%m-%d %H:%M:%S')}<BR>";

                params = {}
                params["sn"] = order.seller.printer_sn
                params["key"] = order.seller.printer_key
                params["printContent"] = content #打印内容
                params["times"] = "1" #打印联数
                uri = URI.parse(IP+HOST+"/printOrderAction")
                res = Net::HTTP.post_form(uri, params)
                Rails.logger.info res.body
                response = JSON.parse(res.body)
                if response["responseCode"].eql? 0
                        order.update(print_index: response["orderindex"])
                        return true
                end
                false
        end


        #方法2，根据订单索引,去查询订单是否打印成功,订单索引由方法1返回=================
        #{"responseCode":0,"msg":"已打印"};
        #{"responseCode":0,"msg":"未打印"};
        #{"responseCode":1,"msg":"请求参数错误"};
        #{"responseCode":2,"msg":"没有找到该索引的订单"};
        def queryOrderState(strindex, printer_sn, printer_key)
                params = {}
                params["sn"] = printer_sn
                params["key"] = key
                params["index"] = strindex #订单索引
                uri = URI.parse(IP+HOST+"/queryOrderStateAction")
                res = Net::HTTP.post_form(uri, params)
                puts res.body
        end


        #方法3，查询指定打印机某天的订单详情=========================
        #***方法3返回值有如下几种(print:已打印,waiting:未打印)***
        #{"responseCode":0,"print":"xx","waiting":"xx"};
        #{"responseCode":1,"msg":"请求参数错误"};
        def queryOrderInfoByDate(strdate, printer_sn, printer_key)
                params = {}
                params["sn"] = PRINTER_SN
                params["key"] = KEY
                params["date"] = strdate #日期,格式为yyyy-MM-dd
                uri = URI.parse(IP+HOST+"/queryOrderInfoAction")
                res = Net::HTTP.post_form(uri, params)
                puts res.body
        end

        #方法4，查询打印机的状态==============================
        #***方法4返回值有如下几种***
        #{"responseCode":0,"msg":"离线"};
        #{"responseCode":0,"msg":"在线,工作状态正常"}
        #{"responseCode":0,"msg":"在线,工作状态不正常"}
        #{"responseCode":1,"msg":"请求参数错误"};
        def queryPrinterStatus(printer_sn, printer_key)
                params = {}
                params["sn"] = printer_sn
                params["key"] = printer_key
                uri = URI.parse(IP+HOST+"/queryPrinterStatusAction")
                res = Net::HTTP.post_form(uri, params)
                puts res.body
        end

end
