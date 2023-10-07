/*

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

*/

// · 
import { defineStore } from "pinia"

// · 
export const useEvent = defineStore("driver.event", {
    state: () => {
        return {
            showModal: false,
            options: {
                event_types: []
            },
            submit: {
                event: false,
                delete: false
            },
        }
    },

    actions: {

        getOptions() {
            let url = this.url.driver('events/options')
            this.http.get(url).then(result => {
                if (result) {
                    this.options.event_types = result.event_types.map(option => {
                        return { label: option.text, value: option.value };
                    });
                }
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },
    }
})