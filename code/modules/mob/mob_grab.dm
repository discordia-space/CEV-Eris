#define UPGRADE_WARMUP	5 SECONDS
#define UPGRADE_KILL_TIMER	10 SECONDS

///Process_Grab()
///Called by client/Move()
///Checks to see if you are grabbing anything and if moving will affect your grab.
/client/proc/Process_Grab()
	for(var/obj/item/grab/G in list(mob.l_hand, mob.r_hand))
		G.reset_kill_state() //no wandering across the station/asteroid while choking someone

/obj/item/grab
	name = "grab"
	icon = 'icons/mob/grab_icons.dmi'
	icon_state = "reinforce"
	flags = NOBLUDGEON
	layer = 21
	abstract = 1
	item_state = "nothing"
	volumeClass = ITEM_SIZE_COLOSSAL
	spawn_tags = null
	weight = 0
	var/obj/screen/grab/hud
	var/atom/movable/affecting
	var/atom/movable/assailant
	var/state = GRAB_PASSIVE

	var/allow_upgrade = 1
	var/last_action = 0
	var/last_hit_zone = 0
	var/force_down //determines if the affecting mob will be pinned to the ground
	var/dancing //determines if assailant and affecting keep looking at each other.
	var/destroying = FALSE

	var/counter_timer = 3 SECONDS //sets to 3 seconds after being grabbed

/obj/item/grab/Process()
	counter_timer--
	..()

/obj/proc/affect_grab(var/mob/user, var/mob/target, var/state)
	return FALSE

/obj/item/grab/resolve_attackby(atom/movable/O, mob/user, var/click_params)
	if(isobj(O))
		var/obj/target = O
		if(target.affect_grab(assailant, affecting, state))
			qdel(src)
			return
	if(!istype(O))
		return
	return ..()

/obj/item/grab/New(atom/movable/user, atom/movable/victim, force = FALSE, tryFight = FALSE)
	..()
	forceMove(user)
	assailant = user
	affecting = victim

	if(!isturf(assailant.loc) || !isturf(affecting.loc) || get_dist(assailant, affecting) > 1 || affecting == assailant)
		qdel(src)
		return
	if(ismob(victim))
		var/mob/target = victim
		if(target.incapacitated(INCAPACITATION_CANT_MOVE))
			qdel(src)
			return
	var/list/bucklers = list()
	SEND_SIGNAL(affecting, COMSIG_BUCKLE_QUERY, bucklers)
	if(length(bucklers))
		to_chat(user, SPAN_NOTICE("\The [victim] is buckled to something, unbuckle them first!"))
		qdel(src)
		return
	if(affecting.grabbedBy)
		// Grab killing code
		if(affecting.grabbedBy.assailant == user)
			QDEL_NULL(affecting.grabbedBy)
			qdel(src)
			return
		if(force)
			QDEL_NULL(affecting.grabbedBy)
		else if(tryFight)
			var/mob/living/carbon/human/fighter = user
			if(!istype(fighter))
				qdel(src)
				return
			if(fighter.energy > 20)
				fighter.adjustEnergy(-20)
				fighter.visible_message(SPAN_DANGER("\The [fighter] wrestles control of [affecting]!"), SPAN_NOTICE("You wrestle control of [affecting]!"))
				QDEL_NULL(affecting.grabbedBy)
			else
				to_chat(fighter, SPAN_NOTICE("You are too tired to wrestle away control on \the [affecting]!"))
				qdel(src)
				return

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(onGrabberMove))
	if(ismob(user))
		RegisterSignal(user, COMSIG_CLICK, PROC_REF(onGrabberClick))
	RegisterSignal(victim, COMSIG_MOVABLE_MOVED, PROC_REF(onVictimMove))

	affecting.grabbedBy = src
	// stop people space drifting if you  aren't drifting yourself.
	if(SSthrowing.throwing_queue[affecting] && !SSthrowing.throwing_queue[assailant])
		SSthrowing.throwing_queue.Remove(affecting)
		SSthrowing.current_throwing_queue.Remove(affecting)
	hud = new /obj/screen/grab(src)
	hud.icon_state = "reinforce"
	icon_state = "grabbed"
	hud.name = "reinforce grab"
	hud.master = src
	affecting.atomFlags &= AF_LAYER_UPDATE_HANDLED

	if(assailant.grabbedBy)
		var/obj/item/grab/grippy = assailant.grabbedBy
		if(grippy.assailant == affecting && grippy.affecting == assailant)
			grippy.dancing = TRUE
			src.dancing = TRUE

	update_slowdown_hold()

