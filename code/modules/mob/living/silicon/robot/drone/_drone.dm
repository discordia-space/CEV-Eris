var/list/mob_hat_cache = list()
/proc/get_hat_icon(var/obj/item/hat,69ar/offset_x = 0,69ar/offset_y = 0)
	var/t_state = hat.icon_state
	if(hat.item_state_slots && hat.item_state_slots69slot_head_str69)
		t_state = hat.item_state_slots69slot_head_str69
	else if(hat.item_state)
		t_state = hat.item_state
	var/key = "69t_state69_69offset_x69_69offset_y69"
	if(!mob_hat_cache69key69)            //69ot ideal as there's69o guarantee all hat icon_states
		var/t_icon = INV_HEAD_DEF_ICON // are unique across69ultiple dmis, but whatever.
		if(hat.icon_override)
			t_icon = hat.icon_override
		else if(hat.item_icons && (slot_head_str in hat.item_icons))
			t_icon = hat.item_icons69slot_head_str69
		var/image/I = image(icon = t_icon, icon_state = t_state)
		I.pixel_x = offset_x
		I.pixel_y = offset_y
		mob_hat_cache69key69 = I
	return69ob_hat_cache69key69

/mob/living/silicon/robot/drone
	name = "drone"
	real_name = "drone"
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	maxHealth = 35
	health = 35
	cell_emp_mult = 1
	universal_speak = 0
	universal_understand = 1
	gender =69EUTER
	pass_flags = PASSTABLE
	braintype = "Robot"
	lawupdate = 0
	density = FALSE
	req_access = list(access_engine, access_robotics)
	integrated_light_power = 3
	local_transmit = 1
	possession_candidate = 1
	speed = -0.25

	can_pull_size = ITEM_SIZE_NORMAL
	can_pull_mobs =69OB_PULL_SMALLER

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	//If you update this69ob size, remember to update the fall damage too
	mob_size =69OB_MEDIUM // Small69obs can't open doors, it's a huge pain for drones.

	//Used for self-mailing.
	var/mail_destination = ""
	var/obj/machinery/drone_fabricator/master_fabricator
	var/law_type = /datum/ai_laws/drone
	var/module_type = /obj/item/robot_module/drone
	var/obj/item/hat
	var/hat_x_offset = 0
	var/hat_y_offset = -13
	var/eyecolor = "blue"
	var/armguard = ""
	var/communication_channel = LANGUAGE_DRONE
	var/station_drone = TRUE

	holder_type = /obj/item/holder/drone

/mob/living/silicon/robot/drone/can_be_possessed_by(var/mob/observer/ghost/possessor)
	if(!istype(possessor) || !possessor.client || !possessor.ckey)
		return 0
	if(!config.allow_drone_spawn)
		to_chat(src, SPAN_DANGER("Playing as drones is69ot currently permitted."))
		return 0
	if(too_many_active_drones())
		to_chat(src, SPAN_DANGER("The69aximum69umber of active drones has been reached.."))
		return 0
	if(jobban_isbanned(possessor,"Robot"))
		to_chat(usr, SPAN_DANGER("You are banned from playing synthetics and cannot spawn as a drone."))
		return 0
	if(!possessor.MayRespawn(0,MINISYNTH))
		return 0
	return 1

/mob/living/silicon/robot/drone/do_possession(var/mob/observer/ghost/possessor)
	if(!(istype(possessor) && possessor.ckey))
		return 0
	if(src.ckey || src.client)
		to_chat(possessor, SPAN_WARNING("\The 69src69 already has a player."))
		return 0
	message_admins("<span class='adminnotice'>69key_name_admin(possessor)69 has taken control of \the 69src69.</span>")
	log_admin("69key_name(possessor)69 took control of \the 69src69.")
	transfer_personality(possessor.client)
	qdel(possessor)
	return 1

/mob/living/silicon/robot/drone/Destroy()
	if(hat)
		hat.loc = get_turf(src)
	GLOB.drones.Remove(src)
	. = ..()

/mob/living/silicon/robot/drone/New()

	..()

	//Stats69ust be initialised before creating the69odule
	if(!module)69odule =69ew69odule_type(src)

	verbs += /mob/living/proc/hide
	remove_language(LANGUAGE_ROBOT)
	add_language(LANGUAGE_ROBOT, 0)
	add_language(LANGUAGE_DRONE, 1)

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	//69O BRAIN.
	mmi =69ull

	//We69eed to screw with their HP a bit. They have around one fifth as69uch HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components69V69
		C.max_damage = 10

	verbs -= /mob/living/silicon/robot/verb/Namepick
	//choose_overlay()
	updateicon()

	if(station_drone)
		GLOB.drones |= src

/mob/living/silicon/robot/drone/init()
	aiCamera =69ew/obj/item/device/camera/siliconcam/drone_camera(src)
	additional_law_channels69"Drone"69 = "d"
	if(!laws) laws =69ew law_type

	flavor_text = "A tiny little repair drone. The casing is stamped with an corporate logo and the subscript: '69company_name69 Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/SetName(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so..
	real_name = pickedName
	name = real_name

