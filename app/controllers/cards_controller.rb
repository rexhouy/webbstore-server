# -*- coding: utf-8 -*-
class CardsController < ApplicationController

        def index
                @cards = current_user.cards
        end

        def history
                @card = Card.find(params[:id])
                @card.card_history
        end

        def delay
                card = Card.find(params[:id])
                next_delivery = card.next.next_week(:wednesday)
                card.update(next: next_delivery)
                redirect_to cards_url(card), notice: "\"#{card.name}\"下次配送时间：#{next_delivery}"
        end

        def open
                card = Card.find(params[:id])
                next_delivery = Date.today.next_week(:wednesday)
                address = params[:state] + params[:city] + params[:street]
                card.update(next: next_delivery, contact_name: params[:name], contact_tel: params[:tel], contact_address: address, status: Card.statuses[:open])
                redirect_to cards_url(card), notice: "操作成功，\"#{card.name}\"下次配送时间：#{next_delivery}"
        end

        def gift
                receiver = User.find_by_tel(params[:tel])
                return redirect_to(cards_url(params[:id]), notice: "操作失败，接收人#{params[:tel]}不存在") if receiver.nil?
                return redirect_to(cards_url(params[:id]), notice: "操作失败，不能赠送给自己") if receiver.id.eql? current_user.id
                # Create new card for receiver
                old_card = Card.find(params[:id])
                card = Card.new
                card.user_id = receiver.id
                card.name = old_card.name
                card.specification_id = old_card.specification_id
                card.count = old_card.remain
                card.remain = old_card.remain
                card.status = Card.statuses[:closed]
                card.from = old_card.id

                Order.transaction do
                        card.save!
                        # Update card set remain to 0
                        old_card.update(remain: 0)
                        # Add card history
                        save_history(old_card, card)
                end
                redirect_to cards_url(params[:id]), notice: "\"#{card.name}\"已经赠送给#{params[:tel]}"
        end

        private
        def save_history(old_card, card)
                old_history = CardHistory.new
                old_history.card_id = old_card.id
                old_history.remain = 0
                old_history.memo = "赠送给#{params[:tel]}"

                history = CardHistory.new
                history.card_id = card.id
                history.remain = card.remain
                history.memo = "#{current_user.tel}赠送"

                old_history.save!
                history.save!
        end

end
