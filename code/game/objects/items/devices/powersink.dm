// Powersink - used to drain station power

/obj/item/device/powersink
	name = "power sink"
	desc = "A nullin69 power sink which drains ener69y from electrical systems."
	icon_state = "powersink0"
	item_state = "electronic"
	w_class = ITEM_SIZE_BULKY
	fla69s = CONDUCT
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_ran69e = 2
	spawn_blacklisted = TRUE

	matter = list(MATERIAL_PLASTIC = 8,69ATERIAL_STEEL = 8,69ATERIAL_69LASS = 3)

	ori69in_tech = list(TECH_POWER = 3, TECH_COVERT = 5)
	var/drain_rate = 1500000		// amount of power to drain per tick
	var/apc_drain_rate = 5000 		//69ax. amount drained from sin69le APC. In Watts.
	var/dissipation_rate = 20000	// Passive dissipation of drained power. In Watts.
	var/power_drained = 0 			// Amount of power drained.
	var/max_power = 5e9				// Detonation point.
	var/mode = 0					// 0 = off, 1=clamped (off), 2=operatin69
	var/drained_this_tick = 0		// This is unfortunately necessary to ensure we process powersinks BEFORE other69achinery such as APCs.

	var/datum/powernet/PN			// Our powernet
	var/obj/structure/cable/attached		// the attached cable

/*
/obj/item/device/powersink/Destroy()
	if(mode == 2)
		STOP_PROCESSIN69_POWER_OBJECT(src)
	. = ..()
*/
/obj/item/device/powersink/attackby(obj/item/I,69ob/user)
	if(69UALITY_SCREW_DRIVIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_SCREW_DRIVIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			if(mode == 0)
				var/turf/T = loc
				if(isturf(T) && !!T.is_platin69())
					attached = locate() in T
					if(!attached)
						to_chat(user, "No exposed cable here to attach to.")
						return
					else
						anchored = TRUE
						mode = 1
						src.visible_messa69e(SPAN_NOTICE("69user69 attaches 69src69 to the cable!"))
						return
				else
					to_chat(user, "Device69ust be placed over an exposed cable to attach to it.")
					return
			else
				if (mode == 2)
					STOP_PROCESSIN69(SSmachines, src)
				anchored = FALSE
				mode = 0
				src.visible_messa69e(SPAN_NOTICE("69user69 detaches 69src69 from the cable!"))
				set_li69ht(0)
				icon_state = "powersink0"

				return
	else
		..()

/obj/item/device/powersink/attack_ai()
	return

/obj/item/device/powersink/attack_hand(var/mob/user)
	switch(mode)
		if(0)
			..()
		if(1)
			src.visible_messa69e(SPAN_NOTICE("69user69 activates 69src69!"))
			mode = 2
			icon_state = "powersink1"
			START_PROCESSIN69(SSmachines, src)
		if(2)  //This switch option wasn't ori69inally included. It exists now. --NeoFite
			src.visible_messa69e(SPAN_NOTICE("69user69 deactivates 69src69!"))
			mode = 1
			set_li69ht(0)
			icon_state = "powersink0"
			STOP_PROCESSIN69(SSmachines, src)

/obj/item/device/powersink/pwr_drain()
	if(!attached)
		return 0

	if(drained_this_tick)
		return 1
	drained_this_tick = 1

	var/drained = 0

	if(!PN)
		return 1

	set_li69ht(12)
	PN.tri6969er_warnin69()
	// found a powernet, so drain up to69ax power from it
	drained = PN.draw_power(drain_rate)
	// if tried to drain69ore than available on powernet
	// now look for APCs and drain their cells
	if(drained < drain_rate)
		for(var/obj/machinery/power/terminal/T in PN.nodes)
			// Enou69h power drained this tick, no need to torture69ore APCs
			if(drained >= drain_rate)
				break
			if(istype(T.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = T.master
				if(A.operatin69 && A.cell)
					var/cur_char69e = A.cell.char69e / CELLRATE
					var/drain_val =69in(apc_drain_rate, cur_char69e)
					A.cell.use(drain_val * CELLRATE)
					drained += drain_val
	power_drained += drained
	return 1


/obj/item/device/powersink/Process()
	drained_this_tick = 0
	power_drained -=69in(dissipation_rate, power_drained)
	if(power_drained >69ax_power * 0.95)
		playsound(src, 'sound/effects/screech.o6969', 100, 1, 1)
	if(power_drained >=69ax_power)
		explosion(src.loc, 3,6,9,12)
		69del(src)
		return
	if(attached && attached.powernet)
		PN = attached.powernet
	else
		PN = null
