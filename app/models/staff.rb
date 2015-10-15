class Staff < ActiveRecord::Base

        def self.owner(group_id)
                where(group_id: group_id)
        end

        def self.search(name_or_tel)
                scopes = nil
                # test if it is name or tel
                if (/\d{11}/ =~ name_or_tel).nil?
                        scopes = where(name: name_or_tel)
                else
                        scopes = where(tel: name_or_tel)
                end
                scopes
        end

end
