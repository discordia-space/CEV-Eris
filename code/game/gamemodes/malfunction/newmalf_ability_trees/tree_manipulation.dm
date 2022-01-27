//69ANIPULATION TREE
//
// Abilities in this tree allow the AI to physically69anipulate systems around the station.
// T1 - Electrical Pulse - Sends out pulse that breaks some lights and sometimes even APCs. This can actually break the AI's APC so be careful!
// T2 - Hack Camera - Allows the AI to hack a camera. Deactivated areas69ay be reactivated, and functional cameras can be upgraded.
// T3 - Emergency Forcefield - Allows the AI to project 1 tile forcefield that blocks69ovement and air flow. Forcefield�dissipates over time. It is also69ery susceptible to energetic weaponry.
// T4 -69achine Overload - Detonates69achine of choice in a69inor explosion. Two of these are usually enough to kill or K/O someone.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/manipulation/electrical_pulse
	ability = new/datum/game_mode/malfunction/verb/electrical_pulse()
	price = 50
	next = new/datum/malf_research_ability/manipulation/hack_camera()
	name = "Electrical Pulse"


/datum/malf_research_ability/manipulation/hack_camera
	ability = new/datum/game_mode/malfunction/verb/hack_camera()
	price = 1200
	next = new/datum/malf_research_ability/manipulation/emergency_forcefield()
	name = "Hack Camera"


/datum/malf_research_ability/manipulation/emergency_forcefield
	ability = new/datum/game_mode/malfunction/verb/emergency_forcefield()
	price = 3000
	next = new/datum/malf_research_ability/manipulation/machine_overload()
	name = "Emergency Forcefield"


/datum/malf_research_ability/manipulation/machine_overload
	ability = new/datum/game_mode/malfunction/verb/machine_overload()
	price = 7500
	name = "Machine Overload"

// END RESEARCH DATUMS
// BEGIN ABILITY69ERBS

/datum/game_mode/malfunction/verb/electrical_pulse()
	set name = "Electrical Pulse"
	set desc = "15 CPU - Sends feedback pulse through ship's power grid, overloading some sensitive systems, such as lights."
	set category = "Software"
	var/price = 15
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price) || !ability_pay(user,price))
		return
	to_chat(user, "Sending feedback pulse...")
	for(var/obj/machinery/power/apc/AP in GLOB.apc_list)
		if(prob(5))
			AP.overload_lighting()
		if(prob(1) && prob(1)) //69ery69ery small chance to actually destroy the APC.
			AP.set_broken()


/datum/game_mode/malfunction/verb/hack_camera(var/obj/machinery/camera/target in cameranet.cameras)
	set name = "Hack Camera"
	set desc = "100 CPU - Hacks existing camera, allowing you to add upgrade of your choice to it. Alternatively it lets you reactivate broken camera."
	set category = "Software"
	var/price = 100
	var/mob/living/silicon/ai/user = usr

	if(target && !istype(target))
		to_chat(user, "This is not a camera.")
		return

	if(!target)
		return

	if(!ability_prechecks(user, price))
		return

	var/action = input("Select re69uired action: ") in list("Reset", "Add X-Ray", "Add69otion Sensor", "Add EMP Shielding")
	if(!action || !target)
		return

	switch(action)
		if("Reset")
			if(target.wires)
				if(!ability_pay(user, price))
					return
				target.reset_wires()
				to_chat(user, "Camera reactivated.")
		if("Add X-Ray")
			if(target.isXRay())
				to_chat(user, "Camera already has X-Ray function.")
				return
			else if(ability_pay(user, price))
				target.upgradeXRay()
				target.reset_wires()
				to_chat(user, "X-Ray camera69odule enabled.")
				return
		if("Add69otion Sensor")
			if(target.isMotion())
				to_chat(user, "Camera already has69otion Sensor function.")
				return
			else if(ability_pay(user, price))
				target.upgradeMotion()
				target.reset_wires()
				to_chat(user, "Motion Sensor camera69odule enabled.")
				return
		if("Add EMP Shielding")
			if(target.isEmpProof())
				to_chat(user, "Camera already has EMP Shielding function.")
				return
			else if(ability_pay(user, price))
				target.upgradeEmpProof()
				target.reset_wires()
				to_chat(user, "EMP Shielding camera69odule enabled.")
				return


