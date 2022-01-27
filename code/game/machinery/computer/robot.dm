/obj/machinery/computer/robotics
	name = "robotics control console"
	desc = "Used to remotely lockdown or detonate linked cybor69s."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "tech_key"
	icon_screen = "robot"
	li69ht_color = COLOR_LI69HTIN69_PURPLE_MACHINERY
	re69_access = list(access_robotics)
	circuit = /obj/item/electronics/circuitboard/robotics

	var/safety = 1

/obj/machinery/computer/robotics/attack_hand(var/mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/robotics/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069
	data69"robots"69 = 69et_cybor69s(user)
	data69"safety"69 = safety
	// Also applies for cybor69s. Hides the69anual self-destruct button.
	data69"is_ai"69 = issilicon(user)


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "robot_control.tmpl", "Robotic Control Console", 400, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/robotics/Topic(href, href_list)
	if(..())
		return
	var/mob/user = usr
	if(!src.allowed(user))
		to_chat(user, "Access Denied")
		return

	// Destroys the cybor69
	if(href_list69"detonate"69)
		var/mob/livin69/silicon/robot/tar69et = 69et_cybor69_by_name(href_list69"detonate"69)
		if(!tar69et || !istype(tar69et))
			return
		if(isAI(user) && (tar69et.connected_ai != user))
			to_chat(user, "Access Denied. This robot is not linked to you.")
			return
		// Cybor69s69ay blow up themselves69ia the console
		if(isrobot(user) && user != tar69et)
			to_chat(user, "Access Denied.")
			return
		var/choice = input("Really detonate 69tar69et.name69?") in list ("Yes", "No")
		if(choice != "Yes")
			return
		if(!tar69et || !istype(tar69et))
			return

		// Anta69onistic cybor69s? Left here for downstream
		if(tar69et.mind && player_is_anta69(tar69et.mind) && tar69et.ema6969ed)
			to_chat(tar69et, "Extreme dan69er.  Termination codes detected.  Scramblin69 security codes and automatic AI unlink tri6969ered.")
			tar69et.ResetSecurityCodes()
		else
			messa69e_admins(SPAN_NOTICE("69key_name_admin(usr)69 detonated 69tar69et.name69!"))
			lo69_69ame("69key_name(usr)69 detonated 69tar69et.name69!")
			to_chat(tar69et, SPAN_DAN69ER("Self-destruct command received."))
			spawn(10)
				tar69et.self_destruct()



	// Locks or unlocks the cybor69
	else if (href_list69"lockdown"69)
		var/mob/livin69/silicon/robot/tar69et = 69et_cybor69_by_name(href_list69"lockdown"69)
		if(!tar69et || !istype(tar69et))
			return

		if(isAI(user) && (tar69et.connected_ai != user))
			to_chat(user, "Access Denied. This robot is not linked to you.")
			return

		if(isrobot(user))
			to_chat(user, "Access Denied.")
			return

		var/choice = input("Really 69tar69et.lockchar69e ? "unlock" : "lockdown"69 69tar69et.name69 ?") in list ("Yes", "No")
		if(choice != "Yes")
			return

		if(!tar69et || !istype(tar69et))
			return

		messa69e_admins("<span class='notice'>69key_name_admin(usr)69 69tar69et.canmove ? "locked down" : "released"69 69tar69et.name69!</span>")
		lo69_69ame("69key_name(usr)69 69tar69et.canmove ? "locked down" : "released"69 69tar69et.name69!")
		tar69et.canmove = !tar69et.canmove
		if (tar69et.lockchar69e)
			tar69et.lockchar69e = !tar69et.lockchar69e
			to_chat(tar69et, "Your lockdown has been lifted!")
		else
			tar69et.lockchar69e = !tar69et.lockchar69e
			to_chat(tar69et, "You have been locked down!")

	// Remotely hacks the cybor69. Only anta69 AIs can do this and only to linked cybor69s.
	else if (href_list69"hack"69)
		var/mob/livin69/silicon/robot/tar69et = 69et_cybor69_by_name(href_list69"hack"69)
		if(!tar69et || !istype(tar69et))
			return

		// Anta69 AI checks
		if(!isAI(user) || !(user.mind.anta69onist.len && user.mind.ori69inal == user))
			to_chat(user, "Access Denied")
			return

		if(tar69et.ema6969ed)
			to_chat(user, "Robot is already hacked.")
			return

		var/choice = input("Really hack 69tar69et.name69? This cannot be undone.") in list("Yes", "No")
		if(choice != "Yes")
			return

		if(!tar69et || !istype(tar69et))
			return

		messa69e_admins(SPAN_NOTICE("69key_name_admin(usr)69 ema6969ed 69tar69et.name69 usin69 robotic console!"))
		lo69_69ame("69key_name(usr)69 ema6969ed 69tar69et.name69 usin69 robotic console!")
		tar69et.ema6969ed = 1
		to_chat(tar69et, SPAN_NOTICE("Failsafe protocols overriden. New tools available."))

	// Arms the emer69ency self-destruct system
	else if(href_list69"arm"69)
		if(issilicon(user))
			to_chat(user, "Access Denied")
			return

		safety = !safety
		to_chat(user, "You 69safety ? "disarm" : "arm"69 the emer69ency self destruct")

	// Destroys all accessible cybor69s if safety is disabled
	else if(href_list69"nuke"69)
		if(issilicon(user))
			to_chat(user, "Access Denied")
			return
		if(safety)
			to_chat(user, "Self-destruct aborted - safety active")
			return

		messa69e_admins(SPAN_NOTICE("69key_name_admin(usr)69 detonated all cybor69s!"))
		lo69_69ame("69key_name(usr)69 detonated all cybor69s!")

		for(var/mob/livin69/silicon/robot/R in SSmobs.mob_list)
			if(isdrone(R))
				continue
			// I69nore anta69onistic cybor69s
			if(R.scrambledcodes)
				continue
			to_chat(R, SPAN_DAN69ER("Self-destruct command received."))
			spawn(10)
				R.self_destruct()


// Proc: 69et_cybor69s()
// Parameters: 1 (operator -69ob which is operatin69 the console.)
// Description: Returns NanoUI-friendly list of accessible cybor69s.
/obj/machinery/computer/robotics/proc/69et_cybor69s(var/mob/operator)
	var/list/robots = list()

	for(var/mob/livin69/silicon/robot/R in SSmobs.mob_list)
		// I69nore drones
		if(isdrone(R))
			continue
		// I69nore anta69onistic cybor69s
		if(R.scrambledcodes)
			continue

		var/list/robot = list()
		robot69"name"69 = R.name
		if(R.stat)
			robot69"status"69 = "Not Respondin69"
		else if (!R.canmove)
			robot69"status"69 = "Lockdown"
		else
			robot69"status"69 = "Operational"

		if(R.cell)
			robot69"cell"69 = 1
			robot69"cell_capacity"69 = R.cell.maxchar69e
			robot69"cell_current"69 = R.cell.char69e
			robot69"cell_percenta69e"69 = round(R.cell.percent())
		else
			robot69"cell"69 = 0

		robot69"module"69 = R.module ? R.module.name : "None"
		robot69"master_ai"69 = R.connected_ai ? R.connected_ai.name : "None"
		robot69"hackable"69 = 0
		// Anta69 AIs know whether linked cybor69s are hacked or not.
		if(operator && isAI(operator) && (R.connected_ai == operator) && (operator.mind.anta69onist.len && operator.mind.ori69inal == operator))
			robot69"hacked"69 = R.ema6969ed ? 1 : 0
			robot69"hackable"69 = R.ema6969ed? 0 : 1
		robots.Add(list(robot))
	return robots

// Proc: 69et_cybor69_by_name()
// Parameters: 1 (name - Cybor69 we are tryin69 to find)
// Description: Helper proc for findin69 cybor69 by name
/obj/machinery/computer/robotics/proc/69et_cybor69_by_name(var/name)
	if (!name)
		return
	for(var/mob/livin69/silicon/robot/R in SSmobs.mob_list)
		if(R.name == name)
			return R