/obj/item/grab/proc/onGrabberClick(atom/movable/grabber, atom/clicked)
	SIGNAL_HANDLER
	if(!isturf(clicked))
		return
	if(affecting.anchored)
		qdel(src)
		return
	if(clicked.Adjacent(grabber))
		var/turf/theWay = get_step_towards(affecting, clicked)
		affecting.Move(theWay, initiator = src)

/obj/item/grab/proc/onGrabberMove(atom/movable/mover, atom/oldLocation , atom/newLocation, atom/initiator)
	SIGNAL_HANDLER
	// FUCK NO - SPCR 2023
	message_admins("Initiator for grabber , [initiator]")
	if(initiator == assailant.grabbedBy)
		return
	// No moving when walking over / pinning down , etc/
	if(newLocation.Adjacent(affecting) && state <= GRAB_AGGRESSIVE)
		return
	var/moveDirection = get_dir(oldLocation,newLocation)
	affecting.dir = moveDirection
	if(ismob(affecting))
		affecting.layer = initial(affecting.layer)
		var/mob/victim = affecting
		if(victim.incapacitated(INCAPACITATION_CANT_MOVE) || (!(affecting.Adjacent(oldLocation)) && oldLocation.z == newLocation.z))
			qdel(src)
			return
		if(victim.lying || victim.resting || moveDirection == NORTH)
			affecting.layer = BELOW_MOB_LAYER
		var/grabHugMultiplier = 1
		if(oldLocation.z == newLocation.z)
			switch(state)
				if(GRAB_PASSIVE)
					affecting.Move(oldLocation, initiator = src)
					if(dancing)
						assailant.set_dir(get_dir(assailant,affecting))
					grabHugMultiplier = 0.5
				if(GRAB_AGGRESSIVE)
					affecting.Move(oldLocation, initiator = src)
					grabHugMultiplier = 1
				if(GRAB_NECK,GRAB_UPGRADING)
					affecting.set_dir(assailant.dir)
					affecting.Move(newLocation, initiator = src)
					grabHugMultiplier = 0
				if(GRAB_KILL)
					affecting.Move(newLocation, initiator = src)
					grabHugMultiplier = 0
			switch(moveDirection)
				if(NORTH)
					animate(affecting, 0.2 SECONDS, pixel_x = 0)
					animate(affecting, 0.2 SECONDS, pixel_y = 8 * grabHugMultiplier)
				if(EAST)
					animate(affecting, 0.2 SECONDS, pixel_x = 8 * grabHugMultiplier)
					animate(affecting, 0.2 SECONDS, pixel_y = 0)
				if(SOUTH)
					animate(affecting, 0.2 SECONDS, pixel_x = 0)
					animate(affecting, 0.2 SECONDS, pixel_y = -8 * grabHugMultiplier)
				if(WEST)
					animate(affecting, 0.2 SECONDS, pixel_x = -8 * grabHugMultiplier)
					animate(affecting, 0.2 SECONDS, pixel_y = 0)
		else
			var/turf/newBelow = GetBelow(newLocation)
			var/turf/newAbove = GetAbove(newLocation)
			if(newBelow && newBelow.Adjacent(oldLocation) || (newAbove &&newAbove.Adjacent(oldLocation)))
				victim.forceMove(newLocation, initiator = src)
			else
				qdel(src)
				return
	else
		if(affecting.anchored)
			qdel(src)
			return
		if(oldLocation.z == newLocation.z && oldLocation.Adjacent(newLocation))
			affecting.layer = initial(affecting.layer)
			if(get_dir(oldLocation,newLocation) == NORTH)
				affecting.layer = BELOW_MOB_LAYER
			affecting.Move(oldLocation, initiator = src)
		else if(isturf(oldLocation) && isturf(newLocation))
			var/turf/newBelow = GetBelow(newLocation)
			var/turf/newAbove = GetAbove(newLocation)
			if(newBelow && newBelow.Adjacent(oldLocation) || (newAbove &&newAbove.Adjacent(oldLocation)))
				affecting.forceMove(newLocation, initiator = src)
			else
				qdel(src)
				return
		else
			qdel(src)
			return

