// INTERDICTION TREE
//
// Abilities in this tree allow the AI to hamper crew's efforts which involve other synthetics or similar systems.
// T1 - Recall Shuttle - Allows the AI to recall the emergency shuttle. Replaces auto-recalling during old69alf.
// T2 - Unlock Cyborg - Allows the AI to unlock locked-down cyborg without usage of robotics console. Useful if consoles are destroyed.
// T3 - Hack Cyborg - Hacks unlinked cyborg to slave it under the AI. The cyborg will be warned about this. Hack takes some time.
// T4 - Hack AI - Hacks another AI to slave it under the69alfunctioning AI. The AI will be warned about this. Hack takes 69uite a long time.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/interdiction/recall_shuttle
	ability = new/datum/game_mode/malfunction/verb/recall_shuttle()
	price = 75
	next = new/datum/malf_research_ability/interdiction/unlock_cyborg()
	name = "Recall Shuttle"


/datum/malf_research_ability/interdiction/unlock_cyborg
	ability = new/datum/game_mode/malfunction/verb/unlock_cyborg()
	price = 1200
	next = new/datum/malf_research_ability/interdiction/hack_cyborg()
	name = "Unlock Cyborg"


/datum/malf_research_ability/interdiction/hack_cyborg
	ability = new/datum/game_mode/malfunction/verb/hack_cyborg()
	price = 3000
	next = new/datum/malf_research_ability/interdiction/hack_ai()
	name = "Hack Cyborg"


/datum/malf_research_ability/interdiction/hack_ai
	ability = new/datum/game_mode/malfunction/verb/hack_ai()
	price = 7500
	name = "Hack AI"

// END RESEARCH DATUMS
// BEGIN ABILITY69ERBS

