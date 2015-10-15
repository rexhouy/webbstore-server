class Householder < ActiveRecord::Base

        def self.search(search_text)
                scopes = nil
                if (/\d{11}/ =~ search_text).nil?
                        scopes = where("no = ? or name = ?",  search_text, search_text)
                else
                        scopes = where(tel: search_text)
                end
                scopes
        end

end
