# -*- coding: utf-8 -*-
module ComplainsHelper

        def complain_status(complain)
                return "尚未处理" if complain.created?
                return "处理中" if complain.processing?
                return "已处理" if complain.finished?
                "未知"
        end

        def complain_staff(staff)
                return staff.name if staff.present?
                "-"
        end

        def complain_type(complain)
                return "订单投诉" if complain.type.eql? "OrderComplain"
                return "报修" if complain.type.eql? "RepairComplain"
                "未知"
        end

end
