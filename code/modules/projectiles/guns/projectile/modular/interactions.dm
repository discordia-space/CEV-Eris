/datum/guninteraction
	var/obj/item/gun/projectile/automatic/modular/parentgun
	var/obj/item/part/gun/modular/parentpart
	var/priority = 0
	var/interactionflags
	var/action_button_name = ""
	var/action_button_proc = ""

/datum/guninteraction/proc/attack_self(mob/user)

/datum/guninteraction/proc/update_icon()

/datum/guninteraction/proc/load_ammo(var/obj/item/A, mob/user)

/datum/guninteraction/proc/unload_ammo(mob/user, var/allow_dump=1)

/datum/guninteraction/proc/special_check(mob/user)

/datum/guninteraction/New(newparent)
	parentpart = newparent

/datum/guninteraction/bolted
	var/bolt_open = FALSE
	var/message = "bolt"
	interactionflags = GI_ATTACKSELF|GI_LOAD|GI_UNLOAD|GI_SPECIAL


/datum/guninteraction/bolted/New(newparent)
	..()
	parentpart.part_overlay = jointext(list(initial(parentpart.part_overlay),"bolt_closed"), "")

/datum/guninteraction/bolted/attack_self(mob/user)
	bolt_act(user)
	. = TRUE

/datum/guninteraction/bolted/update_icon()
	if(bolt_open)
		parentpart.part_overlay = jointext(list(initial(parentpart.part_overlay),"bolt_open"), "")
	else
		parentpart.part_overlay = jointext(list(initial(parentpart.part_overlay),"bolt_closed"), "")
	parentgun.update_icon()

/datum/guninteraction/bolted/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return TRUE // disable operations

/datum/guninteraction/bolted/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return TRUE // disable operations


/datum/guninteraction/bolted/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [parentgun] while the [message] is open!"))
		return TRUE

/datum/guninteraction/bolted/proc/bolt_act(mob/living/user)

	playsound(parentgun.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(length(parentgun.loaded)||parentgun.chambered)
			if(parentgun.chambered)
				to_chat(user, SPAN_NOTICE("You work the [message] open, ejecting [parentgun.chambered]!"))
				parentgun.chambered.forceMove(get_turf(parentgun))
				parentgun.loaded -= parentgun.chambered
				parentgun.chambered = null
			else
				var/obj/item/ammo_casing/B = parentgun.loaded[1]
				if(!B.is_caseless)
					to_chat(user, SPAN_NOTICE("You work the [message] open, ejecting [B]!"))
					B.forceMove(get_turf(parentgun))
					parentgun.loaded -= B
				else
					to_chat(user, SPAN_NOTICE("You work the [message] open."))
					B = parentgun.loaded[1]
					parentgun.loaded -= B
					qdel(B)
		else
			to_chat(user, SPAN_NOTICE("You work the [message] open."))
	else
		to_chat(user, SPAN_NOTICE("You work the [message] closed."))
		playsound(parentgun.loc, 'sound/weapons/guns/interact/rifle_boltforward.ogg', 75, 1)
		bolt_open = 0
	parentgun.add_fingerprint(user)
	update_icon()

/datum/guninteraction/zoomed
	priority = 1
	interactionflags = GI_ATTACKSELF

/datum/guninteraction/zoomed/attack_self(mob/user)
	if(parentgun?.zoom)
		parentgun.toggle_scope(user)
		return TRUE

/datum/guninteraction/zoomed/multizoom
	action_button_name = "Switch zoom level"
	action_button_proc = "switch_zoom"
