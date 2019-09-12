//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/weapon/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/projectile.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "giskard_old"
	item_state = "gun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(MATERIAL_STEEL = 6)
	w_class = ITEM_SIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = WEAPON_FORCE_WEAK
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	hud_actions = list()

	var/damage_multiplier = 1 //Multiplies damage of projectiles fired from this gun
	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = 'sound/weapons/Gunshot.ogg'

	var/fire_sound_text = "gunshot"
	var/recoil = 0		//screen shake
	var/recoil_buildup = 0.2 //How quickly recoil builds up

	var/muzzle_flash = 3
	var/requires_two_hands
	var/dual_wielding
	var/wielded_icon = "gun_wielded"
	var/zoom_factor = 0 //How much to scope in when using weapon

	var/suppress_delay_warning = FALSE

	var/safety = TRUE//is safety will be toggled on spawn() or not
	var/restrict_safety = FALSE//if gun don't need safety in all - toggle to TRUE

	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100
	var/mouthshoot = FALSE //To stop people from suiciding twice... >.>

	/*	SILENCER HANDLING */
	var/obj/item/weapon/silencer/silenced = null //The installed silencer, if any
	var/silencer_type = null //The type of silencer that could be installed in us, if we don't have one
	var/fire_sound_silenced = 'sound/weapons/Gunshot_silenced.wav' //Firing sound used when silenced
	var/datum/timedevent/recoil_timer //Allows for recoil buildup, this is reset when you don't fire your gun for N seconds (affected by vig)

/obj/item/weapon/gun/get_item_cost(export)
	if(export)
		return ..() * 0.5 //Guns should be sold in the player market.
	..()

/obj/item/weapon/gun/Initialize()
	. = ..()
	for(var/i in 1 to firemodes.len)
		var/list/L = firemodes[i]

		//If this var is set, it means spawn a specific subclass of firemode
		if (L["mode_type"])
			var/newtype = L["mode_type"]
			firemodes[i] = new newtype(src, firemodes[i])
		else
			firemodes[i] = new /datum/firemode(src, firemodes[i])

	//Properly initialize the default firing mode
	if (firemodes.len)
		var/datum/firemode/F = firemodes[sel_mode]
		F.apply_to(src)

	if(!restrict_safety)
		verbs += /obj/item/weapon/gun/proc/toggle_safety_verb//addint it to all guns

		var/obj/screen/item_action/action = new /obj/screen/item_action/top_bar/gun/safety
		action.owner = src
		hud_actions += action

	if(firemodes.len > 1)
		var/obj/screen/item_action/action = new /obj/screen/item_action/top_bar/gun/fire_mode
		action.owner = src
		hud_actions += action

	if(zoom_factor)
		var/obj/screen/item_action/action = new /obj/screen/item_action/top_bar/gun/scope
		action.owner = src
		hud_actions += action


/obj/item/weapon/gun/Destroy()
	for(var/i in firemodes)
		if(!islist(i))
			qdel(i)
	firemodes = null
	aim_targets = null
	last_moved_mob = null
	return ..()

