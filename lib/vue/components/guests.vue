<script setup>

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
*/

// · Import components, libraries and tools
import { onMounted, inject } from "vue"

// · import lesli stores
import { useGuests } from 'CloudDriver/stores/guests'
import { useCalendar } from 'CloudDriver/stores/calendar'

// · implement stores
const storeGuests = useGuests()
const storeCalendar = useCalendar()

// · initialize/inject plugins
const date = inject("date")
const today = date.date(new Date())

onMounted(() => {
    storeGuests.getAttendants()
    storeGuests.getUsers()
})

function submitAttendant(user) {
    user.checked = !user.checked;
    if (user.checked) storeGuests.postAttendant(user)
    else storeGuests.deleteInvite(user)
}

function confirmedInvitesCount() {
    return storeGuests.attendants.filter(attendant => attendant.confirmed_at_string).length
}

function totalInvitesCount() {
    return storeGuests.attendants.length
}

const translations = {
    main: I18n.t('driver.events'),
    core: I18n.t('core.shared'),
    core_users: I18n.t('core.users'),
    users: I18n.t('deutscheleibrenten.users'),
    attendants: I18n.t('driver.event/attendants')
}

const usersTableColumns = [
    { field: 'name', label: translations.core.view_text_name },
    { field: 'email', label: translations.core.view_text_email }
]

const attendantsTableColumns = [
    { field: 'name', label: translations.core.view_text_name },
    { field: 'email', label: translations.core.view_text_email }
]

</script>

<template>
    <h5 class="title is-5">
        {{ translations.attendants.view_title_confirmed_invites_count }}: {{ confirmedInvitesCount() }} /
        {{ translations.attendants.view_title_total_invites_count }}: {{ totalInvitesCount() }}
    </h5>
    <lesli-tabs v-model="tab">

        <lesli-tab-item :title="translations.main.view_tab_title_users" icon="person_search">
            <lesli-toolbar @search="a"></lesli-toolbar>
            <lesli-table :columns="usersTableColumns" :records="storeGuests.attendant_options.users">
                <template #buttons="{ record }">
                    <input type="checkbox" v-model="record.checked" @input="submitAttendant(record)"
                        :checked="storeGuests.attendant_options.users.checked">
                </template>
            </lesli-table>
        </lesli-tab-item>

        <lesli-tab-item :title="translations.main.view_tab_title_guests" icon="group_add">
            <form @submit.prevent="storeGuests.postGuest">
                <fieldset>
                    <div class="columns">
                        <div class="column">
                            <field label="column_user_main_id">
                                <p>{{ translations.core.view_text_name }}</p>
                                <input class="input is-default" type="text" name="guest_name"
                                    v-model="storeGuests.guest.name" />
                            </field>
                            <field label="column_user_main_id">
                                <p>{{ translations.core.view_text_email }}</p>
                                <input class="input is-default" type="email" name="guest_email"
                                    v-model="storeGuests.guest.email" />
                            </field>
                            <div class="buttons">
                                <button name="btn-save" type="submit" class="button is-primary is-fullwidth">
                                    <span><span class="icon is-small"><i class="fas fa-save"></i></span>&nbsp;</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </form>
        </lesli-tab-item>

        <lesli-tab-item :title="translations.main.view_tab_title_attendants_list" icon="groups">
            <lesli-table :columns="attendantsTableColumns" :records="storeGuests.attendants">
                <template #buttons="{ record }">

                    <button @click="storeGuests.confirmAttendance(record, today)" class="button is-success" :disabled="record.confirmed_at_string">
                        <span v-if="!record.confirmed_at_string && !storeGuests.loading.attendants">
                            {{ translations.main.view_text_click_to_confirm }}
                        </span>
                        <span v-if="storeGuests.loading.attendants">
                            <i class="fas fa-spin fa-circle-notch"></i>
                        </span>
                        <span  v-if="record.confirmed_at_string && !storeGuests.loading.attendants">
                            {{ record.confirmed_at_string }}
                        </span>
                    </button>

                    <button  @click="storeGuests.deleteInvite(record)"
                    class="button is-outlined is-danger">
                        <span v-if="storeGuests.submit.delete">
                            <i class="fas fa-spin fa-circle-notch"></i> {{
                                translations.core.view_btn_deleting
                            }}
                        </span>
                        <span v-else>
                            <i class="fas fa-trash-alt"></i> {{ translations.core.view_btn_delete }}
                        </span>
                    </button>
                </template>
            </lesli-table>
        </lesli-tab-item>

    </lesli-tabs>
</template>