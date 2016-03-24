class SmsJob < ActiveJob::Base
        queue_as :sms

        def perform(*args)
                SmsService.new.send(args[0], args[1])
        end
end