/mob/living/silicon/robot/drone/updatename()
	real_name = "maintenance drone (69rand(100,999)69)"
	name = real_name

/mob/living/silicon/robot/drone/updateicon()

	cut_overlays()
	if(stat == CONSCIOUS && eyecolor)
		overlays += "eyes-drone69eyecolor69"

	if(armguard)
		overlays += "model-69armguard69"

	if(hat) // Let the drones wear hats.
		overlays |= get_hat_icon(hat, hat_x_offset, hat_y_offset)

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

/mob/living/silicon/robot/drone/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat =69ew_hat
	new_hat.forceMove(src)
	updateicon()

//Drones cannot be upgraded with borg69odules so we69eed to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attackby(var/obj/item/W,69ar/mob/user)

	if(user.a_intent == I_HELP && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, SPAN_WARNING("\The 69src69 is already wearing \the 69hat69."))
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message(SPAN_NOTICE("\The 69user69 puts \the 69W69 on \the 69src69."))
		return
	else if(istype(W, /obj/item/borg/upgrade/))
		to_chat(user, SPAN_DANGER("\The 69src69 is69ot compatible with \the 69W69."))
		return

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))

		if(stat == 2)

			if(!config.allow_drone_spawn || emagged || health < -35) //It's dead, Dave.
				to_chat(user, SPAN_DANGER("The interface is fried, and a distressing burned smell wafts from the robot's interior. You're69ot rebooting this one."))
				return

			if(!allowed(usr))
				to_chat(user, SPAN_DANGER("Access denied."))
				return

			user.visible_message(SPAN_DANGER("\The 69user69 swipes \his ID card through \the 69src69, attempting to reboot it."), SPAN_DANGER(">You swipe your ID card through \the 69src69, attempting to reboot it."))
			request_player()
			return

		else
			user.visible_message(SPAN_DANGER("\The 69user69 swipes \his ID card through \the 69src69, attempting to shut it down."), SPAN_DANGER("You swipe your ID card through \the 69src69, attempting to shut it down."))

			if(emagged)
				return

			if(allowed(usr))
				shut_down()
			else
				to_chat(user, SPAN_DANGER("Access denied."))

		return

	..()

/mob/living/silicon/robot/drone/emag_act(var/remaining_charges,69ar/mob/user)
	if(!client || stat == 2)
		to_chat(user, SPAN_DANGER("There's69ot69uch point subverting this heap of junk."))
		return

	if(emagged)
		to_chat(src, SPAN_DANGER("\The 69user69 attempts to load subversive software into you, but your hacked subroutines ignore the attempt."))
		to_chat(user, SPAN_DANGER("You attempt to subvert 69src69, but the sequencer has69o effect."))
		return

	to_chat(user, SPAN_DANGER("You swipe the sequencer across 69src69's interface and watch its eyes flick_light."))
	to_chat(src, SPAN_DANGER("You feel a sudden burst of69alware loaded into your execute-as-root buffer. Your tiny brain69ethodically parses, loads and executes the script."))

	message_admins("69key_name_admin(user)69 emagged drone 69key_name_admin(src)69.  Laws overridden.")
	log_game("69key_name(user)69 emagged drone 69key_name(src)69.  Laws overridden.")
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("69time69 <B>:</B> 69user.name69(69user.key69) emagged 69name69(69key69)")

	emagged = 1
	lawupdate = 0
	connected_ai =69ull
	clear_supplied_laws()
	clear_inherent_laws()
	laws =69ew /datum/ai_laws/syndicate_override
	set_zeroth_law("Only 69user.real_name69 and people \he designates as being such are operatives.")

	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, SPAN_DANGER("ALERT: 69user.real_name69 is your69ew69aster. Obey your69ew laws and \his commands."))
	return 1

//DRONE LIFE/DEATH

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health =69axHealth
		stat = CONSCIOUS
		return
	health =69axHealth - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_status_updates()
	var/turf/T = get_turf(src)
	if((!T || health <= -maxHealth) && src.stat != DEAD)
		timeofdeath = world.time
		death() //Possibly redundant, having trouble69aking death() cooperate.
		gib()
		return
	..()

//DRONE69OVEMENT.
/mob/living/silicon/robot/drone/slip_chance(var/prob_slip)
	return 0

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()
	if(stat != 2)
		if(emagged)
			to_chat(src, SPAN_DANGER("You feel something attempting to69odify your programming, but your hacked subroutines are unaffected."))
		else
			to_chat(src, SPAN_DANGER("A reset-to-factory directive packet filters through your data connection, and you obediently69odify your programming to suit it."))
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()
	if(stat != 2)
		if(emagged)
			to_chat(src, SPAN_DANGER("You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you."))
		else
			to_chat(src, SPAN_DANGER("You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself."))
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws(1)
	clear_inherent_laws(1)
	clear_ion_laws(1)
	laws =69ew law_type

