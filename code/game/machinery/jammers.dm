/obj/machinery/jammer
	name = "Oberth Portable Signal Jammer"
	desc = "A big, magnetically floor-attached jammer, will render any AI signals unuseable in a 60 tile radius"
	icon = 'icons/obj/jamming.dmi'
	icon_state = "jammer_stationary4"
	anchored = FALSE
	density = TRUE

/obj/machinery/jammer/Initialize(mapload, d)
	. = ..()
	var/datum/component/jamming/our_jammer = AddComponent(/datum/component/jamming)
	our_jammer.radius = 60
	our_jammer.power = 10

/obj/machinery/jammer/attack_hand(mob/user)
	var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
	our_jammer.Toggle()
	to_chat(user,  "You toggle the [src] [our_jammer.active ? "on" : "off"]")

/obj/item/device/jammer
	name = "Oberth Mobile Jammer"
	desc = "A small, portable jammer. wil render any AI unuseable in a 10 tile radius"
	icon = 'icons/obj/jamming.dmi'
	icon_state = "jammer_portable"
	w_class = ITEM_SIZE_SMALL

/obj/item/device/jammer/Initialize(mapload)
	. = ..()
	var/datum/component/jamming/our_jammer = AddComponent(/datum/component/jamming)
	our_jammer.radius = 10
	our_jammer.power = 10

/obj/item/device/jammer/attack_self(mob/user)
	var/datum/component/jamming/our_jammer = GetComponent(/datum/component/jamming)
	our_jammer.Toggle()
	to_chat(user,  "You toggle the [src] [our_jammer.active ? "on" : "off"]")






