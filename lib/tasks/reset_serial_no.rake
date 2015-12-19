desc "Reset serial no"
task reset_serial_no: :environment do
        SerialNo.reset
end
