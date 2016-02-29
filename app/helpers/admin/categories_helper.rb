# -*- coding: utf-8 -*-
module Admin::CategoriesHelper

        def channel_name(category)
                names = category.channels.inject("") do |name, c|
                        name << c.name << "，"
                end
                return names[0...-1] unless names.blank?
                names
        end

        def channel_check_boxes
                collection_check_boxes(:category, :channel_ids, Channel.owner(current_user.id).where(id: [2, 3]), :id, :name)
        end

end
