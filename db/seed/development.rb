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


# delete all the existing events
CloudDriver::Event.all.delete_all

# create demo events for all the users
# NOTE: There is bug in the service, it does not use the user calendar to create the event
#User.all.each do |current_user|

    current_user = User.first

    # create 10 events for every user
    10.times do |days|

        date = days.days.from_now

        CloudDriver::EventServices.create(current_user,
            :title => Faker::Fantasy::Tolkien.character,
            :description => Faker::Fantasy::Tolkien.poem,
            :event_date => date,
            :time_start => date,
            :time_end => date,
            :location => Faker::Fantasy::Tolkien.location
        )

        date = days.days.ago

        CloudDriver::EventServices.create(current_user,
            :title => Faker::Fantasy::Tolkien.character,
            :description => Faker::Fantasy::Tolkien.poem,
            :event_date => date,
            :time_start => date,
            :time_end => date,
            :location => Faker::Fantasy::Tolkien.location
        )
    end
#end
