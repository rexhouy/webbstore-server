class Complain < ActiveRecord::Base
        belongs_to :staff
        belongs_to :user
        belongs_to :order
        has_many :histories, class_name: "ComplainHistory", foreign_key: :complain_id

        enum status: [:created, :processing, :finished]

        before_create do
                self.status = Complain.statuses[:created]
        end

        def self.owner(owner)
                where(group_id: owner)
        end

        def self.search(name_or_tel, complain_date)
                scopes = nil
                unless name_or_tel.blank?
                        # test if it is name or tel
                        if (/\d{11}/ =~ name_or_tel).nil?
                                scopes = where(contact_name: name_or_tel)
                        else
                                scopes = where(contact_tel: name_or_tel)
                        end
                end
                unless complain_date.blank?
                        d = Date.parse(complain_date)
                        if scopes
                                scopes = scopes.where(created_at: d.beginning_of_day..d.end_of_day)
                        else
                                scopes = where(created_at: d.beginning_of_day..d.end_of_day)
                        end
                end
                scopes || all
        end

end
class OrderComplain < Complain
end

class RepairComplain < Complain
end
