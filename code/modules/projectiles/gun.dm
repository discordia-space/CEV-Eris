//Parent gun type. Guns are weapons that can be aimed at69obs and act over a distance
/obj/item/gun
	name = "gun"
	desc = "A gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "giskard_old"
	item_state = "gun"
	item_state_slots = list(
		slot_l_hand_str = "lefthand",
		slot_r_hand_str = "righthand",
		slot_back_str   = "back",
		slot_s_store_str= "onsuit",
		)
	flags = CONDUCT
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
	bad_type = /obj/item/gun
	spawn_tags = SPAWN_TAG_GUN
	rarity_value = 5
	spawn_fre69uency = 10

	var/damage_multiplier = 1 //Multiplies damage of projectiles fired from this gun
	var/style_damage_multiplier = 1 //69ultiplies style damage of projectiles fired from this gun
	var/penetration_multiplier = 1 //Multiplies armor penetration of projectiles fired from this gun
	var/pierce_multiplier = 0 //Additing wall penetration to projectiles fired from this gun
	var/ricochet_multiplier = 1 //multiplier for how69uch projectiles fired from this gun can ricochet,69odified by the bullet blender weapon69od
	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/rigged = FALSE
	var/fire_sound_text = "gunshot"
	var/recoil_buildup = 2 //How 69uickly recoil builds up
	var/list/gun_parts = list(/obj/item/part/gun = 1 ,/obj/item/stack/material/steel = 4)

	var/muzzle_flash = 3
	var/dual_wielding
	var/can_dual = FALSE // Controls whether guns can be dual-wielded (firing two at once).
	var/zoom_factor = 0 //How69uch to scope in when using weapon

	var/suppress_delay_warning = FALSE

	var/safety = TRUE//is safety will be toggled on spawn() or69ot
	var/restrict_safety = FALSE //To restrict the users ability to toggle the safety

	var/dna_compare_samples = FALSE //If DNA-lock installed
	var/dna_lock_sample = "not_set" //real_name from69ob who installed DNA-lock
	var/dna_user_sample = "not_set" //Current user's real_name

	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected69ode
	var/list/firemodes = list()
	var/list/init_firemodes = list()

	var/init_offset = 0

	var/mouthshoot = FALSE //To stop people from suiciding twice... >.>

	var/list/gun_tags = list() //Attributes of the gun, used to see if an upgrade can be applied to this weapon.
	var/gilded = FALSE
	/*	SILENCER HANDLING */
	var/silenced = FALSE
	var/fire_sound_silenced = 'sound/weapons/Gunshot_silenced.wav' //Firing sound used when silenced

	var/icon_contained = TRUE
	var/static/list/item_icons_cache = list()
	var/wielded_item_state
	var/one_hand_penalty = 0 //The higher this69umber is, the69ore severe the accuracy penalty for shooting it one handed. 5 is a good baseline for this, but69ar edit it live and play with it yourself.

	var/projectile_color //Set by a firemode. Sets the fired projectiles color

	var/twohanded = FALSE //If TRUE, gun can only be fired when wileded
	var/recentwield = 0 // to prevent spammage
	var/proj_step_multiplier = 1
	var/proj_agony_multiplier = 1
	var/list/proj_damage_adjust = list() //What additional damage do we give to the bullet. Type(string) -> Amount(int)
	var/darkness_view = 0
	var/vision_flags = 0
	var/see_invisible_gun = -1
	var/noricochet = FALSE // wether or69ot bullets fired from this gun can ricochet off of walls
	var/inversed_carry = FALSE
	var/wield_delay = 0 // Gun wielding delay , generally in seconds.
	var/wield_delay_factor = 0 // A factor that characterizes weapon size , this69akes it re69uire69ore69ig to insta-wield this weapon or less ,69alues below 0 reduce the69ig69eeded and above 1 increase it

/obj/item/gun/wield(mob/user)
	if(!wield_delay)
		..()
		return
	var/calculated_delay = wield_delay
	if(ishuman(user))
		calculated_delay = wield_delay - (wield_delay * (user.stats.getStat(STAT_VIG) / (100 * (wield_delay_factor ? wield_delay_factor : 0.01)))) // wield delay - wield_delay * user69igilance / 100 * wield_factor
	if (calculated_delay > 0 && do_after(user, calculated_delay, immobile = FALSE))
		..()
	else if (calculated_delay <= 0)
		..()


