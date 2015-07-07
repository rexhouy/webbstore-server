require '../../app/services/sms_service'
require 'test/unit'

class SmsServiceTest < Test::Unit::TestCase
        # def setup
        # end

        # def teardown
        # end

        def test_send_captcha
                SmsService.new.send_captcha("123456", "13914798831")
        end

end
