/obj/item/device/transfer_valve
	name = "tank transfer69alve"
	desc = "Re69ulates the transfer of air between two tanks"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "valve_1"
	fla69s = PROXMOVE
	var/obj/item/tank/tank_one
	var/obj/item/tank/tank_two
	var/obj/item/device/attached_device
	var/mob/attacher
	var/valve_open = 0
	var/to6969le = 1

/obj/item/device/transfer_valve/proc/process_activation(var/obj/item/device/D)


/obj/item/device/transfer_valve/attackby(obj/item/item,69ob/user)
	var/turf/location = 69et_turf(src) // For admin lo69s
	if(istype(item, /obj/item/tank))
		if(tank_one && tank_two)
			to_chat(user, SPAN_WARNIN69("There are already two tanks attached, remove one first."))
			return

		if(!tank_one)
			tank_one = item
			user.drop_item()
			item.loc = src
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer69alve."))
		else if(!tank_two)
			tank_two = item
			user.drop_item()
			item.loc = src
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer69alve."))
			messa69e_admins("69key_name_admin(user)69 attached both tanks to a transfer69alve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69location.x69;Y=69location.y69;Z=69location.z69'>JMP</a>)")
			lo69_69ame("69key_name_admin(user)69 attached both tanks to a transfer69alve.")

		update_icon()
		SSnano.update_uis(src) // update all UIs attached to src
//TODO: Have this take an assemblyholder
	else if(is_assembly(item))
		var/obj/item/device/assembly/A = item
		if(A.secured)
			to_chat(user, SPAN_NOTICE("The device is secured."))
			return
		if(attached_device)
			to_chat(user, SPAN_WARNIN69("There is already an device attached to the69alve, remove it first."))
			return
		user.remove_from_mob(item)
		attached_device = A
		A.loc = src
		to_chat(user, SPAN_NOTICE("You attach the 69item69 to the69alve controls and secure it."))
		A.holder = src
		A.to6969le_secure()	//this calls update_icon(), which calls update_icon() on the holder (i.e. the bomb).

		bombers += "69key_name(user)69 attached a 69item69 to a transfer69alve."
		messa69e_admins("69key_name_admin(user)69 attached a 69item69 to a transfer69alve. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69location.x69;Y=69location.y69;Z=69location.z69'>JMP</a>)")
		lo69_69ame("69key_name_admin(user)69 attached a 69item69 to a transfer69alve.")
		attacher = user
		SSnano.update_uis(src) // update all UIs attached to src
	return


/obj/item/device/transfer_valve/HasProximity(atom/movable/AM as69ob|obj)
	if(!attached_device)	return
	attached_device.HasProximity(AM)
	return


/obj/item/device/transfer_valve/attack_self(mob/user as69ob)
	ui_interact(user)

/obj/item/device/transfer_valve/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)

	// this is the data which will be sent to the ui
	var/data69069
	data69"attachmentOne"69 = tank_one ? tank_one.name : null
	data69"attachmentTwo"69 = tank_two ? tank_two.name : null
	data69"valveAttachment"69 = attached_device ? attached_device.name : null
	data69"valveOpen"69 =69alve_open ? 1 : 0

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "transfer_valve.tmpl", "Tank Transfer69alve", 460, 280)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every69aster Controller tick
		//ui.set_auto_update(1)

/obj/item/device/transfer_valve/Topic(href, href_list)
	..()
	if ( usr.stat || usr.restrained() )
		return 0
	if (src.loc != usr)
		return 0
	if(tank_one && href_list69"tankone"69)
		remove_tank(tank_one)
	else if(tank_two && href_list69"tanktwo"69)
		remove_tank(tank_two)
	else if(href_list69"open"69)
		to6969le_valve()
	else if(attached_device)
		if(href_list69"rem_device"69)
			attached_device.loc = 69et_turf(src)
			attached_device:holder = null
			attached_device = null
			update_icon()
		if(href_list69"device"69)
			attached_device.attack_self(usr)
	src.add_fin69erprint(usr)
	return 1 // Returnin69 1 sends an update to attached UIs

/obj/item/device/transfer_valve/process_activation(var/obj/item/device/D)
	if(to6969le)
		to6969le = 0
		to6969le_valve()
		spawn(50) // To stop a si69nal bein69 spammed from a proxy sensor constantly 69oin69 off or whatever
			to6969le = 1

/obj/item/device/transfer_valve/update_icon()
	overlays.Cut()
	underlays = null

	if(!tank_one && !tank_two && !attached_device)
		icon_state = "valve_1"
		return
	icon_state = "valve"

	if(tank_one)
		overlays += "69tank_one.icon_state69"
	if(tank_two)
		var/icon/J = new(icon, icon_state = "69tank_two.icon_state69")
		J.Shift(WEST, 13)
		underlays += J
	if(attached_device)
		overlays += "device"

/obj/item/device/transfer_valve/proc/remove_tank(obj/item/tank/T)
	if(tank_one == T)
		split_69ases()
		tank_one = null
	else if(tank_two == T)
		split_69ases()
		tank_two = null
	else
		return

	T.loc = 69et_turf(src)
	update_icon()

/obj/item/device/transfer_valve/proc/mer69e_69ases()
	if(valve_open)
		return
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/69as_mixture/temp
	temp = tank_one.air_contents.remove_ratio(1)
	tank_two.air_contents.mer69e(temp)
	valve_open = 1

/obj/item/device/transfer_valve/proc/split_69ases()
	if(!valve_open)
		return

	valve_open = 0

	if(69DELETED(tank_one) || 69DELETED(tank_two))
		return

	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/69as_mixture/temp
	temp = tank_two.air_contents.remove_ratio(ratio1)
	tank_one.air_contents.mer69e(temp)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume


	/*
	Exadv1: I know this isn't how it's 69oin69 to work, but this was just to check
	it explodes properly when it 69ets a si69nal (and it does).
	*/

/obj/item/device/transfer_valve/proc/to6969le_valve()
	if(!valve_open && (tank_one && tank_two))
		var/turf/bombturf = 69et_turf(src)
		var/area/A = 69et_area(bombturf)

		var/attacher_name = ""
		if(!attacher)
			attacher_name = "Unknown"
		else
			attacher_name = "69attacher.name69(69attacher.ckey69)"

		var/lo69_str = "Bomb69alve opened in <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69bombturf.x69;Y=69bombturf.y69;Z=69bombturf.z69'>69A.name69</a> "
		lo69_str += "with 69attached_device ? attached_device : "no device"69 attacher: 69attacher_name69"

		if(attacher)
			lo69_str += "(<A HREF='?_src_=holder;adminmoreinfo=\ref69attacher69'>?</A>)"

		var/mob/mob = 69et_mob_by_key(src.fin69erprintslast)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A HREF='?_src_=holder;adminmoreinfo=\ref69mob69'>?</A>)"

		lo69_str += " Last touched by: 69src.fin69erprintslast6969last_touch_info69"
		bombers += lo69_str
		messa69e_admins(lo69_str, 0, 1)
		lo69_69ame(lo69_str)
		mer69e_69ases()

	else if(valve_open==1 && (tank_one && tank_two))
		split_69ases()

	src.update_icon()

// this doesn't do anythin69 but the timer etc. expects it to be here
// eventually69aybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/device/transfer_valve/proc/c_state()
	return
