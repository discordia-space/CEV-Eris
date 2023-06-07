#define LOAD_SLOT_HELMET "helmet"
#define LOAD_SLOT_SUIT "suit"
#define LOAD_SLOT_MASK "mask"

//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////


/obj/machinery/suit_storage_unit
	name = "suit storage unit"
	desc = "An industrial storage unit designed to accomodate, decontaminate and maintain all kinds of space suits."
	icon = 'icons/obj/machines/suit_storage.dmi'
	icon_state = "suit_storage_map"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER // Removed suit should always display above it

	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 5000

	var/mob/living/carbon/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothing/head/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/isopen = FALSE
	var/locked = FALSE
	var/isUV = 0
	var/issuperUV = 0
	var/safeties = TRUE

	var/overlay_color

	// A vis_contents hack for door animation.
	var/tmp/obj/effect/flick_light_overlay/door_overlay

/obj/machinery/suit_storage_unit/Initialize()
	. = ..()
	door_overlay = new(src)

	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)

	if(icon_state == "suit_storage_map")
		icon_state = "suit_storage"

	update_icon()

/obj/machinery/suit_storage_unit/Destroy()
	QDEL_NULL(door_overlay)

	QDEL_NULL(HELMET)
	QDEL_NULL(SUIT)
	QDEL_NULL(MASK)

	return ..()

/obj/machinery/suit_storage_unit/power_change()
	..()
	update_icon()

/obj/machinery/suit_storage_unit/update_icon()
	cut_overlays()

	if(overlay_color)
		var/image/I = image(icon, icon_state = "color_grayscale")
		I.color = overlay_color
		add_overlay(I)

	if(panel_open)
		add_overlay("panel")

	if(HELMET)
		add_overlay("helmet")
	if(SUIT)
		add_overlay("suit")

	door_overlay?.icon_state = isopen ? "open" : "closed"

	if(inoperable())
		add_overlay("nopower")
	else
		// Add lights overlays
		if(HELMET)
			add_overlay("light1")
		if(SUIT)
			add_overlay("light2")

		if(isUV || issuperUV)
			add_overlay("working")

/obj/machinery/suit_storage_unit/take_damage(amount)
	if(amount > health && amount - health < 100)
		dump_everything()
	. = ..()

