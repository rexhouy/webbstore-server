class Trade < ActiveRecord::Base

        scope :date_end, lambda { |value| where("time <= ?", Date.parse(value).end_of_day) }
        scope :date_start, lambda { |value| where("time >= ?", Date.parse(value).beginning_of_day) }
        scope :supplier, lambda { |value| where(supplier: value) }

        def self.filter(attributes)
                supported_filters = [:date_start, :date_end, :supplier]
                attributes.slice(*supported_filters).inject(self) do |scope, (key, value)|
                        value.present? ? scope.send(key, value) : scope
                end
        end

        def self.owner(owner_id)
                where(group_id: owner_id)
        end

end

class AlipayTrade < Trade; end
class WechatTrade < Trade; end
class OfflineTrade < Trade; end