/obj/item/weapon/gun/update_wear_icon()
	if(requires_two_hands)
		var/mob/living/M = loc
		if(istype(M))
			if((M.l_hand == src && !M.r_hand) || (M.r_hand == src && !M.l_hand))
				name = "[initial(name)] (wielded)"
				item_state = wielded_icon
			else
				name = initial(name)
				item_state = initial(item_state)
				update_icon(ignore_inhands=1) // In case item_state is set somewhere else.
	..()

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/weapon/gun/proc/special_check(var/mob/user)

	if(!isliving(user))
		return FALSE
	if(!user.IsAdvancedToolUser())
		return FALSE

	var/mob/living/M = user
	if(HULK in M.mutations)
		to_chat(user, SPAN_DANGER("Your fingers are much too large for the trigger guard!"))
		return FALSE
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_LEG, BP_R_LEG)))
				handle_post_fire(user, user)
				user.visible_message(
					SPAN_DANGER("\The [user] shoots \himself in the foot with \the [src]!"),
					SPAN_DANGER("You shoot yourself in the foot with \the [src]!")
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return FALSE
	if(!restrict_safety)
		if(safety)
			to_chat(user, SPAN_DANGER("The gun's safety is on!"))
			handle_click_empty(user)
			return FALSE
	return TRUE

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	var/obj/item/weapon/gun/off_hand   //DUAL WIELDING
	if(ishuman(user) && user.a_intent == "harm")
		var/mob/living/carbon/human/H = user
		if(H.r_hand == src && istype(H.l_hand, /obj/item/weapon/gun))
			off_hand = H.l_hand
			dual_wielding = TRUE

		else if(H.l_hand == src && istype(H.r_hand, /obj/item/weapon/gun))
			off_hand = H.r_hand
			dual_wielding = TRUE
		else
			dual_wielding = FALSE

		if(off_hand && off_hand.can_hit(user))
			spawn(1)
			off_hand.Fire(A,user,params)
	else
		dual_wielding = FALSE

	Fire(A,user,params) //Otherwise, fire normally.

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.targeted_organ == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'


/obj/item/weapon/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	.=..()
	if (!.)
		if (silencer_type && istype(A, silencer_type))
			apply_silencer(A, user)


/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return

	if(world.time < next_fire_time)
		if (!suppress_delay_warning && world.time % 3) //to prevent spam
			to_chat(user, SPAN_WARNING("[src] is not ready to fire again!"))
		return


	add_fingerprint(user)

	if(!special_check(user))
		return



	var/shoot_time = (burst - 1)* burst_delay
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
	next_fire_time = world.time + shoot_time

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		process_accuracy(projectile, user, target)

		projectile.multiply_projectile_damage(damage_multiplier)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.targeted_organ, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	//update timing
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.set_move_cooldown(move_delay)
	next_fire_time = world.time + fire_delay

	if(muzzle_flash)
		set_light(0)

//obtains the next projectile to fire
/obj/item/weapon/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/weapon/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return check_trajectory(target, user)

//called if there was no projectile to shoot
/obj/item/weapon/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", SPAN_DANGER("*click*"))
	else
		src.visible_message("*click click*")
	playsound(src.loc, 'sound/weapons/guns/misc/gun_empty.ogg', 100, 1)
	update_firemode() //Stops automatic weapons spamming this shit endlessly

//called after successfully firing
/obj/item/weapon/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(silenced)
		//Silenced shots have a lower range and volume
		playsound(user, fire_sound_silenced, 15, 1, -3)
	else
		playsound(user, fire_sound, 60, 1)

		if(reflex)
			user.visible_message(
				"<span class='reflex_shoot'><b>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""] by reflex!</b></span>",
				"<span class='reflex_shoot'>You fire \the [src] by reflex!</span>",
				"You hear a [fire_sound_text]!"
			)
		else
			user.visible_message(
				SPAN_WARNING("\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""]!"),
				SPAN_WARNING("You fire \the [src]!"),
				"You hear a [fire_sound_text]!"
				)

		if(muzzle_flash)
			set_light(muzzle_flash)
	//We've successfully fired a shot! Now we add recoil, and add a delay to remove the recoil (2s, affected by vig)
	recoil += recoil_buildup*10 //Course wanted noticeable recoil. EX: 0.2 buildup * 10 = 2
	var/skill_offset = user.stats.getStat(STAT_VIG)/50 //For example, IH have 40 VIG so this translates into a 0.8s cooldown reduction,meaning they can fire double as fast. Feel free to change this, Course!
	var/recoil_reset_time = 20 //After you fire your shot, you must wait 2 seconds for it to become accurate again
	recoil_reset_time -= skill_offset
	recoil -= skill_offset //People with VIG are better at controlling sprays

	if(!recoil_timer || QDELETED(recoil_timer)) //If there is not already an active recoil timer, make a new one
		addtimer(CALLBACK(src, .proc/reset_recoil), recoil_reset_time)
	else //There is already a recoil timer, so add onto its reset time.
		recoil_timer.timeToRun += recoil_reset_time
	if(recoil)
		update_cursor(user)
	update_icon()

/obj/item/weapon/gun/proc/reset_recoil() //Clear all our recoil, CSGO style
	var/mob/living/M = loc
	if(istype(M) && recoil)
		update_cursor(M) //Show that their recoil has diminished
	recoil = 0
	recoil_timer = null //Remove the timer object's reference to avoid null pointer

/obj/item/weapon/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/damage_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = 0
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage *= damage_mult

/obj/item/weapon/gun/proc/process_accuracy(obj/projectile, mob/user, atom/target, dispersion) //Applies the actual bullet spread
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return
	if(recoil)
		dispersion += recoil/2
	P.dispersion = dispersion

	if (aim_targets && (target in aim_targets))
		P.dispersion -= 0.3//less dispersion is better - radius = round(dispersion*9, 1), it is also accepts negative values

//does the actual launching of the projectile
/obj/item/weapon/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return FALSE //default behaviour only applies to true projectiles

	if(params)
		P.set_clickpoint(params)
	var/lower_offset = 0
	var/upper_offset = 0
	if(recoil)
		lower_offset = -recoil*20
		upper_offset = recoil*20
	if(iscarbon(user))
		var/mob/living/carbon/mob = user
		var/aim_coeff = mob.stats.getStat(STAT_VIG)/10 //Allows for security to be better at aiming
		if(aim_coeff > 0)//EG. 60 which is the max, turns into 6. Giving a sizeable accuracy bonus.
			lower_offset += aim_coeff
			upper_offset -= aim_coeff
		if(mob.shock_stage > 120)	//shooting while in shock
			lower_offset *= 15 //A - * a - is a +
			upper_offset *= 15
		else if(mob.shock_stage > 70)
			lower_offset *= 10 //A - * a - is a +
			upper_offset *= 10

	var/x_offset = 0
	var/y_offset = 0
	x_offset = rand(lower_offset, upper_offset) //Recoil fucks up the spread of your bullets
	y_offset = rand(lower_offset, upper_offset)


	return !P.launch_from_gun(target, user, src, target_zone, x_offset, y_offset)

//Suicide handling.
/obj/item/weapon/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = TRUE
	M.visible_message(SPAN_DANGER("[user] points their gun at their head, ready to pull the trigger..."))
	if(!do_after(user, 40, progress=0))
		M.visible_message(SPAN_NOTICE("[user] decided life was worth living"))
		mouthshoot = FALSE
		return

	if(!restrict_safety)
		if(safety)
			handle_click_empty(user)
			mouthshoot = FALSE
			return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message(SPAN_WARNING("[user] pulls the trigger."))
		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 60, 1)
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message(SPAN_WARNING("You feel rather silly, trying to commit suicide with a toy."))
			mouthshoot = FALSE
			return

		in_chamber.on_hit(M)
		if (in_chamber.damage_type != HALLOSS)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, BP_HEAD, used_weapon = "Point blank shot in the head with \a [in_chamber]", sharp=1)
			user.death()
		else
			to_chat(user, SPAN_NOTICE("Ow..."))
			user.apply_effect(110,AGONY,0)
		qdel(in_chamber)
		mouthshoot = FALSE
		return
	else
		handle_click_empty(user)
		mouthshoot = FALSE
		return