/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(panel_open) //The maintenance panel is open. Time for some shady stuff
		dat += "<HEAD><TITLE>Suit storage unit: Maintenance panel</TITLE></HEAD>"
		dat += "<B>Maintenance panel controls</B><HR>"
		dat += "A small dial with a small lambda symbol on it. It's pointing towards a gauge that reads [issuperUV ? "15nm" : "185nm"]</font>.<BR> <font color='blue'><A href='?src=\ref[src];toggleUV=1'> Turn towards [issuperUV ? "185nm" : "15nm"]</A><BR>"
		dat += "A thick old-style button, with 2 grimy LED lights next to it. The <B>[safeties? "<font color='green'>GREEN</font>" : "<font color='red'>RED</font>"]</B> LED is on.</font><BR><font color ='blue'><A href='?src=\ref[src];togglesafeties=1'>Press button</a>"
	else if(isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat += "<font color ='red'><B>Unit is cauterising contents with selected UV ray intensity. Please wait.</font></B><BR>"

	else
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat += "<font color='blue'><font size = 4><B>Suit Storage Unit</B></FONT><HR>"
		dat += "Helmet storage compartment: <B>[HELMET ? HELMET.name : "<font color ='grey'>No helmet detected.</font>"]</B><BR>"
		if(HELMET && isopen)
			dat += "<A href='?src=\ref[src];dispense_helmet=1'>Dispense helmet</A><BR>"
		dat += "Suit storage compartment: <B>[SUIT ? SUIT.name : "<font color ='grey'>No exosuit detected.</font>"]</B><BR>"
		if(SUIT && isopen)
			dat += "<A href='?src=\ref[src];dispense_suit=1'>Dispense suit</A><BR>"
		dat += "Breathmask storage compartment: <B>[MASK ? MASK.name : "<font color ='grey'>No breathmask detected.</font>"]</B><BR>"
		if(MASK && isopen)
			dat += "<A href='?src=\ref[src];dispense_mask=1'>Dispense mask</A><BR>"
		if(OCCUPANT)
			dat += "<HR><B><font color ='red'>WARNING: Biological entity detected inside the Unit's storage. Please remove.</B></font><BR>"
			dat += "<A href='?src=\ref[src];eject_guy=1'>Eject extra load</A>"
		dat += "<HR><font color='black'>Unit is: [isopen ? "Open" : "Closed"] - <A href='?src=\ref[src];toggle_open=1'>[isopen ? "Close" : "Open"] Unit</A></font>"
		if(isopen)
			dat += "<HR>"
		else
			dat += " - <A href='?src=\ref[src];toggle_lock=1'><font color ='orange'>*[locked ? "Unlock" : "Lock"] Unit*</A></font><HR>"
		dat += "Unit status: <B>[locked? "<font color ='red'>**LOCKED**</font>" : "<font color ='green'>**UNLOCKED**</font>"]</B><BR>"
		dat += "<A href='?src=\ref[src];start_UV=1'>Start Disinfection cycle</A><BR>"

	user << browse(dat, "window=suit_storage_unit;size=400x500")
	onclose(user, "suit_storage_unit")
	return


/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return 1

	usr.set_machine(src)
	if (href_list["toggleUV"])
		src.toggleUV(usr)
	if (href_list["togglesafeties"])
		src.togglesafeties(usr)
	if (href_list["dispense_helmet"])
		dispense_object(HELMET, usr)
	if (href_list["dispense_suit"])
		dispense_object(SUIT, usr)
	if (href_list["dispense_mask"])
		dispense_object(MASK, usr)
	if (href_list["toggle_open"])
		src.toggle_open(usr)
	if (href_list["toggle_lock"])
		src.toggle_lock(usr)
	if (href_list["start_UV"])
		src.start_UV(usr)
	if (href_list["eject_guy"])
		src.eject_occupant(usr)
	updateUsrDialog()
	update_icon()



/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user)
	if(!panel_open)
		return

	if(issuperUV)
		to_chat(user, "You slide the dial back towards \"185nm\".")
		issuperUV = FALSE
	else
		to_chat(user, "You crank the dial all the way up to \"15nm\".")
		issuperUV = TRUE



/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user)
	if(!panel_open) //Needed check due to bugs
		return

	to_chat(user, "You push the button. The colored LED next to it changes.")
	safeties = !safeties


/obj/machinery/suit_storage_unit/proc/dispense_object(atom/movable/dispensed, mob/living/user)
	if(!dispensed)
		return

	if(dispensed == MASK)
		MASK = null
	else if(dispensed == HELMET)
		HELMET = null
	else if(dispensed == SUIT)
		SUIT = null

	dispensed.forceMove(drop_location())
	update_icon()


/obj/machinery/suit_storage_unit/proc/dump_everything()
	locked = FALSE

	dispense_object(MASK)
	dispense_object(HELMET)
	dispense_object(SUIT)

	eject_occupant(OCCUPANT)


