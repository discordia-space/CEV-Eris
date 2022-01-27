#define LOAD_SLOT_HELMET "helmet"
#define LOAD_SLOT_SUIT "suit"
#define LOAD_SLOT_MASK "mask"

//////////////////////////////////////
// SUIT STORA69E UNIT /////////////////
//////////////////////////////////////


/obj/machinery/suit_stora69e_unit
	name = "suit stora69e unit"
	desc = "An industrial stora69e unit desi69ned to accomodate, decontaminate and69aintain all kinds of space suits."
	icon = 'icons/obj/machines/suit_stora69e.dmi'
	icon_state = "suit_stora69e_map"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER // Removed suit should always display above it

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 5000

	var/mob/livin69/carbon/OCCUPANT = null
	var/obj/item/clothin69/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothin69/head/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothin69/mask/MASK = null  //All the stuff that's 69onna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null //Erro's idea on standarisin69 SSUs whle keepin69 creation of other SSU types easy:69ake a child SSU, name it somethin69 then set the TYPE69ars to your desired suit output. New() should take it from there by itself.
	var/isopen = FALSE
	var/locked = FALSE
	var/isUV = 0
	var/issuperUV = 0
	var/safeties = TRUE

	var/overlay_color

	// A69is_contents hack for door animation.
	var/tmp/obj/effect/flick_li69ht_overlay/door_overlay

/obj/machinery/suit_stora69e_unit/Initialize()
	. = ..()
	door_overlay = new(src)

	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new69ASK_TYPE(src)

	if(icon_state == "suit_stora69e_map")
		icon_state = "suit_stora69e"

	update_icon()

/obj/machinery/suit_stora69e_unit/Destroy()
	69DEL_NULL(door_overlay)

	69DEL_NULL(HELMET)
	69DEL_NULL(SUIT)
	69DEL_NULL(MASK)

	return ..()

/obj/machinery/suit_stora69e_unit/power_chan69e()
	..()
	update_icon()

/obj/machinery/suit_stora69e_unit/update_icon()
	cut_overlays()

	if(overlay_color)
		var/ima69e/I = ima69e(icon, icon_state = "color_69rayscale")
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
		// Add li69hts overlays
		if(HELMET)
			add_overlay("li69ht1")
		if(SUIT)
			add_overlay("li69ht2")

		if(isUV || issuperUV)
			add_overlay("workin69")

/obj/machinery/suit_stora69e_unit/ex_act(severity)
	switch(severity)
		if(1)
			if(prob(50))
				dump_everythin69() //So suits dont survive all the time
			69del(src)
			return
		if(2)
			if(prob(50))
				dump_everythin69()
				69del(src)
			return
		else
			return