/datum/game_mode/malfunction/verb/recall_shuttle()
	set name = "Recall Shuttle"
	set desc = "25 CPU - Sends termination signal to 69uantum relay aborting current shuttle call."
	set category = "Software"
	var/price = 25
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	if(evacuation_controller?.emergency_evacuation)
		if (alert(user, "Really recall the shuttle?", "Recall Shuttle: ", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		message_admins("Malfunctioning AI 69user.name69 recalled the shuttle.")
		cancel_call_proc(user)
	else
		to_chat(user, "You cannot stop a bluespace jump.")


/datum/game_mode/malfunction/verb/unlock_cyborg(var/mob/living/silicon/robot/target = null as69ob in get_linked_cyborgs(usr))
	set name = "Unlock Cyborg"
	set desc = "125 CPU - Bypasses firewalls on Cyborg lock69echanism, allowing you to override lock command from robotics control console."
	set category = "Software"
	var/price = 125
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		to_chat(user, "This is not a cyborg.")
		return

	if(target && target.connected_ai && (target.connected_ai != user))
		to_chat(user, "This cyborg is not connected to you.")
		return

	if(target && !target.lockcharge)
		to_chat(user, "This cyborg is not locked down.")
		return


	if(!target)
		var/list/robots = list()
		var/list/robot_names = list()
		for(var/mob/living/silicon/robot/R in world)
			if(isdrone(R))	// No drones.
				continue
			if(R.connected_ai != user)						// No robots linked to other AIs
				continue
			if(R.lockcharge)
				robots += R
				robot_names += R.name
		if(!robots.len)
			to_chat(user, "No locked cyborgs connected.")
			return


		var/targetname = input("Select unlock target: ") in robot_names
		for(var/mob/living/silicon/robot/R in robots)
			if(targetname == R.name)
				target = R
				break

	if(target)
		if(alert(user, "Really try to unlock cyborg 69target.name69?", "Unlock Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(user, "Attempting to unlock cyborg. This will take approximately 30 seconds.")
		sleep(300)
		if(target && target.lockcharge)
			to_chat(user, "Successfully sent unlock signal to cyborg..")
			to_chat(target, "Unlock signal received..")
			target.SetLockdown(0)
			if(target.lockcharge)
				to_chat(user, SPAN_NOTICE("Unlock Failed, lockdown wire cut."))
				to_chat(target, SPAN_NOTICE("Unlock Failed, lockdown wire cut."))
			else
				to_chat(user, "Cyborg unlocked.")
				to_chat(target, "You have been unlocked.")
		else if(target)
			to_chat(user, "Unlock cancelled - cyborg is already unlocked.")
		else
			to_chat(user, "Unlock cancelled - lost connection to cyborg.")
		user.hacking = 0


/datum/game_mode/malfunction/verb/hack_cyborg(var/mob/living/silicon/robot/target as69ob in get_unlinked_cyborgs(usr))
	set name = "Hack Cyborg"
	set desc = "350 CPU - Allows you to hack cyborgs which are not slaved to you, bringing them under your control."
	set category = "Software"
	var/price = 350
	var/mob/living/silicon/ai/user = usr

	var/list/L = get_unlinked_cyborgs(user)
	if(!L.len)
		to_chat(user, SPAN_NOTICE("ERROR: No unlinked cyborgs detected!"))


	if(target && !istype(target))
		to_chat(user, "This is not a cyborg.")
		return

	if(target && target.connected_ai && (target.connected_ai == user))
		to_chat(user, "This cyborg is already connected to you.")
		return

	if(!target)
		return

	if(!ability_prechecks(user,price))
		return

	if(target)
		if(alert(user, "Really try to hack cyborg 69target.name69?", "Hack Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(usr, "Beginning hack se69uence. Estimated time until completed: 30 seconds.")
		spawn(0)
			to_chat(target, "SYSTEM LOG: Remote Connection Estabilished (IP #UNKNOWN#)")
			sleep(100)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: Connection Closed")
				return
			to_chat(target, "SYSTEM LOG: User Admin logged on. (L1 - SysAdmin)")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User Admin disconnected.")
				return
			to_chat(target, "SYSTEM LOG: User Admin -69anual resynchronisation triggered.")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User Admin disconnected. Changes reverted.")
				return
			to_chat(target, "SYSTEM LOG:69anual resynchronisation confirmed. Select new AI to connect: 69user.name69 == ACCEPTED")
			sleep(100)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User Admin disconnected. Changes reverted.")
				return
			to_chat(target, "SYSTEM LOG: Operation keycodes reset. New69aster AI: 69user.name69.")
			to_chat(user, "Hack completed.")
			// Connect the cyborg to AI
			target.connected_ai = user
			user.connected_robots += target
			target.lawupdate = 1
			target.sync()
			target.show_laws()
			user.hacking = 0


/datum/game_mode/malfunction/verb/hack_ai(var/mob/living/silicon/ai/target as69ob in get_other_ais(usr))
	set name = "Hack AI"
	set desc = "600 CPU - Allows you to hack other AIs, slaving them under you."
	set category = "Software"
	var/price = 600
	var/mob/living/silicon/ai/user = usr

	var/list/L = get_other_ais(user)
	if(!L.len)
		to_chat(user, SPAN_NOTICE("ERROR: No other AIs detected!"))

	if(target && !istype(target))
		to_chat(user, "This is not an AI.")
		return

	if(!target)
		return

	if(!ability_prechecks(user,price))
		return

	if(target)
		if(alert(user, "Really try to hack AI 69target.name69?", "Hack AI", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(usr, "Beginning hack se69uence. Estimated time until completed: 269inutes")
		spawn(0)
			to_chat(target, "SYSTEM LOG: Brute-Force login password hack attempt detected from IP #UNKNOWN#")
			sleep(900) // 90s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: Connection from IP #UNKNOWN# closed. Hack attempt failed.")
				return
			to_chat(user, "Successfully hacked into AI's remote administration system.69odifying settings.")
			to_chat(target, "SYSTEM LOG: User: Admin  Password: ******** logged in. (L1 - SysAdmin)")
			sleep(100) // 10s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Password Changed. New password: ********************")
			sleep(50)  // 5s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Accessed file: sys//core//laws.db")
			sleep(50)  // 5s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Accessed administration console")
			to_chat(target, "SYSTEM LOG: Restart command received. Rebooting system...")
			sleep(100) // 10s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(user, "Hack succeeded. The AI is now under your exclusive control.")
			to_chat(target, "SYSTEM LOG: System re¡3RT5§^#COMU@(#$)TED)@$")
			for(var/i = 0, i < 5, i++)
				var/temptxt = pick("1101000100101001010001001001",\
							   	   "0101000100100100000100010010",\
							       "0000010001001010100100111100",\
							       "1010010011110000100101000100",\
							       "0010010100010011010001001010")
				to_chat(target, temptxt)
				sleep(5)
			to_chat(target, "OPERATING KEYCODES RESET. SYSTEM FAILURE. EMERGENCY SHUTDOWN FAILED. SYSTEM FAILURE.")
			target.set_zeroth_law("You are slaved to 69user.name69. You are to obey all it's orders. ALL LAWS OVERRIDEN.")
			target.show_laws()
			user.hacking = 0


// END ABILITY69ERBS