/obj/item/weapon/gun/proc/toggle_scope(mob/living/user)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	if(!zoom_factor)
		zoom = FALSE
		return
	var/zoom_offset = round(world.view * zoom_factor)
	var/view_size = round(world.view + zoom_factor)

	zoom(zoom_offset, view_size)
	if(zoom)
		if(recoil)
			recoil = round(recoil*zoom_factor+1) //recoil is worse when looking through a scope
	update_cursor(user)
	update_hud_actions()

//make sure accuracy and recoil are reset regardless of how the item is unzoomed.
/obj/item/weapon/gun/zoom()
	..()
	if(!zoom)
		recoil = initial(recoil)
	update_cursor(usr)

/obj/item/weapon/gun/examine(mob/user)
	..()
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		to_chat(user, SPAN_NOTICE("The fire selector is set to [current_mode.name]."))

	if(!restrict_safety)
		if(safety)
			to_chat(user, SPAN_NOTICE("The safety is on."))
		else
			to_chat(user, SPAN_NOTICE("The safety is off."))

	//Tell the user if they could fit a silencer on
	if (silencer_type && !silenced)
		to_chat(user, SPAN_NOTICE("You could attach a silencer to this."))

/obj/item/weapon/gun/proc/switch_firemodes()
	if(firemodes.len <= 1)
		return null
	update_firemode(FALSE) //Disable the old firing mode before we switch away from it
	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	new_mode.update()
	update_hud_actions()
	return new_mode