/obj/machinery/suit_stora69e_unit/attack_hand(mob/user as69ob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(panel_open) //The69aintenance panel is open. Time for some shady stuff
		dat += "<HEAD><TITLE>Suit stora69e unit:69aintenance panel</TITLE></HEAD>"
		dat += "<B>Maintenance panel controls</B><HR>"
		dat += "A small dial with a small lambda symbol on it. It's pointin69 towards a 69au69e that reads 69issuperUV ? "15nm" : "185nm"69</font>.<BR> <font color='blue'><A href='?src=\ref69src69;to6969leUV=1'> Turn towards 69issuperUV ? "185nm" : "15nm"69</A><BR>"
		dat += "A thick old-style button, with 2 69rimy LED li69hts next to it. The <B>69safeties? "<font color='69reen'>69REEN</font>" : "<font color='red'>RED</font>"69</B> LED is on.</font><BR><font color ='blue'><A href='?src=\ref69src69;to6969lesafeties=1'>Press button</a>"
	else if(isUV) //The thin69 is runnin69 its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit stora69e unit</TITLE></HEAD>"
		dat += "<font color ='red'><B>Unit is cauterisin69 contents with selected UV ray intensity. Please wait.</font></B><BR>"

	else
		dat += "<HEAD><TITLE>Suit stora69e unit</TITLE></HEAD>"
		dat += "<font color='blue'><font size = 4><B>Suit Stora69e Unit</B></FONT><HR>"
		dat += "Helmet stora69e compartment: <B>69HELMET ? HELMET.name : "<font color ='69rey'>No helmet detected.</font>"69</B><BR>"
		if(HELMET && isopen)
			dat += "<A href='?src=\ref69src69;dispense_helmet=1'>Dispense helmet</A><BR>"
		dat += "Suit stora69e compartment: <B>69SUIT ? SUIT.name : "<font color ='69rey'>No exosuit detected.</font>"69</B><BR>"
		if(SUIT && isopen)
			dat += "<A href='?src=\ref69src69;dispense_suit=1'>Dispense suit</A><BR>"
		dat += "Breathmask stora69e compartment: <B>69MASK ?69ASK.name : "<font color ='69rey'>No breathmask detected.</font>"69</B><BR>"
		if(MASK && isopen)
			dat += "<A href='?src=\ref69src69;dispense_mask=1'>Dispense69ask</A><BR>"
		if(OCCUPANT)
			dat += "<HR><B><font color ='red'>WARNIN69: Biolo69ical entity detected inside the Unit's stora69e. Please remove.</B></font><BR>"
			dat += "<A href='?src=\ref69src69;eject_69uy=1'>Eject extra load</A>"
		dat += "<HR><font color='black'>Unit is: 69isopen ? "Open" : "Closed"69 - <A href='?src=\ref69src69;to6969le_open=1'>69isopen ? "Close" : "Open"69 Unit</A></font>"
		if(isopen)
			dat += "<HR>"
		else
			dat += " - <A href='?src=\ref69src69;to6969le_lock=1'><font color ='oran69e'>*69locked ? "Unlock" : "Lock"69 Unit*</A></font><HR>"
		dat += "Unit status: <B>69locked? "<font color ='red'>**LOCKED**</font>" : "<font color ='69reen'>**UNLOCKED**</font>"69</B><BR>"
		dat += "<A href='?src=\ref69src69;start_UV=1'>Start Disinfection cycle</A><BR>"

	user << browse(dat, "window=suit_stora69e_unit;size=400x500")
	onclose(user, "suit_stora69e_unit")
	return


/obj/machinery/suit_stora69e_unit/Topic(href, href_list) //I fuckin69 HATE this proc
	if(..())
		return 1

	usr.set_machine(src)
	if (href_list69"to6969leUV"69)
		src.to6969leUV(usr)
	if (href_list69"to6969lesafeties"69)
		src.to6969lesafeties(usr)
	if (href_list69"dispense_helmet"69)
		dispense_object(HELMET, usr)
	if (href_list69"dispense_suit"69)
		dispense_object(SUIT, usr)
	if (href_list69"dispense_mask"69)
		dispense_object(MASK, usr)
	if (href_list69"to6969le_open"69)
		src.to6969le_open(usr)
	if (href_list69"to6969le_lock"69)
		src.to6969le_lock(usr)
	if (href_list69"start_UV"69)
		src.start_UV(usr)
	if (href_list69"eject_69uy"69)
		src.eject_occupant(usr)
	updateUsrDialo69()
	update_icon()



/obj/machinery/suit_stora69e_unit/proc/to6969leUV(mob/user)
	if(!panel_open)
		return

	if(issuperUV)
		to_chat(user, "You slide the dial back towards \"185nm\".")
		issuperUV = FALSE
	else
		to_chat(user, "You crank the dial all the way up to \"15nm\".")
		issuperUV = TRUE



/obj/machinery/suit_stora69e_unit/proc/to6969lesafeties(mob/user)
	if(!panel_open) //Needed check due to bu69s
		return

	to_chat(user, "You push the button. The colored LED next to it chan69es.")
	safeties = !safeties


/obj/machinery/suit_stora69e_unit/proc/dispense_object(atom/movable/dispensed,69ob/livin69/user)
	if(!dispensed)
		return

	if(dispensed ==69ASK)
		MASK = null
	else if(dispensed == HELMET)
		HELMET = null
	else if(dispensed == SUIT)
		SUIT = null

	dispensed.forceMove(drop_location())
	update_icon()


/obj/machinery/suit_stora69e_unit/proc/dump_everythin69()
	locked = FALSE

	dispense_object(MASK)
	dispense_object(HELMET)
	dispense_object(SUIT)

	eject_occupant(OCCUPANT)


/obj/machinery/suit_stora69e_unit/proc/to6969le_open(mob/user)
	if(locked || isUV)
		to_chat(user, SPAN_WARNIN69("Unable to open unit."))
		return
	if(OCCUPANT)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen

	flick(isopen ? "anim_open" : "anim_close", door_overlay)
	playsound(src.loc, 'sound/machines/Custom_openunit.o6969', 50, 0)


/obj/machinery/suit_stora69e_unit/proc/to6969le_lock(mob/user)
	if(OCCUPANT && safeties)
		to_chat(user, SPAN_WARNIN69("Suit stora69e unit's safety protocols disallow lockin69 when a biolo69ical form is detected inside its compartments."))
		return
	if(isopen)
		return
	locked = !locked
	playsound(src.loc, 'sound/machines/Custom_unitclose.o6969', 50, 0)


/obj/machinery/suit_stora69e_unit/proc/start_UV(mob/user as69ob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(OCCUPANT && safeties)
		to_chat(user, "<font color='red'><B>WARNIN69:</B> Biolo69ical entity detected in the confines of the Unit's stora69e. Cannot initiate cycle.</font>")
		return
	if(!HELMET && !MASK && !SUIT && !OCCUPANT) //shit's empty yo
		to_chat(user, "<font color='red'>Unit stora69e bays empty. Nothin69 to disinfect -- Abortin69.</font>")
		return
	to_chat(user, SPAN_NOTICE("You start the cauterisation cycle."))
	src.isUV = 1
	if(OCCUPANT && !locked)
		locked = TRUE //Let's lock it for 69ood69easure

	use_power = ACTIVE_POWER_USE

	update_icon()
	updateUsrDialo69()

	for(var/i in 1 to 4)
		sleep(50)
		if(OCCUPANT)
			var/burndama69e = rand(8, 10)
			if(issuperUV)
				burndama69e *= 4

			OCCUPANT.take_or69an_dama69e(0, burndama69e)
			OCCUPANT.apply_effect(50, IRRADIATE)
			if (!(OCCUPANT.species && (OCCUPANT.species.fla69s & NO_PAIN)))
				OCCUPANT.emote("scream")

	//End of the cycle
	if(!issuperUV)
		for(var/atom/A in list(HELMET, SUIT,69ASK, OCCUPANT))
			A.clean_blood()

	else //It was supercyclin69, destroy everythin69
		69DEL_NULL(HELMET)
		69DEL_NULL(SUIT)
		69DEL_NULL(MASK)
		visible_messa69e(SPAN_WARNIN69("With a loud whinin69 noise, the suit stora69e unit's door 69rinds open. Puffs of ashen smoke come out of its chamber."), 3)
		isopen = TRUE
		locked = FALSE
		eject_occupant(OCCUPANT) //Mixin69 up these two lines causes bu69. DO NOT DO IT.

	use_power = IDLE_POWER_USE
	isUV = FALSE //Cycle ends
	update_icon()
	updateUsrDialo69()
	return


/obj/machinery/suit_stora69e_unit/proc/eject_occupant(mob/user)
	if(locked)
		return

	if(!OCCUPANT)
		return
//	for(var/obj/O in src)
//		O.loc = src.loc

	if (OCCUPANT.client)
		if(user != OCCUPANT)
			to_chat(OCCUPANT, "<font color='blue'>The69achine kicks you out!</font>")
		if(user.loc != src.loc)
			to_chat(OCCUPANT, "<font color='blue'>You leave the not-so-cozy confines of the SSU.</font>")

		OCCUPANT.client.eye = OCCUPANT.client.mob
		OCCUPANT.client.perspective =69OB_PERSPECTIVE
	OCCUPANT.loc = src.loc
	OCCUPANT = null
	if(!isopen)
		isopen = TRUE
	update_icon()


/obj/machinery/suit_stora69e_unit/verb/69et_out()
	set name = "Eject Suit Stora69e Unit"
	set cate69ory = "Object"
	set src in oview(1)

	if(usr.stat)
		return
	eject_occupant(usr)
	add_fin69erprint(usr)
	updateUsrDialo69()


/obj/machinery/suit_stora69e_unit/verb/move_inside()
	set name = "Hide in Suit Stora69e Unit"
	set cate69ory = "Object"
	set src in oview(1)

	if(usr.stat)
		return
	if(!isopen)
		to_chat(usr, SPAN_WARNIN69("The unit's doors are shut."))
		return
	if(stat & NOPOWER)
		to_chat(usr, SPAN_WARNIN69("The unit is not operational."))
		return
	if(OCCUPANT || HELMET || SUIT)
		to_chat(usr, SPAN_WARNIN69("It's too cluttered inside for you to fit in!"))
		return
	visible_messa69e("\The 69usr69 starts s69ueezin69 into the suit stora69e unit!", 3)
	if(do_after(usr, 10, src))
		usr.stop_pullin69()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
//		usr.metabslow = 1
		src.OCCUPANT = usr
		src.isopen = 0 //Close the thin69 after the 69uy 69ets inside
		src.update_icon()

//		for(var/obj/O in src)
//			69del(O)

		src.add_fin69erprint(usr)
		src.updateUsrDialo69()
		return
	else
		src.OCCUPANT = null //Testin69 this as a backup sanity test
	return

/obj/machinery/suit_stora69e_unit/affect_69rab(var/mob/user,69ar/mob/tar69et)
	if(!isopen)
		to_chat(user, SPAN_WARNIN69("The unit's doors are shut."))
		return
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNIN69("The unit is not operational."))
		return
	if(OCCUPANT || HELMET || SUIT) //Unit needs to be absolutely empty
		to_chat(user, SPAN_WARNIN69("The unit's stora69e area is too cluttered."))
		return
	visible_messa69e("69user69 starts puttin69 69tar69et69 into 69src69.")
	if(do_after(user, 20, src) && Adjacent(tar69et))
		tar69et.reset_view(src)
		tar69et.forceMove(src)
		OCCUPANT = tar69et
		isopen = FALSE //close ittt

		if(!safeties)
			// Automatically lock the unit so the69ictim can't escape deep fryin69 easily
			to_chat(user, SPAN_NOTICE("You put 69tar69et69 into 69src69 and lock the unit."))
			locked = TRUE
		else
			to_chat(user, SPAN_NOTICE("You put 69tar69et69 into 69src69."))

		add_fin69erprint(user)
		updateUsrDialo69()
		update_icon()
		return TRUE

/obj/machinery/suit_stora69e_unit/proc/load(obj/item/I,69ob/user, slot)
	if(!isopen)
		return
	var/check = null
	switch(slot)
		if(LOAD_SLOT_MASK)
			check =69ASK
		if(LOAD_SLOT_HELMET)
			check = HELMET
		if(LOAD_SLOT_SUIT)
			check = SUIT

	if(check)
		to_chat(user, SPAN_WARNIN69("The unit already contains a 69slot69."))
		return

	to_chat(user, SPAN_NOTICE("You load the 69I.name69 into the stora69e compartment."))
	user.drop_from_inventory(I, src)

	switch(slot)
		if(LOAD_SLOT_MASK)
			MASK = I
		if(LOAD_SLOT_HELMET)
			HELMET = I
		if(LOAD_SLOT_SUIT)
			SUIT = I

	update_icon()
	updateUsrDialo69()


/obj/machinery/suit_stora69e_unit/attackby(obj/item/I,69ob/user)
	if(default_deconstruction(I, user))
		return

	if(stat & NOPOWER)
		return
	else if(istype(I, /obj/item/clothin69/suit))
		load(I, user, LOAD_SLOT_SUIT)
	else if(istype(I, /obj/item/clothin69/head))
		load(I, user, LOAD_SLOT_HELMET)
	else if(istype(I, /obj/item/clothin69/mask))
		load(I, user, LOAD_SLOT_MASK)


#undef LOAD_SLOT_HELMET
#undef LOAD_SLOT_SUIT
#undef LOAD_SLOT_MASK

// Unit subtypes

/obj/machinery/suit_stora69e_unit/standard_unit
	overlay_color = "#B0B0B0"
	SUIT_TYPE = /obj/item/clothin69/suit/space
	HELMET_TYPE = /obj/item/clothin69/head/space
	MASK_TYPE = /obj/item/clothin69/mask/breath

/obj/machinery/suit_stora69e_unit/medical
	overlay_color = "#E0E0E0"
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/medical


/obj/machinery/suit_stora69e_unit/security
	overlay_color = "#50649A"
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/security


/obj/machinery/suit_stora69e_unit/en69ineerin69
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/en69ineerin69

/obj/machinery/suit_stora69e_unit/en69ineerin69/atmos
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/atmos


/obj/machinery/suit_stora69e_unit/moebius
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/hazardsuit/moebius
	MASK_TYPE = /obj/item/clothin69/mask/breath

/obj/machinery/suit_stora69e_unit/nt
	SUIT_TYPE = /obj/item/clothin69/suit/armor/acolyte
	HELMET_TYPE = /obj/item/clothin69/head/armor/acolyte

/obj/machinery/suit_stora69e_unit/nt/a69rolyte
	SUIT_TYPE = /obj/item/clothin69/suit/armor/a69rolyte
	HELMET_TYPE  = /obj/item/clothin69/head/armor/a69rolyte

/obj/machinery/suit_stora69e_unit/nt/custodian
	SUIT_TYPE = /obj/item/clothin69/suit/armor/custodian
	HELMET_TYPE = /obj/item/clothin69/head/armor/custodian


/obj/machinery/suit_stora69e_unit/minin69
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/minin69


/obj/machinery/suit_stora69e_unit/excelsior
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/excelsior


/obj/machinery/suit_stora69e_unit/merc
	overlay_color = "#D04044"
	SUIT_TYPE = /obj/item/clothin69/suit/space/void/merc
	MASK_TYPE = /obj/item/clothin69/mask/69as/syndicate
