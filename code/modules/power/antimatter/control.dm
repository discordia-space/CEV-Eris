/obj/machinery/power/am_control_unit
	name = "antimatter control unit"
	desc = "This device injects antimatter into connected shielding units. The69ore antimatter injected into it, the69ore power it produces.  Wrench the device to set it up."
	icon = 'icons/obj/machines/antimatter.dmi'
	icon_state = "control"
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 100
	active_power_usage = 1000

	var/list/obj/machinery/am_shielding/linked_shielding
	var/list/obj/machinery/am_shielding/linked_cores
	var/obj/item/am_containment/fueljar
	var/update_shield_icons = 0
	var/stability = 100
	var/exploding = 0

	var/active = 0//On or69ot
	var/fuel_injection = 2//How69uch fuel to inject
	var/shield_icon_delay = 0//delays resetting for a short time
	var/reported_core_efficiency = 0

	var/power_cycle = 0
	var/power_cycle_delay = 4//How69any ticks till produce_power is called
	var/stored_core_stability = 0
	var/stored_core_stability_delay = 0

	var/stored_power = 0//Power to deploy per tick


/obj/machinery/power/am_control_unit/New()
	..()
	linked_shielding = list()
	linked_cores = list()


/obj/machinery/power/am_control_unit/Destroy()//Perhaps damage and run stability checks rather than just qdel on the others
	for(var/obj/machinery/am_shielding/AMS in linked_shielding)
		qdel(AMS)
	. = ..()


/obj/machinery/power/am_control_unit/Process()
	if(exploding)
		explosion(get_turf(src),8,12,18,12)
		if(src) qdel(src)

	if(update_shield_icons && !shield_icon_delay)
		check_shield_icons()
		update_shield_icons = 0

	if(stat & (NOPOWER|BROKEN) || !active)//can update the icons even without power
		return

	if(!fueljar)//No fuel but we are on, shutdown
		toggle_power()
		//Angry buzz or such here
		return

	add_avail(stored_power)

	power_cycle++
	if(power_cycle >= power_cycle_delay)
		produce_power()
		power_cycle = 0

	return


/obj/machinery/power/am_control_unit/proc/produce_power()
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/core_power = reported_core_efficiency//Effectively how69uch fuel we can safely deal with
	if(core_power <= 0) return 0//Something is wrong
	var/core_damage = 0
	var/fuel = fueljar.usefuel(fuel_injection)

	stored_power = (fuel/core_power)*fuel*200000
	//Now check if the cores could deal with it safely, this is done after so you can overload for69ore power if69eeded, still a bad idea
	if(fuel > (2*core_power))//More fuel has been put in than the current cores can deal with
		if(prob(50))core_damage = 1//Small chance of damage
		if((fuel-core_power) > 5)	core_damage = 5//Now its really starting to overload the cores
		if((fuel-core_power) > 10)	core_damage = 20//Welp69ow you did it, they wont stand69uch of this
		if(core_damage == 0) return
		for(var/obj/machinery/am_shielding/AMS in linked_cores)
			AMS.stability -= core_damage
			AMS.check_stability(1)
		playsound(src.loc, 'sound/effects/bang.ogg', 50, 1)
	return


/obj/machinery/power/am_control_unit/emp_act(severity)
	switch(severity)
		if(1)
			if(active)	toggle_power()
			stability -= rand(15,30)
		if(2)
			if(active)	toggle_power()
			stability -= rand(10,20)
	..()
	return 0


/obj/machinery/power/am_control_unit/ex_act(severity)
	switch(severity)
		if(1)
			stability -= 60
		if(2)
			stability -= 40
		if(3)
			stability -= 20
	check_stability()
	return


/obj/machinery/power/am_control_unit/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.check_armour != ARMOR_BULLET)
		stability -= Proj.force
	return 0


/obj/machinery/power/am_control_unit/power_change()
	..()
	if(stat &69OPOWER && active)
		toggle_power()
	return


/obj/machinery/power/am_control_unit/update_icon()
	if(active) icon_state = "control_on"
	else icon_state = "control"
	//No other icons for it atm


/obj/machinery/power/am_control_unit/attackby(obj/item/I,69ob/user)

	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(anchored || linked_shielding.len)
			to_chat(user, "\red Once bolted and linked to a shielding unit it the 69src.name69 is unable to be69oved!")
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
			if(!anchored)
				user.visible_message("69user.name69 secures the 69src.name69 to the floor.", \
					"You secure the anchor bolts to the floor.", \
					"You hear a ratchet")
				src.anchored = TRUE
				connect_to_network()
			else if(!linked_shielding.len > 0)
				user.visible_message("69user.name69 unsecures the 69src.name69.", \
					"You remove the anchor bolts.", \
					"You hear a ratchet")
				src.anchored = FALSE
				disconnect_from_network()
			return

	if(istype(I, /obj/item/am_containment))
		if(fueljar)
			to_chat(user, "\red There is already a 69fueljar69 inside!")
			return
		fueljar = I
		user.remove_from_mob(I)
		I.loc = src
		user.update_icons()
		user.visible_message("69user.name69 loads an 69I.name69 into the 69src.name69.", \
				"You load an 69I.name69.", \
				"You hear a thunk.")
		return

	if(I.force >= 20)
		stability -= I.force/2
		check_stability()
	..()
	return


/obj/machinery/power/am_control_unit/attack_hand(mob/user as69ob)
	if(anchored)
		interact(user)
	return