/obj/item/gun/attackby(obj/item/I,69ob/living/user, params)
	if(!istool(I) || user.a_intent != I_HURT)
		return FALSE
	if(!gun_parts)
		to_chat(user, SPAN_NOTICE("You can't dismantle 69src69 as it has69o gun parts! How strange..."))
		return FALSE
	if(I.get_tool_69uality(69UALITY_BOLT_TURNING))
		user.visible_message(SPAN_NOTICE("69user69 begins breaking apart 69src69."), SPAN_WARNING("You begin breaking apart 69src69 for gun parts."))
	if(I.use_tool(user, src, WORKTIME_SLOW, 69UALITY_BOLT_TURNING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
		user.visible_message(SPAN_NOTICE("69user69 breaks 69src69 apart for gun parts!"), SPAN_NOTICE("You break 69src69 apart for gun parts."))
		for(var/target_item in gun_parts)
			var/amount = gun_parts69target_item69
			while(amount)
				new target_item(get_turf(src))
				amount--
		69del(src)

/obj/item/gun/get_item_cost(export)
	if(export)
		return ..() * 0.5 //Guns should be sold in the player69arket.
	..()

/obj/item/gun/Initialize()
	. = ..()
	initialize_firemodes()
	initialize_scope()
	//Properly initialize the default firing69ode
	if (firemodes.len)
		set_firemode(sel_mode)

	if(!restrict_safety)
		verbs += /obj/item/gun/proc/toggle_safety_verb//addint it to all guns

		var/obj/screen/item_action/action =69ew /obj/screen/item_action/top_bar/gun/safety
		action.owner = src
		hud_actions += action
	verbs += /obj/item/gun/proc/toggle_carry_state_verb


	if(icon_contained)
		if(!item_icons_cache69type69)
			item_icons_cache69type69 = list(
				slot_l_hand_str = icon,
				slot_r_hand_str = icon,
				slot_back_str = icon,
				slot_s_store_str = icon,
			)
		item_icons = item_icons_cache69type69
	if((one_hand_penalty || twohanded) && !wielded_item_state)//If the gun has a one handed penalty or is twohanded, but has69o wielded item state then use this generic one.
		wielded_item_state = "_doble" //Someone69ispelled double but they did it so consistently it's staying this way.
	generate_guntags()
	var/obj/screen/item_action/action =69ew /obj/screen/item_action/top_bar/weapon_info
	action.owner = src
	hud_actions += action

/obj/item/gun/Destroy()
	for(var/i in firemodes)
		if(!islist(i))
			69del(i)
	firemodes =69ull
	return ..()

/obj/item/gun/proc/set_item_state(state, hands = FALSE, back = FALSE, onsuit = FALSE)
	var/wield_state
	if(wielded_item_state)
		wield_state = wielded_item_state
	if(!(hands || back || onsuit))
		hands = back = onsuit = TRUE
	if(hands)//Ok this is a bit hacky. But basically if the gun is wielded, we want to use the wielded icon state over the other one.
		if(wield_state && wielded)//Because69ost of the time the "normal" icon state is held in one hand. This could be expanded to be less hacky in the future.
			item_state_slots69slot_l_hand_str69 = "lefthand"  + wield_state
			item_state_slots69slot_r_hand_str69 = "righthand" + wield_state
		else
			item_state_slots69slot_l_hand_str69 = "lefthand"  + state
			item_state_slots69slot_r_hand_str69 = "righthand" + state
	state = initial(state)

	var/carry_state = inversed_carry
	if(back && !carry_state)
		item_state_slots69slot_back_str69   = "back"      + state
	if(back && carry_state)
		item_state_slots69slot_back_str69   = "onsuit"      + state
	if(onsuit && !carry_state)
		item_state_slots69slot_s_store_str69= "onsuit"    + state
	if(onsuit && carry_state)
		item_state_slots69slot_s_store_str69= "back"    + state

/obj/item/gun/update_icon()
	if(wielded_item_state)
		if(icon_contained)//If it has it own icon file then we want to pull from that.
			if(wielded)
				item_state_slots69slot_l_hand_str69 = "lefthand"  + wielded_item_state
				item_state_slots69slot_r_hand_str69 = "righthand" + wielded_item_state
			else
				item_state_slots69slot_l_hand_str69 = "lefthand"
				item_state_slots69slot_r_hand_str69 = "righthand"
		else//Otherwise we can just pull from the generic left and right hand icons.
			if(wielded)
				item_state_slots69slot_l_hand_str69 = wielded_item_state
				item_state_slots69slot_r_hand_str69 = wielded_item_state
			else
				item_state_slots69slot_l_hand_str69 = initial(item_state)
				item_state_slots69slot_r_hand_str69 = initial(item_state)


//Checks whether a given69ob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return69ull there.
/obj/item/gun/proc/special_check(mob/user)

	if(!isliving(user))
		return FALSE
	if(!user.IsAdvancedToolUser())
		return FALSE

	var/mob/living/M = user
	if(HULK in69.mutations)
		to_chat(user, SPAN_DANGER("Your fingers are69uch too large for the trigger guard!"))
		return FALSE
	if(!restrict_safety)
		if(safety)
			to_chat(user, SPAN_DANGER("The gun's safety is on!"))
			handle_click_empty(user)
			return FALSE

	if(!twohanded_check(M))
		return FALSE

	if(!dna_check(M))
		to_chat(user, SPAN_DANGER("The gun's biometric scanner prevents you from firing!"))
		handle_click_empty(user)
		return FALSE

	if((CLUMSY in69.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_LEG, BP_R_LEG)))
				handle_post_fire(user, user)
				user.visible_message(
					SPAN_DANGER("\The 69user69 shoots \himself in the foot with \the 69src69!"),
					SPAN_DANGER("You shoot yourself in the foot with \the 69src69!")
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return FALSE
	if(rigged)
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, BP_HEAD))
				handle_post_fire(user, user)
				user.visible_message(
					SPAN_DANGER("As \the 69user69 pulls the trigger on \the 69src69, a bullet fires backwards out of it"),
					SPAN_DANGER("Your \the 69src69 fires backwards, shooting you in the face!")
					)
				user.drop_item()
			if(rigged > TRUE)
				explosion(get_turf(src), 1, 2, 3, 3)
				69del(src)
			return FALSE
	return TRUE

