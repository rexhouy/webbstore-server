# -*- coding: utf-8 -*-
class DinningTable < ActiveRecord::Base
	belongs_to :group

	def self.owner(owner)
		where(group_id: owner)
	end

        def self.availble(group_id, table_id)
                where(id: table_id, group_id: group_id).present?
        end
	
	validate :table_no_uniqueness
	private
	def table_no_uniqueness
		return unless self.table_no_changed?
		errors.add(:table_no, "已经存在！") if DinningTable.where(group_id: self.group_id, table_no: self.table_no).size > 0
	end
	
end
