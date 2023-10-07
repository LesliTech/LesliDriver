=begin

Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end


FactoryBot.define do
    factory :cloud_driver_event, class: "CloudDriver::Event" do
        cloud_driver_accounts_id { Account.first.driver.id }

        cloud_driver_calendars_id do
            Account.find(cloud_driver_accounts_id).driver.calendars.default(User.first).id
        end

        users_id do
            default_account = Account.find(cloud_driver_accounts_id)

            default_user = default_account.users.first

            if default_user
                default_user.id
            else
                new_user = FactoryBot.create(:user, account: default_account)
                new_user.id
            end
        end

        user_main_id do
            default_account = Account.find(cloud_driver_accounts_id)

            default_user = default_account.users.order("random()").first

            if default_user
                default_user.id
            else
                new_user = FactoryBot.create(:user, account: default_account)
                new_user.id
            end
        end

        cloud_driver_catalog_event_types_id do
            default_account = Account.find(cloud_driver_accounts_id).driver

            event_type = default_account.event_types.order("random()").first

            if event_type
                event_type.id
            else
                new_event_type = FactoryBot.create(:cloud_driver_catalog_event_type, cloud_driver_accounts_id: default_account.id)
                new_event_type.id
            end
        end

        title { Faker::Sports::Football.competition }

        description { Faker::Lorem.sentence(word_count: 10, supplemental: true) }

        event_date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 3.days) }

        time_start { event_date }

        time_end { Faker::Time.between(from: time_start, to: time_start + 3.days) }

        public { Faker::Boolean.boolean }

        location { Faker::Address.full_address }

        budget { Faker::Number.number(digits: 3).to_f }

        real_cost { Faker::Number.number(digits: 3).to_f }

        signed_up_count { Faker::Number.number(digits: 3) }

        showed_up_count { Faker::Number.number(digits: 3) }


    end
end
