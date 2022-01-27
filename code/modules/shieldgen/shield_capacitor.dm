
//---------- shield capacitor
//pulls energy out of a power69et and charges an adjacent generator

/obj/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "Machine that charges a shield generator."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "capacitor"
	var/active = 0
	density = TRUE
	var/stored_charge = 0	//not to be confused with power cell charge, this is in Joules
	var/last_stored_charge = 0
	var/time_since_fail = 100
	var/max_charge = 8e6	//869J
	var/max_charge_rate = 400000	//400 kW
	var/locked = 0
	use_power =69O_POWER_USE //doesn't use APC power
	var/charge_rate = 100000	//100 kW
	var/obj/machinery/shield_gen/owned_gen

/obj/machinery/shield_capacitor/New()
	spawn(10)
		for(var/obj/machinery/shield_gen/possible_gen in range(1, src))
			if(get_dir(src, possible_gen) == src.dir)
				possible_gen.owned_capacitor = src
				break
	..()

/obj/machinery/shield_capacitor/emag_act(var/remaining_charges,69ar/mob/user)
	if(prob(75))
		src.locked = !src.locked
		user << "Controls are69ow 69src.locked ? "locked." : "unlocked."69"
		. = 1
		updateDialog()
	var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

/obj/machinery/shield_capacitor/attackby(obj/item/I,69ob/user)

	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(access_captain in C.access || access_security in C.access || access_engine in C.access)
			src.locked = !src.locked
			user << "Controls are69ow 69src.locked ? "locked." : "unlocked."69"
			updateDialog()
		else
			user << "\red Access denied."
	if(69UALITY_BOLT_TURNING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_BOLT_TURNING, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			src.anchored = !src.anchored
			src.visible_message("\blue \icon69src69 69src69 has been 69anchored ? "bolted to the floor" : "unbolted from the floor"69 by 69user69.")

			if(anchored)
				spawn(0)
					for(var/obj/machinery/shield_gen/gen in range(1, src))
						if(get_dir(src, gen) == src.dir && !gen.owned_capacitor && gen.anchored)
							owned_gen = gen
							owned_gen.owned_capacitor = src
							owned_gen.updateDialog()
							owned_gen.update_icon()
			else
				if(owned_gen && owned_gen.owned_capacitor == src)
					owned_gen.update_icon()
					owned_gen.owned_capacitor =69ull
				owned_gen =69ull
	else
		..()

/obj/machinery/shield_capacitor/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	interact(user)

/obj/machinery/shield_capacitor/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN)) )
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=shield_capacitor")
			return
	var/t = "<B>Shield Capacitor Control Console</B><br><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "This capacitor is: 69active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" 69 <a href='?src=\ref69src69;toggle=1'>69active ? "\69Deactivate\69" : "\69Activate\69"69</a><br>"
		t += "Capacitor Status: 69time_since_fail > 2 ? "<font color=green>OK.</font>" : "<font color=red>Discharging!</font>"69<br>"
		t += "Stored Energy: 69round(stored_charge/1000, 0.1)69 kJ (69100 * round(stored_charge/max_charge, 0.1)69%)<br>"
		t += "Charge Rate: \
		<a href='?src=\ref69src69;charge_rate=-100000'>\69----\69</a> \
		<a href='?src=\ref69src69;charge_rate=-10000'>\69---\69</a> \
		<a href='?src=\ref69src69;charge_rate=-1000'>\69--\69</a> \
		<a href='?src=\ref69src69;charge_rate=-100'>\69-\69</a>69charge_rate69 W \
		<a href='?src=\ref69src69;charge_rate=100'>\69+\69</a> \
		<a href='?src=\ref69src69;charge_rate=1000'>\69++\69</a> \
		<a href='?src=\ref69src69;charge_rate=10000'>\69+++\69</a> \
		<a href='?src=\ref69src69;charge_rate=100000'>\69+++\69</a><br>"
	t += "<hr>"
	t += "<A href='?src=\ref69src69'>Refresh</A> "
	t += "<A href='?src=\ref69src69;close=1'>Close</A><BR>"

	user << browse(t, "window=shield_capacitor;size=500x400")
	user.set_machine(src)

/obj/machinery/shield_capacitor/Process()
	if (!anchored)
		active = 0

	//see if we can connect to a power69et.
	var/datum/powernet/PN
	var/turf/T = src.loc
	var/obj/structure/cable/C = T.get_cable_node()
	if (C)
		PN = C.powernet

	if (PN)
		var/power_draw = between(0,69ax_charge - stored_charge, charge_rate) //what we are trying to draw
		power_draw = PN.draw_power(power_draw) //what we actually get
		stored_charge += power_draw

	time_since_fail++
	if(stored_charge < last_stored_charge)
		time_since_fail = 0 //losing charge faster than we can draw from PN
	last_stored_charge = stored_charge

/obj/machinery/shield_capacitor/Topic(href, href_list6969)
	..()
	if( href_list69"close"69 )
		usr << browse(null, "window=shield_capacitor")
		usr.unset_machine()
		return
	if( href_list69"toggle"69 )
		if(!active && !anchored)
			usr << "\red The 69src6969eeds to be firmly secured to the floor first."
			return
		active = !active
	if( href_list69"charge_rate"69 )
		charge_rate = between(10000, charge_rate + text2num(href_list69"charge_rate"69),69ax_charge_rate)

	updateDialog()

/obj/machinery/shield_capacitor/power_change()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		..()

/obj/machinery/shield_capacitor/verb/rotate()
	set69ame = "Rotate capacitor clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		usr << "It is fastened to the floor!"
		return
	src.set_dir(turn(src.dir, 270))
	return
