#define OVERKEY_JAMMER_ON "JAM_ON"
#define OVERKEY_JAMMER_OFF "JAM_OFF"

/obj/machinery/jammer
	name = "Oberth Portable Signal Jammer"
	desc = "A big, magnetically floor-attached jammer, will render any AI signals unuseable in a 60 tile radius"
	icon = 'icons/obj/jamming.dmi'
	icon_state = "jammer_stationary4"
	anchored = FALSE
	density = TRUE
	var/datum/component/overlay_manager/overlay_manager

/obj/machinery/jammer/Initialize(mapload, d)
	. = ..()
	var/datum/component/jamming/our_jammer = AddComponent(/datum/component/jamming)
	our_jammer.radius = 60
	our_jammer.power = 10
	var/datum/component/overlay_manager/overlay_manager = AddComponent(/datum/component/overlay_manager)

/obj/machinery/jammer/attack_hand(mob/user)
	var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
	our_jammer.Toggle()
	to_chat(user,  "You toggle the [src] [our_jammer.active ? "on" : "off"]")

/obj/item/device/jammer
	name = "Oberth Mobile Jammer"
	desc = "A small, portable jammer. wil render any AI unuseable in a 10 tile radius"
	icon = 'icons/obj/jamming.dmi'
	icon_state = "jammer_portable2"
	w_class = ITEM_SIZE_SMALL
	suitable_cell = /obj/item/cell/small
	var/power_usage = 1
	var/datum/component/overlay_manager/overlay_manager

/obj/item/device/jammer/Initialize(mapload)
	. = ..()
	var/datum/component/jamming/our_jammer = AddComponent(/datum/component/jamming)
	our_jammer.radius = 10
	our_jammer.power = 10
	var/datum/component/overlay_manager/overlay_manager = AddComponent(/datum/component/overlay_manager)


/obj/item/device/jammer/Process(delta_time)
	if(!cell)
		var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
		our_jammer.Toggle()
		STOP_PROCESSING(SSobj, src)
	if(cell.charge < power_usage * delta_time)
		var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
		our_jammer.Toggle()
		STOP_PROCESSING(SSobj, src)
	cell.charge -= power_usage * delta_time

/obj/item/device/jammer/attack_self(mob/user)
	var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
	if(our_jammer.active)
		our_jammer.Toggle()
		to_chat(user,  "You toggle the [src] off")
		STOP_PROCESSING(SSobj,src)
		return
	if(!cell)
		to_chat(user, SPAN_NOTICE("There is no power cell inside of [src]"))
	if(cell.charge < power_usage)
		to_chat(user , SPAN_NOTICE("The charge in [src]'s cell is too low to start jamming"))
	our_jammer.Toggle()
	to_chat(user,  "You toggle the [src] on")
	cell.charge -= power_usage
	START_PROCESSING(SSobj, src)

#undef OVERKEY_JAMMER_OFF
#undef OVERKEY_JAMMER_OFF