//Reboot procs.

/mob/living/silicon/robot/drone/proc/request_player()
	if(too_many_active_drones())
		return
	var/datum/ghosttrap/G = get_ghost_trap("maintenance drone")
	G.request_player(src, "Someone is attempting to reboot a69aintenance drone.",69INISYNTH, 30 SECONDS)

/mob/living/silicon/robot/drone/proc/transfer_personality(var/client/player)
	if(!player) return
	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		player.mob.mind.transfer_to(src)

	lawupdate = 0
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern69aintenance protocol... <b>loaded</b>.")
	full_law_reset()
	welcome_drone()

/mob/living/silicon/robot/drone/proc/welcome_drone()
	to_chat(src, "<b>You are a69aintenance drone, a tiny-brained robotic repair69achine</b>.")
	to_chat(src, "You have69o individual will,69o personality, and69o drives or urges other than your laws.")
	to_chat(src, "Remember,  you are <b>lawed against harming the crew</b>. Also remember, <b>you DO69OT take orders from the AI.</b>")
	to_chat(src, "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your69earby fellows.")

/mob/living/silicon/robot/drone/add_robot_verbs()
	return

/mob/living/silicon/robot/drone/remove_robot_verbs()
	return

/proc/too_many_active_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in SSmobs.mob_list)
		if(D.key && D.client)
			drones++
	return drones >= config.max_maint_drones

/mob/living/silicon/robot/drone/verb/choose_eyecolor()
	set69ame = "Choose Light Color"
	set category = "Silicon Commands"
	var/list/colors = list( "blue", "red", "orange", "green", "violet")

	eyecolor = input("Please, select a color!", "color",69ull) as69ull|anything in colors

	if(!colors)
		eyecolor = "blue"
		return

/mob/living/silicon/robot/drone/verb/choose_armguard()
	set69ame = "Choose Armguards"
	set category = "Silicon Commands"
	var/list/colors = list( "blue", "red", "brown", "orange", "green", "none")

	armguard = input("Please, select armguards!", "color",69ull) as69ull|anything in colors

	if(!colors)
		armguard = ""
		return

	verbs -= /mob/living/silicon/robot/drone/verb/choose_armguard
	to_chat(src, "Your armguard has been set.")

// AI-bound69aintenance drone
/mob/living/silicon/robot/drone/aibound

	var/mob/living/silicon/ai/bound_ai =69ull

/mob/living/silicon/robot/drone/aibound/Destroy()
	bound_ai =69ull
	. = ..()

/mob/living/silicon/robot/drone/aibound/proc/back_to_core()
	if(bound_ai &&69ind)
		mind.active = 0 // We want to transfer the key69anually
		mind.transfer_to(bound_ai) // Transfer69ind to AI core
		bound_ai.key = key //69anually transfer the key to log them in
	else
		to_chat(src, SPAN_WARNING("No AI core detected."))

/mob/living/silicon/robot/drone/aibound/death(gibbed)
	if(bound_ai)
		bound_ai.time_destroyed = world.time
		bound_ai.bound_drone =69ull
		to_chat(src, SPAN_WARNING("Your AI bound drone is destroyed."))
		back_to_core()
		bound_ai =69ull
	return ..(gibbed)

/mob/living/silicon/robot/drone/aibound/verb/get_back_to_core()
	set69ame = "Get Back To Core"
	set desc = "Release drone control and get back to your69ain AI core."
	set category = "Silicon Commands"

	back_to_core()

/mob/living/silicon/robot/drone/aibound/law_resync()
	return

/mob/living/silicon/robot/drone/aibound/shut_down()
	return

/mob/living/silicon/robot/drone/aibound/full_law_reset()
	return

/mob/living/silicon/robot/drone/aibound/SetName(pickedName as text)
	to_chat(src, SPAN_WARNING("AI bound drones cannot be renamed."))

/mob/living/silicon/robot/drone/aibound/emag_act(var/remaining_charges,69ar/mob/user)
	to_chat(user, SPAN_DANGER("This drone is remotely controlled by the ship AI and cannot be directly subverted, the sequencer has69o effect."))
	to_chat(src, SPAN_DANGER("\The 69user69 attempts to load subversive software into you, but your hacked subroutines ignore the attempt."))

/mob/living/silicon/robot/drone/aibound/emp_act(severity)
	back_to_core()

/mob/living/silicon/robot/drone/aibound/use_power()
	..()
	if(!has_power)
		to_chat(src, SPAN_WARNING("Your AI bound drone runs out of power!"))
		back_to_core()

/mob/living/silicon/robot/drone/aibound/Life()
	..()
	if(bound_ai && !isOnStationLevel(src))
		to_chat(src, SPAN_WARNING("You get out of the ship control range!"))
		death(TRUE)
