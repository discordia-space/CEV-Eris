#define OVERKEY_JAMMER_ON "JAM_ON"
#define OVERKEY_JAMMER_OFF "JAM_OFF"

/obj/machinery/jammer
	name = "Oberth Portable Signal Jammer"
	desc = "A big, industrial-size jammer, will render any AI signals unuseable in a 32 tile radius. Its effect also extends up and above by 1 level, with a reduction in range of 8"
	icon = 'icons/obj/jamming.dmi'
	icon_state = "jammer_stationary4"
	anchored = FALSE
	density = TRUE
	var/obj/item/cell/large/cell
	var/power_usage = 2

/obj/machinery/jammer/Initialize(mapload, d)
	. = ..()
	// Don't wanna process
	STOP_PROCESSING(SSmachines, src)
	var/datum/component/jamming/our_jammer = AddComponent(/datum/component/jamming)
	// Big
	our_jammer.radius = 32
	our_jammer.power = 500
	our_jammer.z_transfer = 1
	our_jammer.z_reduction = 8
	var/datum/component/overlay_manager/overlay_manager = AddComponent(/datum/component/overlay_manager)
	overlay_manager.addOverlay(OVERKEY_JAMMER_OFF, mutable_appearance(icon, "jammerstatover_off"))
	cell = new /obj/item/cell/large(src)

/obj/machinery/jammer/examine(mob/user, distance, infix, suffix)
	. = ..(user, afterDesc = "[(distance < 2 && cell) ? "The terminal reads [round(cell.charge/power_usage*SSmachines.wait/10)] seconds of operation left." : ""]")

/obj/machinery/jammer/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/cell/large) && !cell)
		user.drop_from_inventory(I)
		I.forceMove(src)
		cell = I
		return ..()
	else if(istype(I, /obj/item/tool))
		var/obj/item/tool/the_tool = I
		if(the_tool.get_tool_quality(QUALITY_SCREW_DRIVING))
			if(cell)
				to_chat(user, "You remove the [cell] from [src]'s port")
				eject_item(cell, user)
				cell = null
			else
				to_chat(user, "There is no cell to remove from [src]'s port")
		return ..()

/obj/machinery/jammer/attack_hand(mob/user)
	var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
	var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
	if(our_jammer.active)
		overlay_manager.removeOverlay(OVERKEY_JAMMER_ON)
		overlay_manager.addOverlay(OVERKEY_JAMMER_OFF, mutable_appearance(icon, "jammerstatover_off"))
		STOP_PROCESSING(SSmachines, src)
		our_jammer.Toggle()
		to_chat(user,  "You toggle the [src] off")
		return TRUE
	if(!cell)
		to_chat(user, SPAN_NOTICE("There is no powercell inside of [src]"))
		return
	if(cell.charge < power_usage)
		to_chat(user, SPAN_NOTICE("The powercell inside of [src] is discharged"))
		return

	overlay_manager.removeOverlay(OVERKEY_JAMMER_OFF)
	overlay_manager.addOverlay(OVERKEY_JAMMER_ON, mutable_appearance(icon, "jammerstatover_on"))
	START_PROCESSING(SSmachines,src)
	our_jammer.Toggle()
	to_chat(user,  "You toggle the [src] on")

/obj/machinery/jammer/Process(delta_time)
	if(!cell || cell?.charge < delta_time * power_usage)
		var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
		var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
		our_jammer.Toggle()
		overlay_manager.removeOverlay(OVERKEY_JAMMER_ON)
		overlay_manager.addOverlay(OVERKEY_JAMMER_OFF, mutable_appearance(icon, "jammerstatover_off"))
		STOP_PROCESSING(SSmachines, src)
	cell.charge -= delta_time * power_usage

/obj/item/device/jammer
	name = "Oberth Mobile Jammer"
	desc = "A small, portable jammer. wil render any AI unuseable in a 8 tile radius"
	icon = 'icons/obj/jamming.dmi'
	icon_state = "jammer_portable2"
	volumeClass = ITEM_SIZE_SMALL
	suitable_cell = /obj/item/cell/small
	spawn_blacklisted = TRUE
	var/power_usage = 0.3

/obj/item/device/jammer/examine(mob/user)
	. = ..(user, afterDesc = (cell && get_dist(user, src) <= 2) ? "The terminal reads [round(cell.charge/power_usage*SSmachines.wait/10)] seconds of operation left." : "")

/obj/item/device/jammer/Initialize(mapload)
	. = ..()
	var/datum/component/jamming/our_jammer = AddComponent(/datum/component/jamming)
	our_jammer.radius = 8
	our_jammer.power = 200
	our_jammer.z_transfer = 0
	var/datum/component/overlay_manager/overlay_manager = AddComponent(/datum/component/overlay_manager)
	overlay_manager.addOverlay(OVERKEY_JAMMER_OFF, mutable_appearance(icon, "jammermobover_off"))


/obj/item/device/jammer/Process(delta_time)
	if(!cell || cell?.charge < power_usage * delta_time)
		var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
		var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
		our_jammer.Toggle()
		overlay_manager.removeOverlay(OVERKEY_JAMMER_ON)
		overlay_manager.addOverlay(OVERKEY_JAMMER_OFF, mutable_appearance(icon, "jammermobover_off"))
		STOP_PROCESSING(SSobj, src)
	cell.charge -= power_usage * delta_time

/obj/item/device/jammer/attack_self(mob/user)
	var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
	var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
	if(our_jammer.active)
		our_jammer.Toggle()
		to_chat(user,  "You toggle the [src] off")
		overlay_manager.removeOverlay(OVERKEY_JAMMER_ON)
		overlay_manager.addOverlay(OVERKEY_JAMMER_OFF, mutable_appearance(icon, "jammermobover_off"))
		STOP_PROCESSING(SSobj,src)
		return
	if(!cell)
		to_chat(user, SPAN_NOTICE("There is no power cell inside of [src]"))
	if(cell.charge < power_usage)
		to_chat(user , SPAN_NOTICE("The charge in [src]'s cell is too low to start jamming"))
	overlay_manager.removeOverlay(OVERKEY_JAMMER_OFF)
	overlay_manager.addOverlay(OVERKEY_JAMMER_ON, mutable_appearance(icon, "jammermobover_on"))
	our_jammer.Toggle()
	to_chat(user,  "You toggle the [src] on")
	cell.charge -= power_usage
	START_PROCESSING(SSobj, src)

#undef OVERKEY_JAMMER_OFF
#undef OVERKEY_JAMMER_ON







