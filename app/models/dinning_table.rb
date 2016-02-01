# -*- coding: utf-8 -*-
class DinningTable < ActiveRecord::Base
	belongs_to :group

	validate :table_no_uniqueness
	private
	def table_no_uniqueness
		return unless self.table_no_changed?
		errors.add(:table_no, "已经存在！") if DinningTable.where(group_id: self.group_id, table_no: self.table_no).size > 0
	end
	
end