/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user)
	if(locked || isUV)
		to_chat(user, SPAN_WARNING("Unable to open unit."))
		return
	if(OCCUPANT)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen

	flick(isopen ? "anim_open" : "anim_close", door_overlay)
	playsound(src.loc, 'sound/machines/Custom_openunit.ogg', 50, 0)


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user)
	if(OCCUPANT && safeties)
		to_chat(user, SPAN_WARNING("Suit storage unit's safety protocols disallow locking when a biological form is detected inside its compartments."))
		return
	if(isopen)
		return
	locked = !locked
	playsound(src.loc, 'sound/machines/Custom_unitclose.ogg', 50, 0)


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(OCCUPANT && safeties)
		to_chat(user, "<font color='red'><B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</font>")
		return
	if(!HELMET && !MASK && !SUIT && !OCCUPANT) //shit's empty yo
		to_chat(user, "<font color='red'>Unit storage bays empty. Nothing to disinfect -- Aborting.</font>")
		return
	to_chat(user, SPAN_NOTICE("You start the cauterisation cycle."))
	src.isUV = 1
	if(OCCUPANT && !locked)
		locked = TRUE //Let's lock it for good measure

	use_power = ACTIVE_POWER_USE

	update_icon()
	updateUsrDialog()

	for(var/i in 1 to 4)
		sleep(50)
		if(OCCUPANT)
			var/burndamage = rand(8, 10)
			if(issuperUV)
				burndamage *= 4

			OCCUPANT.take_organ_damage(0, burndamage)
			OCCUPANT.apply_effect(50, IRRADIATE)
			if (!(OCCUPANT.species && (OCCUPANT.species.flags & NO_PAIN)))
				OCCUPANT.emote("scream")

	//End of the cycle
	if(!issuperUV)
		for(var/atom/A in list(HELMET, SUIT, MASK, OCCUPANT))
			A.clean_blood()

	else //It was supercycling, destroy everything
		QDEL_NULL(HELMET)
		QDEL_NULL(SUIT)
		QDEL_NULL(MASK)
		visible_message(SPAN_WARNING("With a loud whining noise, the suit storage unit's door grinds open. Puffs of ashen smoke come out of its chamber."), 3)
		isopen = TRUE
		locked = FALSE
		eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.

	use_power = IDLE_POWER_USE
	isUV = FALSE //Cycle ends
	update_icon()
	updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user)
	if(locked)
		return

	if(!OCCUPANT)
		return
//	for(var/obj/O in src)
//		O.loc = src.loc

	if (OCCUPANT.client)
		if(user != OCCUPANT)
			to_chat(OCCUPANT, "<font color='blue'>The machine kicks you out!</font>")
		if(user.loc != src.loc)
			to_chat(OCCUPANT, "<font color='blue'>You leave the not-so-cozy confines of the SSU.</font>")

		OCCUPANT.client.eye = OCCUPANT.client.mob
		OCCUPANT.client.perspective = MOB_PERSPECTIVE
	OCCUPANT.loc = src.loc
	OCCUPANT = null
	if(!isopen)
		isopen = TRUE
	update_icon()


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return
	eject_occupant(usr)
	add_fingerprint(usr)
	updateUsrDialog()


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return
	if(!isopen)
		to_chat(usr, SPAN_WARNING("The unit's doors are shut."))
		return
	if(stat & NOPOWER)
		to_chat(usr, SPAN_WARNING("The unit is not operational."))
		return
	if(OCCUPANT || HELMET || SUIT)
		to_chat(usr, SPAN_WARNING("It's too cluttered inside for you to fit in!"))
		return
	visible_message("\The [usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10, src))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
//		usr.metabslow = 1
		src.OCCUPANT = usr
		src.isopen = 0 //Close the thing after the guy gets inside
		src.update_icon()

//		for(var/obj/O in src)
//			qdel(O)

		src.add_fingerprint(usr)
		src.updateUsrDialog()
		return
	else
		src.OCCUPANT = null //Testing this as a backup sanity test
	return

/obj/machinery/suit_storage_unit/affect_grab(var/mob/user, var/mob/target)
	if(!isopen)
		to_chat(user, SPAN_WARNING("The unit's doors are shut."))
		return
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("The unit is not operational."))
		return
	if(OCCUPANT || HELMET || SUIT) //Unit needs to be absolutely empty
		to_chat(user, SPAN_WARNING("The unit's storage area is too cluttered."))
		return
	visible_message("[user] starts putting [target] into [src].")
	if(do_after(user, 20, src) && Adjacent(target))
		target.reset_view(src)
		target.forceMove(src)
		OCCUPANT = target
		isopen = FALSE //close ittt

		if(!safeties)
			// Automatically lock the unit so the victim can't escape deep frying easily
			to_chat(user, SPAN_NOTICE("You put [target] into [src] and lock the unit."))
			locked = TRUE
		else
			to_chat(user, SPAN_NOTICE("You put [target] into [src]."))

		add_fingerprint(user)
		updateUsrDialog()
		update_icon()
		return TRUE

