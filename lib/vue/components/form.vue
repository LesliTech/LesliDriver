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

// · import lesli stores
import { useCalendar } from 'CloudDriver/stores/calendar'
import { useEvent } from 'CloudDriver/stores/event'

// · implement stores
const storeCalendar = useCalendar()
const storeEvent = useEvent()

const translations = {
    events: I18n.t('driver.events'),
    core: I18n.t('core.shared'),
}

const submitEvent = () => {
    if (storeCalendar.event.id) {
        storeCalendar.putEvent()
    }
    else {
        storeCalendar.postEvent()
    }
}

</script>

<template>
    <form @submit.prevent="submitEvent">
        <fieldset>
            <div class="columns">
                <div class="column">
                    <field label="column_user_main_id">
                        <p>{{ translations.events.column_user_main_id }}</p>
                        <input class="input is-default" type="text" name="organizer_name"
                            v-model="storeCalendar.event.organizer_name" readonly />
                    </field>
                    <field>
                        <p>{{ translations.events.column_title }}</p>
                        <input class="input is-default" type="text" name="title" v-model="storeCalendar.event.title"
                            required />
                    </field>
                    <field>
                        <p>{{ translations.events.column_time_start }}</p>
                        <lesli-calendar v-model="storeCalendar.event.time_start" mode="dateTime">
                        </lesli-calendar>
                    </field>
                    <field>
                        <p>{{ translations.events.column_budget }}
                            ({{ storeCalendar.lesli.settings.currency.symbol }})</p>
                        <input class="input is-default" type="number" name="budget" min="0" step="0.01"
                            v-model="storeCalendar.event.budget" />
                    </field>
                    <field>
                        <p>{{ translations.events.column_showed_up_count }}</p>
                        <input class="input is-default" type="number" name="showed_up_count" min="0" step="1"
                            v-model="storeCalendar.event.showed_up_count" />
                    </field>
                </div>
                <div class="column">
                    <field>
                        <p>{{ translations.events.column_cloud_driver_catalog_event_types_id }}</p>
                        <lesli-select v-model="storeCalendar.event.cloud_driver_catalog_event_types_id" icon="public"
                            :options="storeEvent.options.event_types">
                        </lesli-select>
                    </field>
                    <field>
                        <p>{{ translations.events.column_location }}</p>
                        <input class="input is-default" type="text" name="address"
                            v-model="storeCalendar.event.location" />
                    </field>
                    <field>
                        <p>{{ translations.events.column_time_end }}</p>
                        <lesli-calendar v-model="storeCalendar.event.time_end" mode="dateTime">
                        </lesli-calendar>
                    </field>
                    <field>
                        <p>{{ translations.events.column_real_cost }}
                            ({{ storeCalendar.lesli.settings.currency.symbol }})</p>
                        <input class="input is-default" type="number" name="real_cost" min="0" step="0.01"
                            v-model="storeCalendar.event.real_cost" />
                    </field>
                    <field>
                        <p>{{ translations.events.column_signed_up_count }}</p>
                        <input class="input is-default" type="number" name="signed_up_count" min="0" step="1"
                            v-model="storeCalendar.event.signed_up_count" />
                    </field>
                </div>
            </div>
            <div class="columns">
                <div class="column">
                    <field>
                        <p>{{ translations.events.column_description }}</p>
                        <div class="control">
                            <textarea v-model="storeCalendar.event.description" class="textarea"
                                name="description"></textarea>
                        </div>
                    </field>
                </div>
            </div>
            <div class="columns">
                <div class="column">
                    <field>
                        <label class="checkbox">
                            {{ translations.events.view_text_mark_as_public }}
                            <input type="checkbox" name="public" v-model="storeCalendar.event.public">
                        </label>
                    </field>
                </div>
                <div class="column">
                    <field>
                        <label class="checkbox">
                            {{ "Is proposal?" }}
                            <input type="checkbox" name="is_proposal" v-model="storeCalendar.event.is_proposal">
                        </label>
                    </field>
                    <field v-show="storeCalendar.event.is_proposal">
                        <p>{{ translations.events.column_estimated_duration }}</p>
                        <input class="input is-default" type="number" name="estimated_mins_durations" min="10" step="10"
                            v-model="storeCalendar.event.estimated_mins_durations" />
                    </field>
                </div>
            </div>
            <lesli-button type="submit" icon="save">{{ translations.core.view_btn_save }}</lesli-button>  
        </fieldset>
    </form>

</template>