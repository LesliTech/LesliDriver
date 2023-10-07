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


# IMPORTANT: Seed files are only for development, if you need to create default resources for production
# you must use the initializer method in the Engine account model
if Rails.env.development? 
    L2.msg("Loading seeds for CloudDriver environment", "Version: #{CloudDriver::VERSION}", "Build: #{CloudDriver::BUILD}")
    load CloudDriver::Engine.root.join("db", "seed", "#{ Rails.env.downcase }.rb")
end 