/obj/item/grab/proc/onVictimMove(atom/movable/mover, atom/oldLocation, atom/newLocation, atom/initiator)
	SIGNAL_HANDLER
	message_admins("initiator=[initiator]")
	if(initiator != src)
		qdel(src)
		return

//Used by throw code to hand over the mob, instead of throwing the grab.
// The grab is then deleted by the throw code.
/obj/item/grab/proc/throw_held()
	/// TODO : Add support for throwing big objects like canisters & machinery (because fuck yeah that would be awesome...) SPCR 2023
	if(!ismob(affecting))
		return null
	else
		var/mob/victim = affecting
		if(victim.incapacitated(INCAPACITATION_CANT_MOVE) || state < GRAB_AGGRESSIVE)
			return null
		animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1)
		return affecting


//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/grab/proc/synch()
	if(affecting)
		hud.screen_loc = src.screen_loc
//		if(assailant.r_hand == src)
//			hud.screen_loc = src.screen_loc
//		else
//			hud.screen_loc = src.screen_loc

/obj/item/grab/Process()
	if(QDELETED(src))
		return PROCESS_KILL
	if(ismob(assailant))
		var/mob/grabber = assailant
		if(grabber.client)
			grabber.client.screen -= hud
			grabber.client.screen += hud
		if(ismob(affecting))
			var/mob/living/carbon/human/target = affecting
			if(state <= GRAB_AGGRESSIVE)
				allow_upgrade = TRUE
				//disallow upgrading if we're grabbing more than one person
				if((grabber.l_hand && grabber.l_hand != src && istype(grabber.l_hand, /obj/item/grab)))
					var/obj/item/grab/G = grabber.l_hand
					if(G.affecting != target)
						allow_upgrade = FALSE
				if((grabber.r_hand && grabber.r_hand != src && istype(grabber.r_hand, /obj/item/grab)))
					var/obj/item/grab/G = grabber.r_hand
					if(G.affecting != target)
						allow_upgrade = FALSE

				//disallow upgrading past aggressive if we're being grabbed aggressively
				for(var/obj/item/grab/G in target.grabbedBy)
					if(G == src) continue
					if(G.state >= GRAB_AGGRESSIVE)
						allow_upgrade = TRUE

				if(allow_upgrade)
					if(state < GRAB_AGGRESSIVE)
						if(state == GRAB_PASSIVE)
							hud.icon_state = "reinforce"
					else
						hud.icon_state = "reinforce_final"
				else
					hud.icon_state = "!reinforce"

			if(state >= GRAB_AGGRESSIVE)
				target.drop_l_hand()
				target.drop_r_hand()

				if(iscarbon(target))
					handle_eye_mouth_covering(target, grabber, grabber.targeted_organ)

				if(force_down)
					if(target.loc != grabber.loc)
						force_down = 0
					else
						target.Weaken(2)

			if(state >= GRAB_NECK)
				target.Stun(3)
				if(isliving(target))
					var/mob/living/L = target
					L.adjustOxyLoss(1)

			if(state >= GRAB_KILL)
				if(iscarbon(target))
					var/mob/living/carbon/C = target
					C.apply_effect(STUTTER, 5) //It will hamper your voice, being choked and all.
					C.Weaken(5)	//Should keep you down unless you get help.
					C.losebreath = max(C.losebreath + 2, 3)

	update_slowdown_hold()

