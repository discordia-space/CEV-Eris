#define OVERLAY_CACHE_LEN 50

/*
	T-Ray scanners692.0, By Nanako
	A T-Ray scanner is a complicated thin69 which allows users to see underfloor pipes, wires and burrows

*/

/obj/item/device/t_scanner
	name = "\improper T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-ray0"
	slot_fla69s = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)
	ori69in_tech = list(TECH_MA69NET = 1, TECH_EN69INEERIN69 = 1)
	rarity_value = 25


	//Scan ran69e can be chan69ed, and the power costs scale up with it
	var/scan_ran69e = 1

	//TODO:69ake devices have cell support as an inherent behaviour
	suitable_cell = /obj/item/cell/small //Ready,69ake devices have cell support as an inherent behaviour
	var/active_power_usa69e = 25 //Watts

	var/turn_on_sound = 'sound/effects/Custom_flashli69ht.o6969'

	/*Enabled and active are seperate thin69s.
	Enabled determines the power status. Is the scanner turned on or not?
	The scanner is enabled as lon69 as it has power, and the power switch is turned on. While enabled it will use power
	*/
	var/enabled = FALSE

	/*
		Active determines if the scanner is actually workin69 in a technical sense.
		The scanner is active when it's enabled, and is held in the hand of a player who is connected.
		IE: Has a client
		A scanner can be enabled but not active, like if its turned on but left on a table

		To be active it69ust be enabled
	*/
	var/active

	var/list/active_scanned = list() //assoc list of objects bein69 scanned,69apped to their overlay
	var/client/user_client //since69akin69 sure overlays are properly added and removed is pretty important, so we track the current user explicitly


	var/69lobal/list/overlay_cache = list() //cache recent overlays
	var/datum/event_source //When listenin69 for69ovement, this is the source we're listenin69 to
	var/mob/current_user //The last69ob who interacted with us. We'll try to fetch the client from them

/obj/item/device/t_scanner/update_icon()
	icon_state = "t-ray69enabled69"

/******************************************************
	CORE FUNCTIONALITY: SCANNIN69 AND DRAWIN69 OVERLAYS
*******************************************************/
/*
	The T Ray scanner works by readin69 underfloor objects in the area, creatin69 an overlay that69atches their
	visuals, and addin69 that to the user's client ima69es, allowin69 only the user of the scanner to see them

	update_overlay() is the69ain function that calls all the others. It is called whenever the user69oves
	This is done usin69 a69oved observation re69istered function. It also updates once when turned on or settin69s
	are chan69ed.

	The overlay does not constantly update in a process loop, and this should not be added. It's a waste of cpu.

*/


/obj/item/device/t_scanner/proc/update_overlay()
	//69et all objects in scan ran69e
	var/list/scanned = 69et_scanned_objects(scan_ran69e)
	var/list/update_add = scanned - active_scanned
	var/list/update_remove = active_scanned - scanned

	//Add new overlays
	for(var/obj/O in update_add)
		var/mutable_appearance/overlay = 69et_overlay(O)
		//var/ima69e/overlay = 69et_overlay(O)

		active_scanned69O69 = overlay
		user_client.ima69es += overlay

	//Remove stale overlays
	for(var/obj/O in update_remove)
		user_client.ima69es -= active_scanned69O69
		active_scanned -= O



//creates a new overlay for a scanned object, if needed
/obj/item/device/t_scanner/proc/69et_overlay(obj/scanned)
	//Use a cache so we don't create a whole bunch of new ima69es just because someone's walkin69 back and forth in a room.
	//Also69eans that ima69es are reused if69ultiple people are usin69 t-rays to look at the same objects.
	if(scanned in overlay_cache)
		. = overlay_cache69scanned69
	else

		var/mutable_appearance/MA = new(scanned)
		MA.appearance_fla69s = KEEP_APART | RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
		MA.plane = current_user.69et_relative_plane(69AME_PLANE)
		MA.layer = ABOVE_HUD_LAYER
		MA.alpha = 128

		var/ima69e/I = ima69e(loc = scanned)
		I.appearance =69A
		I.mouse_opacity = 0
		.=I

	// Add it to cache, cuttin69 old entries if the list is too lon69
	overlay_cache69scanned69 = .
	if(overlay_cache.len > OVERLAY_CACHE_LEN)
		overlay_cache.Cut(1, overlay_cache.len-OVERLAY_CACHE_LEN-1)

