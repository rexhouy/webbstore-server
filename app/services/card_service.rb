# -*- coding: utf-8 -*-
class CardService

        def create(order, user_id)
                order.orders_products.each do |op|
                        spec = op.specification
                        next unless spec.present? && spec.count.present? && spec.count > 1
                        card = Card.new
                        card.name = op.product.name
                        card.user_id = user_id
                        card.specification_id = spec.id
                        card.order_id = order.id
                        card.count = spec.count
                        card.remain = spec.count
                        card.status = order.paid? ? Card.statuses[:open] : Card.statuses[:unpaid]
                        card.next = Date.today.next_week(:wednesday) if card.open?
                        card.contact_name = order.contact_name
                        card.contact_tel = order.contact_tel
                        card.contact_address = order.contact_address
                        card.save!
                        create_card_history(card)
                end
        end

        private
        def create_card_history(card)
                card_history = CardHistory.new
                card_history.card = card
                card_history.remain = card.remain
                card_history.memo = "新建"
                card_history.save!
        end

end