/datum/game_mode/malfunction/verb/emergency_forcefield()
	set name = "Emergency Forcefield"
	set desc = "275 CPU - Uses ship's emergency shielding system to create temporary barrier which lasts indefinetely, but won't resist EMP pulses."
	set category = "Software"
	var/price = 275
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return
	var/turf/target_turf = get_turf(user.client.virtual_eye)
	if(!target_turf)
		return

	to_chat(user, "Emergency forcefield projection completed.")
	new/obj/machinery/shield/malfai(target_turf)
	user.hacking = 1
	spawn(20)
		user.hacking = 0


/datum/game_mode/malfunction/verb/machine_overload(obj/machinery/M in GLOB.machines)
	set name = "Machine Overload"
	set desc = "400 CPU - Causes cyclic short-circuit in69achine, resulting in weak explosion after some time."
	set category = "Software"
	var/price = 400
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	var/obj/machinery/power/N =69

	var/explosion_intensity = 2

	//69erify if we can overload the target, if yes, calculate explosion strength. Some things have higher explosion strength than others, depending on charge(APCs, SMESs)
	if(N && istype(N)) // /obj/machinery/power first, these create bigger explosions due to direct powernet connection
		if(!istype(N, /obj/machinery/power/apc) && !istype(N, /obj/machinery/power/smes/buildable) && (!N.powernet || !N.powernet.avail)) // Directly connected69achine which is not an APC or SMES. Either it has no powernet connection or it's powernet does not have enough power to overload
			to_chat(user, SPAN_NOTICE("ERROR: Low network69oltage. Unable to overload. Increase network power level and try again."))
			return
		else if (istype(N, /obj/machinery/power/apc)) // APC. Explosion is increased by available cell power.
			var/obj/machinery/power/apc/A = N
			if(A.cell && A.cell.charge)
				explosion_intensity = 4 + round(A.cell.charge / 2000) // Explosion is increased by 1 for every 2k charge in cell
			else
				to_chat(user, SPAN_NOTICE("ERROR: APC69alfunction - Cell depleted or removed. Unable to overload."))
				return
		else if (istype(N, /obj/machinery/power/smes/buildable)) // SMES. These explode in a69ery69ery69ery big boom. Similar to69agnetic containment failure when69essing with coils.
			var/obj/machinery/power/smes/buildable/S = N
			if(S.charge && S.RCon)
				explosion_intensity = 4 + round(S.charge / 1000000)
			else
				// Different error texts
				if(!S.charge)
					to_chat(user, SPAN_NOTICE("ERROR: SMES Depleted. Unable to overload. Please charge SMES unit and try again."))
				else
					to_chat(user, SPAN_NOTICE("ERROR: SMES RCon error - Unable to reach destination. Please69erify wire connection."))
				return
	else if(M && istype(M)) // Not power69achinery, so it's a regular69achine instead. These have weak explosions.
		if(!M.use_power) // Not using power at all
			to_chat(user, SPAN_NOTICE("ERROR: No power grid connection. Unable to overload."))
			return
		if(M.inoperable()) // Not functional
			to_chat(user, SPAN_NOTICE("ERROR: Unknown error.69achine is probably damaged or power supply is nonfunctional."))
			return
	else // Not a69achine at all (what the hell is this doing in69achines list anyway??)
		to_chat(user, SPAN_NOTICE("ERROR: Unable to overload - target is not a69achine."))
		return

	explosion_intensity =69in(explosion_intensity, 12) // 3, 6, 12 explosion cap

	M.use_power(2000000) //69ajor power spike, few of these will completely burn APC's cell - e69uivalent of 2GJ of power.

	// Trigger a powernet alarm. Careful engineers will probably notice something is going on.
	var/area/temp_area = get_area(M)
	if(temp_area)
		var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
		if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
			temp_apc.terminal.powernet.trigger_warning(50) // Long alarm
		if(temp_apc)
			temp_apc.emp_act(3) // Such power surges are not good for APC electronics
			if(temp_apc.cell)
				temp_apc.cell.maxcharge -= between(0, (temp_apc.cell.maxcharge/2) + 500, temp_apc.cell.maxcharge)
				if(temp_apc.cell.maxcharge < 100) // That's it, you busted the APC cell completely. Break the APC and completely destroy the cell.
					69del(temp_apc.cell)
					temp_apc.set_broken()


	if(!ability_pay(user,price))
		return

	M.visible_message(SPAN_NOTICE("BZZZZZZZT"))
	spawn(50)
		explosion(get_turf(M), round(explosion_intensity/4),round(explosion_intensity/2),round(explosion_intensity),round(explosion_intensity * 2))
		if(M)
			69del(M)

// END ABILITY69ERBS
