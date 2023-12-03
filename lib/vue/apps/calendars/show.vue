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


// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from "vue-router"


// · 
const useDate = inject("date")
const date = useDate()


// · Import components
import componentCalendar from "LesliDriver/components/calendar.vue"
import componentAgenda from "LesliDriver/components/agenda.vue"
import componentPanelEvent from "LesliDriver/components/event.vue"

</script>
<template>
    <lesli-application-container dashboard>
        <lesli-header :title="date.dateWords()">
            <div class="field has-addons m-0">
                <div class="control">
                    <lesli-button icon="arrow_back_ios">
                        prev
                    </lesli-button>
                </div>
                <div class="control">
                    <lesli-button>
                        today
                    </lesli-button>
                </div>
                <div class="control">
                    <button class="button is-primary is-light is-outlined">
                        <span>next</span>
                        <span class="icon">
                            <span class="material-icons">
                                arrow_forward_ios
                            </span>
                        </span>
                    </button>
                </div>
            </div>

            <lesli-button main icon="add">
                Add event
            </lesli-button>
        </lesli-header>
        <div class="columns">
            <div class="column is-3">
                <component-agenda>
                </component-agenda>
            </div>
            <div class="column">
                <component-calendar class="mt-4">
                </component-calendar>
            </div>
        </div>

        <component-panel-event></component-panel-event>
    </lesli-application-container>
</template>