/obj/machinery/suit_storage_unit/proc/load(obj/item/I, mob/user, slot)
	if(!isopen)
		return
	var/check = null
	switch(slot)
		if(LOAD_SLOT_MASK)
			check = MASK
		if(LOAD_SLOT_HELMET)
			check = HELMET
		if(LOAD_SLOT_SUIT)
			check = SUIT

	if(check)
		to_chat(user, SPAN_WARNING("The unit already contains a [slot]."))
		return

	to_chat(user, SPAN_NOTICE("You load the [I.name] into the storage compartment."))
	user.drop_from_inventory(I, src)

	switch(slot)
		if(LOAD_SLOT_MASK)
			MASK = I
		if(LOAD_SLOT_HELMET)
			HELMET = I
		if(LOAD_SLOT_SUIT)
			SUIT = I

	update_icon()
	updateUsrDialog()


/obj/machinery/suit_storage_unit/attackby(obj/item/I, mob/user)
	if(default_deconstruction(I, user))
		return

	if(stat & NOPOWER)
		return
	else if(istype(I, /obj/item/clothing/suit))
		load(I, user, LOAD_SLOT_SUIT)
	else if(istype(I, /obj/item/clothing/head))
		load(I, user, LOAD_SLOT_HELMET)
	else if(istype(I, /obj/item/clothing/mask))
		load(I, user, LOAD_SLOT_MASK)


#undef LOAD_SLOT_HELMET
#undef LOAD_SLOT_SUIT
#undef LOAD_SLOT_MASK

// Unit subtypes

/obj/machinery/suit_storage_unit/standard_unit
	overlay_color = "#B0B0B0"
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/space
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/medical
	overlay_color = "#E0E0E0"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/medical


/obj/machinery/suit_storage_unit/security
	overlay_color = "#50649A"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/security


/obj/machinery/suit_storage_unit/engineering
	SUIT_TYPE = /obj/item/clothing/suit/space/void/engineering

/obj/machinery/suit_storage_unit/engineering/atmos
	SUIT_TYPE = /obj/item/clothing/suit/space/void/atmos


/obj/machinery/suit_storage_unit/moebius
	SUIT_TYPE = /obj/item/clothing/suit/space/void/hazardsuit/moebius
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/nt
	SUIT_TYPE = /obj/item/clothing/suit/armor/acolyte
	HELMET_TYPE = /obj/item/clothing/head/armor/acolyte

/obj/machinery/suit_storage_unit/nt/agrolyte
	SUIT_TYPE = /obj/item/clothing/suit/armor/agrolyte
	HELMET_TYPE  = /obj/item/clothing/head/armor/agrolyte

/obj/machinery/suit_storage_unit/nt/custodian
	SUIT_TYPE = /obj/item/clothing/suit/armor/custodian
	HELMET_TYPE = /obj/item/clothing/head/armor/custodian


/obj/machinery/suit_storage_unit/mining
	SUIT_TYPE = /obj/item/clothing/suit/space/void/mining


/obj/machinery/suit_storage_unit/excelsior
	SUIT_TYPE = /obj/item/clothing/suit/space/void/excelsior


/obj/machinery/suit_storage_unit/merc
	overlay_color = "#D04044"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/merc
	MASK_TYPE = /obj/item/clothing/mask/gas/syndicate