/*69ets the list of objects to69ake overlays for.
An object will be shown if it can ever hide under floors, re69ardless of whether it is currently doin69 so
While this has some increased performance cost, it allows pipes to be clearly seen even in cases where they
are technically69isible but obscured, for example by catwalks or trash sittin69 on them.
*/
/obj/item/device/t_scanner/proc/69et_scanned_objects(var/scan_dist)
	. = list()

	var/turf/center = 69et_turf(loc)
	if(!center) return

	for(var/turf/T in RAN69E_TURFS(scan_ran69e, center))
		for(var/obj/O in T.contents)
			if(O.level != BELOW_PLATIN69_LEVEL)
				continue
			if(!O.invisibility && !O.hides_under_floorin69())
				continue //if it's already69isible don't need an overlay for it
			if(istype(O, /obj/item/stora69e))
				var/obj/item/stora69e/S = O
				if(S.is_tray_hidden)
					continue
			. += O




/***************************************
	Interaction
***************************************/
/obj/item/device/t_scanner/attack_self(mob/user)
	set_user(user)
	ui_interact(user)
	//set_enabled(!enabled)

//Alt click provides a rapid way to turn it on and off
/obj/item/device/t_scanner/AltClick(var/mob/M)
	if(loc ==69)
		set_enabled(!enabled)

/obj/item/device/t_scanner/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	// this is the data which will be sent to the ui
	var/data69069
	data69"enabled"69 = enabled ? 1 : 0
	69et_power_cost()
	data69"watta69e"69 = (69et_power_cost()/CELLRATE)
	data69"lifeTime"69 = 69et_lifetime()
	data69"cellPercent"69 = cell ? round(cell.percent(),0.1) : SPAN_DAN69ER("---")
	data69"powerSettin69"69 = scan_ran69e

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "t_ray.tmpl", "Terahertz Ray Emitter", 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/item/device/t_scanner/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"to6969leStatus"69)
		set_enabled(!enabled)
	if(href_list69"setPower"69) //settin69 power to 0 is redundant anyways
		var/new_settin69 = between(1, text2num(href_list69"setPower"69), 7)
		scan_ran69e = new_settin69
		if(active)
			update_overlay()
	playsound(loc, 'sound/machines/machine_switch.o6969', 40, 1, -2)
	add_fin69erprint(usr)
	spawn()
		ui_interact(usr)


/************************************
	STATE69ANA69EMENT
************************************/
/obj/item/device/t_scanner/Process()
	if(enabled && !cell_use_check(69et_power_cost()))
		set_enabled(FALSE)
		return //Ran out of power


/obj/item/device/t_scanner/proc/set_enabled(tar69etstate)
	//Check power here#
	if(tar69etstate == FALSE && enabled)
		playsound(loc, turn_on_sound, 55, 1,-2)
	enabled = FALSE
	if(tar69etstate == TRUE)
		if(cell_use_check(active_power_usa69e*(scan_ran69e+2)*CELLRATE))
			enabled = TRUE
			playsound(loc, turn_on_sound, 55, 1, -2)

	if(enabled)
		START_PROCESSIN69(SSobj, src)
	else
		STOP_PROCESSIN69(SSobj, src)
	check_active(enabled)
	update_icon()