/obj/item/grab/proc/handle_eye_mouth_covering(mob/living/carbon/target, mob/user, var/target_zone)
	//only display messages when switching between different target zones
	var/announce = (target_zone != last_hit_zone)
	last_hit_zone = target_zone
	switch(target_zone)
		if(BP_MOUTH)
			if(announce)
				user.visible_message(SPAN_WARNING("\The [user] covers [target]'s mouth!"))
			if(target.silent < 3)
				target.silent = 3
		if(BP_EYES)
			if(announce)
				assailant.visible_message(SPAN_WARNING("[assailant] covers [affecting]'s eyes!"))
			if(target.eye_blind < 3)
				target.eye_blind = 3

/obj/item/grab/attack_self()
	return s_click(hud)

/obj/item/grab/proc/upgrade_grab(delay_time, hud_icon_state_after, state_after)
	if(!allow_upgrade)
		return // upgrading now is not allowed!
	delay_time = round(delay_time / 8) // the sprites have eight configurations for timer
	var/original_icon = hud.icon_state
	var/original_loc = get_turf(assailant) // used to see if the assailant moved and thus disrupted the upgrade
	var/original_time = world.time
	for(var/counter in 1 to 8)
		sleep(delay_time)
		if(QDELING(src) || !hud)
			break // hud is null after dropped and sleep does not care so we check manually
		if(last_action > original_time || get_turf(assailant) != original_loc) // cannot do a grab attack while upgrading a grab
			hud.icon_state = original_icon //  or move and upgrade a grab or keep upgrading it when the grab is escaped.
			break
		else
			hud.icon_state = "[original_icon][counter]"
			if(counter == 8)
				hud.icon_state = hud_icon_state_after
				state = state_after
				return TRUE
	if(ismob(assailant))
		to_chat(assailant, SPAN_WARNING("You failed to upgrade your grab."))

/obj/item/grab/proc/s_click(obj/screen/S)
	if(state == GRAB_UPGRADING || state == GRAB_PRENECK)
		return
	///no behavior for atoms
	if(ismob(assailant) && ismob(affecting))
		var/mob/living/carbon/human/grabber = assailant
		var/mob/living/carbon/human/target = affecting
		if(!grabber.can_click())
			return
		if(grabber.incapacitated(INCAPACITATION_GROUNDED))
			qdel(src)
			return
		// Adjust the grab warmup using grabber's ROB stat
		var/grabber_stat = grabber?.stats.getStat(STAT_ROB) + 0.0001 /// avoid powers of 0
		var/target_stat = target?.stats.getStat(STAT_ROB) + 0.0001
		var/warmup_increase
		if(grabber_stat > 0)
			// Positive ROB decreases warmup, but not linearly
			warmup_increase = -(grabber_stat ** 0.8)
		else
			// Negative ROB is a flat warmup increase
			warmup_increase = abs(grabber_stat)
		if(target_stat > 0)
			warmup_increase += target_stat ** 0.8
		else
			warmup_increase -= abs(target_stat) ** 0.6
		// No lower than 2 seconds
		var/total_warmup = max(2 SECOND, UPGRADE_WARMUP + round(warmup_increase))

		if(state < GRAB_AGGRESSIVE)
			if(!allow_upgrade)
				return
			icon_state = "grabbed1"
			hud.icon_state = "reinforce_final"
			state = GRAB_AGGRESSIVE
			if(!target.lying)
				grabber.visible_message(SPAN_WARNING("[grabber] has grabbed [target] aggressively!"))
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been grabbed by [grabber.name] ([grabber.ckey])</font>"
				grabber.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed [target.name] ([target.ckey])</font>"
				msg_admin_attack("[grabber] grabbed a [target].")
			else
				grabber.visible_message(SPAN_WARNING("[grabber] pins [target] down to the ground!"))
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been pinned by [grabber.name] ([grabber.ckey])</font>"
				grabber.attack_log += "\[[time_stamp()]\] <font color='red'>Pinned [target.name] ([target.ckey])</font>"
				msg_admin_attack("[grabber] pinned down [target].")
				apply_pinning(target, grabber)


		else if(state < GRAB_NECK)
			if(isslime(target))
				to_chat(grabber, SPAN_NOTICE("You squeeze [target], but nothing interesting happens."))
				return
			grabber.visible_message(SPAN_WARNING("[grabber] starts grabbing [target] by the neck!"))
			state = GRAB_PRENECK
			hud.icon_state = "reinforce"
			if(upgrade_grab(total_warmup*2, "kill", GRAB_NECK))
				grabber.visible_message(SPAN_WARNING("[grabber] grabs [target] by the neck!"))
				icon_state = "grabbed+1"
				grabber.set_dir(get_dir(grabber, target))
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [grabber.name] ([grabber.ckey])</font>"
				grabber.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed the neck of [target.name] ([target.ckey])</font>"
				msg_admin_attack("[key_name(grabber)] grabbed the neck of [key_name(target)]")
				hud.icon_state = "kill"
				hud.name = "choke"
			else if(!QDELETED(src))
				state = GRAB_AGGRESSIVE
				if(hud)
					hud.icon_state = "reinforce_final"

		else if(state < GRAB_UPGRADING)
			grabber.visible_message(SPAN_DANGER("[grabber] starts to tighten \his grip on [target]'s neck!"))
			hud.icon_state = "kill"
			hud.name = "Kill"
			state = GRAB_UPGRADING
			if(upgrade_grab(total_warmup, "kill_final", GRAB_KILL))
				grabber.visible_message(SPAN_DANGER("[grabber] has tightened \his grip on [target]'s neck!"))
				target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been strangled (kill intent) by [grabber.name] ([grabber.ckey])</font>"
				grabber.attack_log += "\[[time_stamp()]\] <font color='red'>Strangled (kill intent) [target.name] ([target.ckey])</font>"
				msg_admin_attack("[key_name(grabber)] strangled (kill intent) [key_name(target)]")

				target.set_dir(WEST)
				if(iscarbon(target))
					var/mob/living/carbon/C = target
					C.losebreath += 1
			else
				state = GRAB_NECK
	update_slowdown_hold()