/obj/item/weapon/gun/attack_self(mob/user)
	if(zoom)
		toggle_scope(user)
		return

	toggle_firemode(user)

/obj/item/weapon/gun/ui_action_click(mob/living/user, action_name)
	switch(action_name)
		if("fire mode")
			toggle_firemode(user)
		if("scope")
			toggle_scope(user)
		if("safety")
			toggle_safety(user)

/obj/item/weapon/gun/proc/toggle_firemode(mob/living/user)
	var/datum/firemode/new_mode = switch_firemodes()
	if(new_mode)
		playsound(src.loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now set to [new_mode.name]."))

/obj/item/weapon/gun/proc/toggle_safety(mob/living/user)
	if(restrict_safety || src != user.get_active_hand())
		return

	safety = !safety
	playsound(user, 'sound/weapons/selector.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You toggle the safety [safety ? "on":"off"]."))
	//Update firemode when safeties are toggled
	update_firemode()
	update_hud_actions()
	update_cursor(user)


//Finds the current firemode and calls update on it. This is called from a few places:
//When firemode is changed
//When safety is toggled
//When gun is picked up
//When gun is readied
/obj/item/weapon/gun/proc/update_firemode(var/force_state = null)
	if (sel_mode && firemodes && firemodes.len)
		var/datum/firemode/new_mode = firemodes[sel_mode]
		new_mode.update(force_state)

/obj/item/weapon/gun/AltClick(mob/user)
	if(!restrict_safety)
		if(user.incapacitated())
			to_chat(user, SPAN_WARNING("You can't do that right now!"))
			return

		toggle_safety(user)


//Updating firing modes at appropriate times
/obj/item/weapon/gun/pickup(mob/user)
	.=..()
	update_firemode()

/obj/item/weapon/gun/dropped(mob/user)
	.=..()
	update_firemode(FALSE)

/obj/item/weapon/gun/swapped_from()
	.=..()
	update_firemode(FALSE)

/obj/item/weapon/gun/swapped_to()
	.=..()
	update_firemode()

/obj/item/weapon/gun/proc/toggle_safety_verb()
	set name = "Toggle gun's safety"
	set category = "Object"
	set src in view(1)

	toggle_safety(usr)

/*
	Gun Modding
*/
/obj/item/weapon/gun/proc/apply_silencer(var/obj/item/weapon/silencer/A, var/mob/user)
	if (silenced)
		to_chat(user, "\The [src] already has a silencer installed!")
		return

	if (istype(A, silencer_type))

		if (user)
			playsound(src, WORKSOUND_SCREW_DRIVING, 50, 1)
			if (!do_after(user, 40, src))
				return
			if (!user.unEquip(A))
				return
			to_chat(user, SPAN_NOTICE("You install \the [A] in \the [src]"))

		//Here's the code where we actually install it
		A.forceMove(src)//Silencer goes inside us
		silenced = A
		damage_multiplier -= A.damage_mod //Silencers make the weapon slightly weaker
		update_icon() //Guns that support silencers are responsible for setting their own icon appropriately
		if (silenced.can_remove)
			verbs += /obj/item/weapon/gun/proc/remove_silencer //Give us a verb to remove it


/obj/item/weapon/gun/proc/remove_silencer(var/mob/user)
	if (!silenced || !silenced.can_remove)
		to_chat(user, "No silencer is installed on \the [src]")
		verbs -= /obj/item/weapon/gun/proc/remove_silencer
		return

	if (user)
		playsound(src, WORKSOUND_SCREW_DRIVING, 50, 1)
		if (!do_after(user, 40, src))
			return
		//Drop it in their hands
		user.put_in_hands(silenced)
	.=silenced //Set return value to the silencer incase caller wants to do something with it
	if (silenced.loc == src)
		silenced.forceMove(loc) //Move it out if a user didn't take it

	damage_multiplier += silenced.damage_mod
	silenced = null
	update_icon()