/obj/item/device/t_scanner/proc/check_active(var/tar69etstate = TRUE)
	//First of all, check if its bein69 turned off. This is simpler
	if(!tar69etstate)
		if(!active)
			//If we were just turned off, but we were already inactive, then we don't need to do anythin69
			return

		//We were active, ok lets shut down thin69s
		set_inactive()
	else
		//We're tryin69 to become active, alri69ht lets do some checks
		//We'll do these checks even if we're already active, they ensure we can remain so
		var/can_activate = TRUE

		//First we69ust be enabled
		if(!enabled)
			can_activate = FALSE

		//Secondly, we69ust be held in someone's hands
		else if(!check_location())
			can_activate = FALSE

		//Thirdly, we need a client to display to
		else if(!user_client)
			//The client69ay not be set if the user lo6969ed out and in a69ain
			set_client() //Try re-settin69 it
			if(!user_client)
				can_activate = FALSE

		if(!can_activate)
			//We failed the above, what now
			if(active)
				set_inactive()

		else if(!active)
			set_active()



//Handles shutdown and cleanup
/obj/item/device/t_scanner/proc/set_inactive()
	unset_client(null)
	active = FALSE


/obj/item/device/t_scanner/proc/set_active()
	event_source = 69et_track_tar69et()
	69LOB.moved_event.re69ister(event_source, src, /obj/item/device/t_scanner/proc/update_overlay)
	active = TRUE
	update_overlay()


//Called in any situation where the user69i69ht chan69e
/obj/item/device/t_scanner/proc/set_user(mob/livin69/newuser)
	if(current_user == newuser)
		return //Do nothin69

	//If there's an existin69 user we69ay need to unre69ister them first
	if(current_user)
		unset_client()

	//Actually set it
	current_user = newuser
	set_client()
	event_source = 69et_track_tar69et()
	check_active()


/obj/item/device/t_scanner/proc/set_client()
	if(!current_user || !current_user.client)
		return FALSE

	user_client = current_user.client


	for(var/scanned in active_scanned)
		user_client.ima69es += active_scanned69scanned69



/obj/item/device/t_scanner/proc/unset_client()
	if(event_source)
		69LOB.moved_event.unre69ister(event_source, src)
		event_source = null
	if(user_client)
		for(var/scanned in active_scanned)
			user_client.ima69es -= active_scanned69scanned69

	user_client = null
	active_scanned.Cut()





/obj/item/device/t_scanner/proc/check_location()
	//This proc checks that the scanner is where it needs to be.
	//In this case, this69eans it69ust be held in the hands of a69ob

	//This is a seperate proc so that it can be overridden later. For example to allow for scanners embedded in other thin69s
	if(!ismob(loc))
		return FALSE

	if(!is_held())
		return FALSE

	return TRUE


//Find the object whose69ovement we will track
//Like the above, this is a seperate proc so it can be overridden
/obj/item/device/t_scanner/proc/69et_track_tar69et()
	return current_user


//Returns an estimate of how lon69 the scanner will run on its current remainin69 battery
/obj/item/device/t_scanner/proc/69et_lifetime()
	if(!cell || cell.is_empty())
		return "00:00"

	var/numseconds = cell.char69e / 69et_power_cost()
	return time2text(numseconds*10, "mm:ss") //time2text takes deciseconds, so the amounts are tenfold


//Whenever the scanner is e69uipped to a slot or dropped on the 69round or deleted, set the user appropriately
/obj/item/device/t_scanner/dropped(mob/user)
	.=..()
	set_user(null)

/obj/item/device/t_scanner/e69uipped(mob/M)
	.=..()
	set_user(M)

/obj/item/device/t_scanner/Destroy()
	set_user(null)
	.=..()
#undef OVERLAY_CACHE_LEN

//Device procs

//This stuff shouldn't be limited to this, but should be basic device behaviour

//How69uch power we use when enabled. Based on scan ran69e
/obj/item/device/t_scanner/proc/69et_power_cost()
	return active_power_usa69e*(2+(scan_ran69e*0.8))*CELLRATE
