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
import { useCalendar } from 'CloudDriver/stores/calendar'

// · import lesli stores
import { useUsers } from "LesliVue/stores/users"

// · 
export const useGuests = defineStore("driver.guests", {
    state: () => {
        return {
            main_route: `/driver/events`,
            attendant_options: {
                users: []
            },
            attendants: [],
            guest: {
                name: "",
                email: "",
            },
            lists_synched: false,
            loading: {
                attendants: false,
                options: false
            },
            loaded: {
                attendants: false,
                attendant_options: false
            },
            submit: {
                event: false,
                delete: false,
                guest: false
            },

            translations: {
                main: I18n.t('driver.events'),
                core: I18n.t('core.shared'),
                core_users: I18n.t('core.users')
            }
        }
    },

    actions: {

        getUsers() {
            const storeUsers = useUsers()
            try {
                this.loading.attendants = false
                this.attendant_options.users = storeUsers.list.map(user => {
                    const foundAttendant = this.attendants.find(attendant => attendant.email === user.email);
                    return {
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        checked: !!foundAttendant
                    };
                });
            } catch (error) {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            } finally {
                this.loaded.attendant_options = true
            }
        },

        getAttendants() {
            const storeCalendar = useCalendar()
            let url = `${this.main_route}/${storeCalendar.event.id}/attendants.json`
            this.loading.attendants = true
            this.http.get(url).then(result => {
                this.loading.attendants = false
                const filteredAttendant = result.filter((attendant, index, self) =>
                    self.findIndex(record => record.email === attendant.email) === index
                )
                this.attendants = filteredAttendant
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.loaded.attendants = true
            })
        },


        postAttendant(user) {
            const storeCalendar = useCalendar()
            let url = this.url.driver("events/:event_id/attendants", { event_id: storeCalendar.event.id })
            let data = {
                event_attendant: {
                    users_id: user.id
                }
            }
            this.http.post(url, data).then(result => {
                this.attendants.push({
                    id: result.id,
                    type: 'attendant',
                    name: user.name || user.email,
                    email: user.email,
                    users_id: user.id,
                    confirmed_at_string: null
                })
                this.msg.success(this.translations.main.messages_success_attendant_created)

            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        },

        postGuest() {
            const storeCalendar = useCalendar()
            let url = this.url.driver("events/:event_id/guests", { event_id: storeCalendar.event.id })
            this.submit.guest = true

            this.http.post(url, {
                event_guest: this.guest
            }).then(result => {
                this.attendants.push({
                    ...result,
                    type: 'guest',
                    name: result.name || result.email,
                })
                this.guest = {}
                this.msg.success(this.translations.main.messages_success_attendant_created)

            }).catch(error => {
                this.msg.danger(this.translations.core.shared.messages_danger_internal_error);
            }).finally(() => {
                this.submit.guest = false
            })
        },

        confirmAttendance(user, today) {
            const storeCalendar = useCalendar();
            let url, data;

            this.loading.attendants = true;

            if (user.users_id) {
                url = this.url.driver("events/:event_id/attendants/:attendant_id", {
                    event_id: storeCalendar.event.id,
                    attendant_id: user.id
                });
                data = { event_attendant: user };
            } else {
                url = this.url.driver("events/:event_id/guests/:attendant_id", {
                    event_id: storeCalendar.event.id,
                    attendant_id: user.id
                });
                data = { event_guest: user };
            }

            this.http.put(url, data)
                .then(result => {
                    const attendantIndex = this.attendants.findIndex(attendant => attendant.email === user.email);
                    this.attendants[attendantIndex].confirmed_at_string = today;
                    this.msg.success(this.translations.core_users.messages_success_operation);
                })
                .catch(error => {
                    this.msg.danger(this.translations.core.shared.messages_danger_internal_error);
                })
                .finally(() => {
                    this.loading.attendants = false;
                });
        },

        deleteInvite(user) {
            const storeCalendar = useCalendar()

            const index = this.attendant_options.users.findIndex(attendant => attendant.email === user.email);
            if (index !== -1) {
                this.attendant_options.users[index].checked = false;
            }

            let attendant = this.attendants.find(attendant => {
                return attendant.email === user.email
            })
            let url = `${this.main_route}/${storeCalendar.event.id}/attendants/${attendant.id}.json`

            // If this is a guest, we have a different endpoint
            if (user.type == 'guest') {
                url = `${this.main_route}/${storeCalendar.event.id}/guests/${attendant.id}.json`
            }
            this.submit.delete = true
            this.http.delete(url).then(result => {
                this.attendants = this.attendants.filter((attendant) => {
                    return attendant.email !== user.email
                })

                this.msg.success(this.translations.main.messages_success_attendant_deleted)
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            }).finally(() => {
                this.submit.delete = false
            })
        },
    }
})