// Function to compute the current slowdown_hold and is more adjustable and uses number as starting value
// The code will adjust or lower the slowdown_hold depending on STAT_ROB skill, gravity, etc.
/obj/item/grab/proc/update_slowdown_hold()
	// The movment speed of grabber will be determined by the victim whatever their size or things he wears minus how strong the assailant ( ROB )
	// New function should take the victim variables in account : size of mob, under gravity or not
	// ROB check will start in process for the victim so the assailant can have a jump on the victim in first movement tick or some shit unless he's already grabbed
	if(isnull(affecting))
		return //do not upgrade a grab and drop it
	if(ismob(assailant))
		if(ismob(affecting))
			var/mob/living/carbon/human/grabber = assailant
			var/mob/living/carbon/human/target = affecting
			var/affecting_stat = target.stats.getStat(STAT_ROB)	// Victim
			var/assailant_stat = grabber.stats.getStat(STAT_ROB)	// Grabber
			var/difference_stat = assailant_stat - affecting_stat

			// Early exit to save processing time
			if(!(target.check_gravity() && grabber.check_gravity()))
				slowdown_hold = 0
				return	// Nothing to do here

			// initial value for slowdown_hold
			slowdown_hold = 2

			if(target.lying)	//putting in lying for the victim will cause the assailant to expend more effort
				slowdown_hold += 1

			if(target.is_dead() || target.incapacitated() )	// victim can't resist if he is dead or stunned.
				slowdown_hold *= 0.1
			else
				slowdown_hold += max(0, -0.05 * difference_stat)			// Avoids negative values from making the grabber going supersanic

			// Size check here
			if(grabber.mob_size > target.mob_size)
				slowdown_hold *= 0.5
			else if (grabber.mob_size < target.mob_size)
				slowdown_hold *= 1.5
		else
			/// 5 tally for something weighting 100 KG
			slowdown_hold = affecting.weight/1000 * 0.05

