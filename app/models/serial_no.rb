class SerialNo < ActiveRecord::Base

        def self.take
                no = self.new
                no.save
                no.id
        end

        def self.reset
                ActiveRecord::Base.connection.execute "truncate table serial_nos"
        end

end