/obj/machinery/power/am_control_unit/proc/add_shielding(var/obj/machinery/am_shielding/AMS,69ar/AMS_linking = 0)
	if(!istype(AMS)) return 0
	if(!anchored) return 0
	if(!AMS_linking && !AMS.link_control(src)) return 0
	linked_shielding.Add(AMS)
	update_shield_icons = 1
	return 1


/obj/machinery/power/am_control_unit/proc/remove_shielding(var/obj/machinery/am_shielding/AMS)
	if(!istype(AMS)) return 0
	linked_shielding.Remove(AMS)
	update_shield_icons = 2
	if(active)	toggle_power()
	return 1


/obj/machinery/power/am_control_unit/proc/check_stability()//TODO:69ake it break when low also69ight want to add a way to fix it like a part or such that can be replaced
	if(stability <= 0)
		qdel(src)
	return


/obj/machinery/power/am_control_unit/proc/toggle_power()
	active = !active
	if(active)
		use_power = ACTIVE_POWER_USE
		visible_message("The 69src.name69 starts up.")
	else
		use_power = IDLE_POWER_USE
		visible_message("The 69src.name69 shuts down.")
	update_icon()
	return


/obj/machinery/power/am_control_unit/proc/check_shield_icons()//Forces icon_update for all shields
	if(shield_icon_delay) return
	shield_icon_delay = 1
	if(update_shield_icons == 2)//269eans to clear everything and rebuild
		for(var/obj/machinery/am_shielding/AMS in linked_shielding)
			if(AMS.processing)	AMS.shutdown_core()
			AMS.control_unit =69ull
			spawn(10)
				AMS.controllerscan()
		linked_shielding = list()

	else
		for(var/obj/machinery/am_shielding/AMS in linked_shielding)
			AMS.update_icon()
	spawn(20)
		shield_icon_delay = 0
	return


/obj/machinery/power/am_control_unit/proc/check_core_stability()
	if(stored_core_stability_delay || linked_cores.len <= 0)	return
	stored_core_stability_delay = 1
	stored_core_stability = 0
	for(var/obj/machinery/am_shielding/AMS in linked_cores)
		stored_core_stability += AMS.stability
	stored_core_stability/=linked_cores.len
	spawn(40)
		stored_core_stability_delay = 0
	return


/obj/machinery/power/am_control_unit/interact(mob/user)
	if((get_dist(src, user) > 1) || (stat & (BROKEN|NOPOWER)))
		if(!isAI(user))
			user.unset_machine()
			user << browse(null, "window=AMcontrol")
			return
	user.set_machine(src)

	var/dat = ""
	dat += "AntiMatter Control Panel<BR>"
	dat += "<A href='?src=\ref69src69;close=1'>Close</A><BR>"
	dat += "<A href='?src=\ref69src69;refresh=1'>Refresh</A><BR>"
	dat += "<A href='?src=\ref69src69;refreshicons=1'>Force Shielding Update</A><BR><BR>"
	dat += "Status: 69(active?"Injecting":"Standby")69 <BR>"
	dat += "<A href='?src=\ref69src69;togglestatus=1'>Toggle Status</A><BR>"

	dat += "Instability: 69stability69%<BR>"
	dat += "Reactor parts: 69linked_shielding.len69<BR>"//TODO: perhaps add some sort of stability check
	dat += "Cores: 69linked_cores.len69<BR><BR>"
	dat += "-Current Efficiency: 69reported_core_efficiency69<BR>"
	dat += "-Average Stability: 69stored_core_stability69 <A href='?src=\ref69src69;refreshstability=1'>(update)</A><BR>"
	dat += "Last Produced: 69stored_power69<BR>"

	dat += "Fuel: "
	if(!fueljar)
		dat += "<BR>No fuel receptacle detected."
	else
		dat += "<A href='?src=\ref69src69;ejectjar=1'>Eject</A><BR>"
		dat += "- 69fueljar.fuel69/69fueljar.fuel_max69 Units<BR>"

		dat += "- Injecting: 69fuel_injection69 units<BR>"
		dat += "- <A href='?src=\ref69src69;strengthdown=1'>--</A>|<A href='?src=\ref69src69;strengthup=1'>++</A><BR><BR>"


	user << browse(dat, "window=AMcontrol;size=420x500")
	onclose(user, "AMcontrol")
	return


/obj/machinery/power/am_control_unit/Topic(href, href_list)
	..()
	//Ignore input if we are broken or guy is69ot touching us, AI can control from a ways away
	if(stat & (BROKEN|NOPOWER) || (get_dist(src, usr) > 1 && !isAI(usr)))
		usr.unset_machine()
		usr << browse(null, "window=AMcontrol")
		return

	if(href_list69"close"69)
		usr << browse(null, "window=AMcontrol")
		usr.unset_machine()
		return

	if(href_list69"togglestatus"69)
		toggle_power()

	if(href_list69"refreshicons"69)
		update_shield_icons = 1

	if(href_list69"ejectjar"69)
		if(fueljar)
			fueljar.loc = src.loc
			fueljar =69ull
			//fueljar.control_unit =69ull currently it does69ot care where it is
			//update_icon() when we have the icon for it

	if(href_list69"strengthup"69)
		fuel_injection++

	if(href_list69"strengthdown"69)
		fuel_injection--
		if(fuel_injection < 0) fuel_injection = 0

	if(href_list69"refreshstability"69)
		check_core_stability()

	updateDialog()
	return
