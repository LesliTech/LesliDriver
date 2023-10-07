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
// ·
*/

// · Import components, libraries and tools
import { onMounted } from 'vue'
import ComponentDiscussions from "LesliVue/cloud-objects/discussion.vue"
import ComponentFiles from "LesliVue/cloud-objects/file.vue"
import ComponentGuests from './guests.vue'
import ComponentForm from './form.vue'

// · import lesli stores
import { useEvent } from 'CloudDriver/stores/event'
import { useCalendar } from 'CloudDriver/stores/calendar'
import { useUsers } from "LesliVue/stores/users"

// · implement stores
const storeEvent = useEvent()
const storeCalendar = useCalendar()
const storeUsers = useUsers()

onMounted(() => {
    storeEvent.getOptions()
    storeUsers.fetchList()
})

const translations = {
    events: I18n.t('driver.events'),
    core: I18n.t('core.shared'),
}

const deleteEvent = async () => {
    await storeCalendar.deleteEvent()
}

</script>

<template>

    <lesli-panel v-model:open="storeEvent.showModal">
        <template #header>
        </template>

        <template #default>
            <lesli-tabs v-if="storeCalendar.event.id" v-model="tab">

                <lesli-tab-item :title="translations.core.view_tab_title_general_information" icon="info">
                    <ComponentForm />
                </lesli-tab-item>

                <lesli-tab-item :title="translations.core.view_btn_discussions" icon="forum">
                    <ComponentDiscussions cloud-module="driver" cloud-object="events"
                        :cloud-object-id="storeCalendar.event.id" :onlyDiscussions="true">
                    </ComponentDiscussions>
                </lesli-tab-item>

                <lesli-tab-item :title="translations.core.view_btn_files" icon="attach_file">
                    <ComponentFiles cloud-module="driver" cloud-object="events"
                        :cloud-object-id="storeCalendar.event.id"
                        :accepted-files="['images', 'documents', 'plaintext']">
                    </ComponentFiles>
                </lesli-tab-item>

                <lesli-tab-item :title="translations.events.view_tab_title_assignments" icon="group">
                    <ComponentGuests />
                </lesli-tab-item>

                <lesli-tab-item :title="translations.events.view_tab_title_delete_section" icon="delete">
                    <button @click="deleteEvent()" class="button is-fullwidth has-text-centered is-danger"
                        :disabled="storeEvent.submit.delete">
                        <span class="delete">{{ translations.core.view_btn_delete }}
                        </span>
                        {{ translations.core.view_btn_delete }}
                    </button>
                </lesli-tab-item>
            </lesli-tabs>

            <ComponentForm v-else />
            
        </template>
    </lesli-panel>

</template>