/obj/item/gun/proc/twohanded_check(user)
	if(twohanded)
		if(!wielded)
			if (world.time >= recentwield + 1 SECONDS)
				to_chat(user, SPAN_DANGER("The gun is too heavy to shoot in one hand!"))
				recentwield = world.time
			return FALSE
	return TRUE

/obj/item/gun/proc/dna_check(user)
	if(dna_compare_samples)
		dna_user_sample = usr.real_name
		if(dna_lock_sample != dna_user_sample)
			return FALSE
	return TRUE

/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/gun/afterattack(atom/A,69ob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	var/obj/item/gun/off_hand   //DUAL WIELDING
	if(ishuman(user) && user.a_intent == "harm")
		var/mob/living/carbon/human/H = user

		if(H.r_hand == src && isgun(H.l_hand))
			off_hand = H.l_hand
			dual_wielding = TRUE

		else if(H.l_hand == src && isgun(H.r_hand))
			off_hand = H.r_hand
			dual_wielding = TRUE
		else
			dual_wielding = FALSE

		if(!can_dual)
			dual_wielding = FALSE
		else if(off_hand && off_hand.can_hit(user))
			spawn(1)
			off_hand.Fire(A,user,params)
	else
		dual_wielding = FALSE

	Fire(A,user,params) //Otherwise, fire69ormally.

/obj/item/gun/attack(atom/A,69ob/living/user, def_zone)
	if (A == user && user.targeted_organ == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/gun/proc/Fire(atom/target,69ob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return

	if(world.time <69ext_fire_time)
		if (!suppress_delay_warning && world.time % 3) //to prevent spam
			to_chat(user, SPAN_WARNING("69src69 is69ot ready to fire again!"))
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
		if(user.resting)
			break
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		projectile.multiply_projectile_damage(damage_multiplier)

		projectile.multiply_projectile_penetration(penetration_multiplier + user.stats.getStat(STAT_VIG) * 0.02)

		projectile.multiply_pierce_penetration(pierce_multiplier)

		projectile.multiply_ricochet(ricochet_multiplier)

		projectile.multiply_projectile_step_delay(proj_step_multiplier)

		projectile.multiply_projectile_agony(proj_agony_multiplier)

		if(istype(projectile, /obj/item/projectile))
			var/obj/item/projectile/P = projectile
			P.adjust_damages(proj_damage_adjust)
			P.adjust_ricochet(noricochet)
			P.multiply_projectile_accuracy(user.stats.getStat(STAT_VIG)/2)

		if(pointblank)
			process_point_blank(projectile, user, target)
		if(projectile_color)
			projectile.icon = get_proj_icon_by_color(projectile, projectile_color)
			if(istype(projectile, /obj/item/projectile))
				var/obj/item/projectile/P = projectile
				P.proj_color = projectile_color
		if(process_projectile(projectile, user, target, user.targeted_organ, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	//update timing
	user.setClickCooldown(DEFAULT_69UICK_COOLDOWN)
	user.set_move_cooldown(move_delay)
	if(!twohanded && user.stats.getPerk(PERK_GUNSLINGER))
		next_fire_time = world.time + fire_delay - fire_delay * 0.33
	else
		next_fire_time = world.time + fire_delay

	if(muzzle_flash)
		set_light(0)

//obtains the69ext projectile to fire
/obj/item/gun/proc/consume_next_projectile()
	return69ull

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target,69ob/living/user)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff.69o big deal, the player can just choose to69ot target someone
	//on the other side of a window if it69akes a difference. Or if they run behind a window, too bad.
	return check_trajectory(target, user)

//called if there was69o projectile to shoot
/obj/item/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", SPAN_DANGER("*click*"))
	else
		src.visible_message("*click click*")
	playsound(src.loc, 'sound/weapons/guns/misc/gun_empty.ogg', 100, 1)
	update_firemode() //Stops automatic weapons spamming this shit endlessly

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(mob/living/user, atom/target, pointblank=0, reflex=0)
	if(silenced)
		//Silenced shots have a lower range and69olume
		playsound(user, fire_sound_silenced, 15, 1, -5)
	else
		playsound(user, fire_sound, 60, 1)

		if(reflex)
			user.visible_message(
				"<span class='reflex_shoot'><b>\The 69user69 fires \the 69src6969pointblank ? " point blank at \the 69target69":""69 by reflex!</b></span>",
				"<span class='reflex_shoot'>You fire \the 69src69 by reflex!</span>",
				"You hear a 69fire_sound_text69!"
			)
		else
			user.visible_message(
				SPAN_WARNING("\The 69user69 fires \the 69src6969pointblank ? " point blank at \the 69target69":""69!"),
				SPAN_WARNING("You fire \the 69src69!"),
				"You hear a 69fire_sound_text69!"
				)

		if(muzzle_flash)
			set_light(muzzle_flash)

	if(one_hand_penalty)
		if(!wielded)
			switch(one_hand_penalty)
				if(1)
					if(prob(50)) //don't69eed to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(2)
					to_chat(user, "<span class='warning'>Your aim wavers as you fire \the 69src69 with just one hand.</span>")
				if(3)
					to_chat(user, "<span class='warning'>You have trouble keeping \the 69src69 on target with just one hand.</span>")
				if(4 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to keep \the 69src69 on target with just one hand!</span>")

	user.handle_recoil(src)
	update_icon()

/obj/item/gun/proc/process_point_blank(obj/item/projectile/P,69ob/user, atom/target)
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	if(dual_wielding)
		return //dual wielding deal too69uch damage as it is, so69o point blank for it

	//default point blank69ultiplier
	var/damage_mult = 1.3

	//determine69ultiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = 0
			for(var/obj/item/grab/G in69.grabbed_by)
				grabstate =69ax(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.multiply_projectile_damage(damage_mult)


//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/item/projectile/P,69ob/living/user, atom/target,69ar/target_zone,69ar/params=null)
	if(!istype(P))
		return FALSE //default behaviour only applies to true projectiles

	if(params)
		P.set_clickpoint(params)
	var/offset = user.calculate_offset(init_offset)
	offset = rand(-offset, offset)

	return !P.launch_from_gun(target, user, src, target_zone, angle_offset = offset)

//Suicide handling.
/obj/item/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = TRUE
	M.visible_message(SPAN_DANGER("69user69 points their gun at their head, ready to pull the trigger..."))
	if(!do_after(user, 40, progress=0))
		M.visible_message(SPAN_NOTICE("69user69 decided life was worth living"))
		mouthshoot = FALSE
		return

	if(safety)
		handle_click_empty(user)
		mouthshoot = FALSE
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message(SPAN_WARNING("69user69 pulls the trigger."))
		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 60, 1)
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message(SPAN_WARNING("You feel rather silly, trying to commit suicide with a toy."))
			mouthshoot = FALSE
			return

		in_chamber.on_hit(M)
		if (!in_chamber.is_halloss())
			log_and_message_admins("69key_name(user)69 commited suicide using \a 69src69")
			for(var/damage_type in in_chamber.damage_types)
				var/damage = in_chamber.damage_types69damage_type69*2.5
				user.apply_damage(damage, damage_type, BP_HEAD, used_weapon = "Point blank shot in the head with \a 69in_chamber69", sharp=1)
			user.death()
		else
			to_chat(user, SPAN_NOTICE("Ow..."))
			user.adjustHalLoss(110)
		69del(in_chamber)
		mouthshoot = FALSE
		return
	else
		handle_click_empty(user)
		mouthshoot = FALSE
		return

/obj/item/gun/proc/toggle_scope(mob/living/user)
	//looking through a scope limits your periphereal69ision
	//still, increase the69iew size by a tiny amount so that sniping isn't too restricted to69SEW
	if(!zoom_factor)
		zoom = FALSE
		return
	var/zoom_offset = round(world.view * zoom_factor)
	var/view_size = round(world.view + zoom_factor)

	zoom(zoom_offset,69iew_size)
	check_safety_cursor(user)
	update_hud_actions()

/obj/item/gun/examine(mob/user)
	..()
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes69sel_mode69
		to_chat(user, SPAN_NOTICE("The fire selector is set to 69current_mode.name69."))

	if(safety)
		to_chat(user, SPAN_NOTICE("The safety is on."))
	else
		to_chat(user, SPAN_NOTICE("The safety is off."))

	if(one_hand_penalty)
		to_chat(user, SPAN_WARNING("This gun69eeds to be wielded in both hands to be used69ost effectively."))


/obj/item/gun/proc/initialize_firemodes()
	69DEL_CLEAR_LIST(firemodes)

	for(var/i in 1 to init_firemodes.len)
		var/list/L = init_firemodes69i69
		add_firemode(L)

	var/obj/screen/item_action/action = locate(/obj/screen/item_action/top_bar/gun/fire_mode) in hud_actions
	if(firemodes.len > 1)
		if(!action)
			action =69ew /obj/screen/item_action/top_bar/gun/fire_mode
			action.owner = src
			hud_actions += action
	else
		69del(action)
		hud_actions -= action

/obj/item/gun/proc/initialize_scope()
	var/obj/screen/item_action/action = locate(/obj/screen/item_action/top_bar/gun/scope) in hud_actions
	if(zoom_factor > 0)
		if(!action)
			action =69ew /obj/screen/item_action/top_bar/gun/scope
			action.owner = src
			hud_actions += action
			if(ismob(loc))
				var/mob/user = loc
				user.client?.screen += action
	else
		if(ismob(loc))
			var/mob/user = loc
			user.client?.screen -= action
		hud_actions -= action
		69del(action)

/obj/item/gun/proc/add_firemode(list/firemode)
	//If this69ar is set, it69eans spawn a specific subclass of firemode
	if (firemode69"mode_type"69)
		var/newtype = firemode69"mode_type"69
		firemodes.Add(new69ewtype(src, firemode))
	else
		firemodes.Add(new /datum/firemode(src, firemode))

/obj/item/gun/proc/switch_firemodes()
	if(firemodes.len <= 1)
		return69ull
	update_firemode(FALSE) //Disable the old firing69ode before we switch away from it
	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	return set_firemode(sel_mode)

/obj/item/gun/proc/set_firemode(index)
	refresh_upgrades()
	if(index > firemodes.len)
		index = 1
	var/datum/firemode/new_mode = firemodes69sel_mode69
	new_mode.apply_to(src)
	new_mode.update()
	update_hud_actions()
	return69ew_mode

/// Set firemode , but without a refresh_upgrades at the start
/obj/item/gun/proc/very_unsafe_set_firemode(index)
	if(index > firemodes.len)
		index = 1
	var/datum/firemode/new_mode = firemodes69sel_mode69
	new_mode.apply_to(src)
	new_mode.update()
	update_hud_actions()
	return69ew_mode

/obj/item/gun/attack_self(mob/user)
	if(zoom)
		toggle_scope(user)
		return

	toggle_firemode(user)

/obj/item/gun/proc/toggle_firemode(mob/living/user)
	var/datum/firemode/new_mode = switch_firemodes()
	if(new_mode)
		playsound(src.loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("\The 69src69 is69ow set to 69new_mode.name69."))

/obj/item/gun/proc/toggle_safety(mob/living/user)
	if(restrict_safety || src != user.get_active_hand())
		return

	safety = !safety
	playsound(user, 'sound/weapons/selector.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You toggle the safety 69safety ? "on":"off"69."))
	//Update firemode when safeties are toggled
	update_firemode()
	update_hud_actions()
	check_safety_cursor(user)
	
/obj/item/gun/proc/check_safety_cursor(mob/living/user)
	if(safety)
		user.remove_cursor()
	else
		user.update_cursor(src)

/obj/item/gun/proc/toggle_carry_state(mob/living/user)
	inversed_carry = !inversed_carry
	to_chat(user, SPAN_NOTICE("You adjust the way the gun will be worn on your back and on your suit."))
	set_item_state()

/obj/item/gun/proc/get_total_damage_adjust()
	var/val = 0
	for(var/i in proj_damage_adjust)
		val += proj_damage_adjust69i69
	return69al


//Finds the current firemode and calls update on it. This is called from a few places:
//When firemode is changed
//When safety is toggled
//When gun is picked up
//When gun is readied
/obj/item/gun/proc/update_firemode(force_state =69ull)
	if (sel_mode && firemodes && firemodes.len)
		var/datum/firemode/new_mode = firemodes69sel_mode69
		new_mode.update(force_state)

/obj/item/gun/AltClick(mob/user)
	if(user.incapacitated())
		to_chat(user, SPAN_WARNING("You can't do that right69ow!"))
		return

	toggle_safety(user)


//Updating firing69odes at appropriate times
/obj/item/gun/pickup(mob/user)
	.=..()
	update_firemode()

/obj/item/gun/dropped(mob/user)
	.=..()
	update_firemode(FALSE)

/obj/item/gun/swapped_from()
	.=..()
	update_firemode(FALSE)

/obj/item/gun/swapped_to()
	.=..()
	update_firemode()

/obj/item/gun/proc/toggle_safety_verb()
	set69ame = "Toggle gun's safety"
	set category = "Object"
	set src in69iew(1)

	toggle_safety(usr)

/obj/item/gun/proc/toggle_carry_state_verb()
	set69ame = "Toggle gun's carry position"
	set category = "Object"
	set src in69iew(1)

	toggle_carry_state(usr)

/obj/item/gun/ui_data(mob/user)
	var/list/data = list()
	data69"damage_multiplier"69 = damage_multiplier
	data69"pierce_multiplier"69 = pierce_multiplier
	data69"ricochet_multiplier"69 = ricochet_multiplier
	data69"penetration_multiplier"69 = penetration_multiplier

	data69"fire_delay"69 = fire_delay //time between shot, in69s
	data69"burst"69 = burst //How69any shots are fired per click
	data69"burst_delay"69 = burst_delay //time between shot in burst69ode, in69s

	data69"force"69 = force
	data69"force_max"69 = initial(force)*10
	data69"muzzle_flash"69 =69uzzle_flash

	data69"recoil_buildup"69 = recoil_buildup
	data69"recoil_buildup_max"69 = initial(recoil_buildup)*10

	data += ui_data_projectile(get_dud_projectile())

	if(firemodes.len)
		var/list/firemodes_info = list()
		for(var/i = 1 to firemodes.len)
			data69"firemode_count"69 += 1
			var/datum/firemode/F = firemodes69i69
			var/list/firemode_info = list(
				"index" = i,
				"current" = (i == sel_mode),
				"name" = F.name,
				"desc" = F.desc,
				"burst" = F.settings69"burst"69,
				"fire_delay" = F.settings69"fire_delay"69,
				"move_delay" = F.settings69"move_delay"69,
				)
			if(F.settings69"projectile_type"69)
				var/proj_path = F.settings69"projectile_type"69
				var/list/proj_data = ui_data_projectile(new proj_path)
				firemode_info += proj_data
			firemodes_info += list(firemode_info)
		data69"firemode_info"69 = firemodes_info

	if(item_upgrades.len)
		data69"attachments"69 = list()
		for(var/atom/A in item_upgrades)
			data69"attachments"69 += list(list("name" = A.name, "icon" = getAtomCacheFilename(A)))

	return data

/obj/item/gun/Topic(href, href_list, datum/topic_state/state)
	if(..(href, href_list, state))
		return 1

	if(href_list69"firemode"69)
		sel_mode = text2num(href_list69"firemode"69)
		set_firemode(sel_mode)
		return 1

//Returns a projectile that's69ot for active usage.
/obj/item/gun/proc/get_dud_projectile()
	return69ull

/obj/item/gun/proc/ui_data_projectile(var/obj/item/projectile/P)
	if(!P)
		return list()
	var/list/data = list()
	data69"projectile_name"69 = P.name
	data69"projectile_damage"69 = (P.get_total_damage() * damage_multiplier) + get_total_damage_adjust()
	data69"projectile_AP"69 = P.armor_penetration * penetration_multiplier
	69del(P)
	return data


/obj/item/gun/refresh_upgrades()
	//First of all, lets reset any69ar that could possibly be altered by an upgrade
	damage_multiplier = initial(damage_multiplier)
	penetration_multiplier = initial(penetration_multiplier)
	pierce_multiplier = initial(pierce_multiplier)
	ricochet_multiplier = initial(ricochet_multiplier)
	proj_step_multiplier = initial(proj_step_multiplier)
	proj_agony_multiplier = initial(proj_agony_multiplier)
	fire_delay = initial(fire_delay)
	move_delay = initial(move_delay)
	recoil_buildup = initial(recoil_buildup)
	muzzle_flash = initial(muzzle_flash)
	silenced = initial(silenced)
	restrict_safety = initial(restrict_safety)
	init_offset = initial(init_offset)
	proj_damage_adjust = list()
	fire_sound = initial(fire_sound)
	restrict_safety = initial(restrict_safety)
	dna_compare_samples = initial(dna_compare_samples)
	rigged = initial(rigged)
	zoom_factor = initial(zoom_factor)
	darkness_view = initial(darkness_view)
	vision_flags = initial(vision_flags)
	see_invisible_gun = initial(see_invisible_gun)
	force = initial(force)
	armor_penetration = initial(armor_penetration)
	sharp = initial(sharp)
	attack_verb = list()
	one_hand_penalty = initial(one_hand_penalty)
	initialize_scope()
	initialize_firemodes()

	//Now lets have each upgrade reapply its69odifications
	SEND_SIGNAL(src, COMSIG_ADDVAL, src)
	SEND_SIGNAL(src, COMSIG_APPVAL, src)

	if(firemodes.len)
		very_unsafe_set_firemode(sel_mode) // Reset the firemode so it gets the69ew changes

	update_icon()
	//then update any UIs with the69ew stats
	SSnano.update_uis(src)

/obj/item/gun/proc/generate_guntags()
	if(one_hand_penalty)
		gun_tags |= GUN_GRIP
	if(!zoom_factor && !(slot_flags & SLOT_HOLSTER))
		gun_tags |= GUN_SCOPE
	if(!sharp)
		gun_tags |= SLOT_BAYONET

/obj/item/gun/zoom(tileoffset,69iewsize)
	..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(zoom)
		H.using_scope = src
	else
		H.using_scope =69ull
