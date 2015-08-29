class CreateCaptchas < ActiveRecord::Migration
        def change
                create_table :captchas do |t|

                        t.string :tel, :primary_key, null: false, limit: 11
                        t.string :register_token, null: false, limit: 6
                        t.datetime :register_sent_at, null: false

                        t.timestamps null: false
                end


        end
end