/obj/item/grab/attack(atom/movable/M, mob/living/user)
	if(!affecting)
		return
	if(world.time < (last_action + 20))
		return

	last_action = world.time
	reset_kill_state() //using special grab moves will interrupt choking them

	//clicking on the victim while grabbing them
	if(M == affecting)
		if(ishuman(affecting))
			var/obj/item/organ/external/hit_zone = user.targeted_organ
			var/mob/living/carbon/human/affected = M
			flick(hud.icon_state, hud)
			switch(user.a_intent)
				if(I_HELP)
					if(force_down)
						to_chat(user, SPAN_WARNING("You are no longer pinning [affected] to the ground."))
						affected.attack_log += "\[[time_stamp()]\] <font color='orange'>No longer pinned down by [user.name] ([user.ckey])</font>"
						user.attack_log += "\[[time_stamp()]\] <font color='red'>Released from pin [affected.name] ([affected.ckey])</font>"
						msg_admin_attack("[key_name(user)] Released from pin [key_name(affected)]")
						force_down = 0
						return
					else if(hit_zone == BP_MOUTH)
						force_vomit(affected, user)
					else
						var/mob/living/carbon/human/H = affected
						var/obj/item/organ/external/o = H.get_organ(hit_zone)

						if(o.status & ORGAN_BLEEDING)
							slow_bleeding(affected, user, o)
						else
							inspect_organ(affected, user, hit_zone)

				if(I_GRAB)
					if(hit_zone == BP_CHEST || hit_zone == BP_GROIN)
						swing(affected, user)
					else
						jointlock(affected, user, hit_zone)

				if(I_HURT)
					if(hit_zone == BP_EYES)
						attack_eye(affected, user)
					else if(hit_zone == BP_HEAD)
						headbutt(affected, user)
					else if(hit_zone == BP_CHEST)
						if(state < GRAB_NECK)
							dropkick(affected, user)
						else suplex(affected, user)
					else if(hit_zone == BP_GROIN)
						gut_punch(affected, user)
					else
						nerve_strike(affected, user, hit_zone)

				if(I_DISARM)
					pin_down(affected, user)
		// if its any other object , just kill the grab
		else
			qdel(src)
			return

	//clicking on yourself while grabbing them
	if(M == assailant && ishuman(affecting))
		fireman_throw(affecting, user)

/obj/item/grab/dropped()
	forceMove(NULLSPACE)
	if(!destroying)
		qdel(src)

/obj/item/grab/proc/reset_kill_state()
	var/mob/living/grabber = assailant
	var/mob/living/victim = affecting
	if(state == GRAB_KILL)
		grabber.visible_message(SPAN_WARNING("[grabber] lost \his tight grip on [victim]'s neck!"))
		victim.attack_log += "\[[time_stamp()]\] <font color='orange'>No longer gripped by [grabber.name] ([grabber.ckey] neck.)</font>"
		grabber.attack_log += "\[[time_stamp()]\] <font color='red'>Lost his grip on [victim.name] ([victim.ckey] neck.)</font>"
		msg_admin_attack("[key_name(grabber)] lost his tight grip on [key_name(victim)] neck.")
		hud.icon_state = "kill"
		state = GRAB_NECK

/obj/item/grab/Destroy()
	if(affecting)
		animate(affecting, 0.2 SECONDS, pixel_x = 0)
		animate(affecting, 0.2 SECONDS, pixel_y = 0)
		UnregisterSignal(affecting, COMSIG_MOVABLE_MOVED)
		affecting.atomFlags &= ~AF_LAYER_UPDATE_HANDLED
		if (issuperioranimal(affecting))
			var/mob/living/carbon/superior_animal/wrangled = affecting
			if (wrangled.grabbed_by_friend && assailant && (assailant in wrangled.friends))
				wrangled.grabbed_by_friend = FALSE
		affecting.reset_plane_and_layer()
		affecting.grabbedBy = null
		affecting = null
	if(assailant)
		UnregisterSignal(assailant, COMSIG_MOVABLE_MOVED)
		if(ismob(assailant))
			var/mob/grabber = assailant
			if(grabber.client)
				grabber.client.screen -= hud
		assailant = null

	QDEL_NULL(hud)
	destroying = TRUE // stops us calling qdel(src) on dropped()
	return ..()


//A stub for bay grab system. This is supposed to check a var on the associated grab datum
/obj/item/grab/proc/force_stand()
	return FALSE
