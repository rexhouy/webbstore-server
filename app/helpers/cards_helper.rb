module CardsHelper

        def delivery_address(card)
                return "" unless card.contact_address.present?
                "#{card.contact_address} | #{card.contact_name} | #{card.contact_tel}"
        end

end
