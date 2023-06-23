/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	w_class = ITEM_SIZE_NORMAL

	//spawn_values
	price_tag = 0
	//spawn_tags = SPAWN_TAG_ITEM
	rarity_value = 10
	spawn_frequency = 10
	bad_type = /obj/item

	pass_flags = PASSTABLE
	var/image/blood_overlay //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6
	var/abstract = 0
	var/r_speed = 1
	var/health = 100
	var/maxHealth = 100
	var/burn_point
	var/burning
	var/hitsound = 'sound/weapons/genhit1.ogg'
	var/worksound
	var/no_attack_log = 0			//If it's an item we don't want to log attack_logs with, set this to 1

	//The cool stuff for melee
	var/screen_shake = FALSE 		//If a weapon can shake the victim's camera on hit.
	var/forced_broad_strike = FALSE //If a weapon is forced to always perform broad strikes.
	var/extended_reach = FALSE		//Wielded spears can hit alive things one tile further.
	var/ready = FALSE				//All weapons that are ITEM_SIZE_BULKY or bigger have double tact, meaning you have to click twice.
	var/no_double_tact = FALSE		//for when you,  for some inconceivable reason, want a bulky item to not have double tact
	var/push_attack = FALSE			//Hammers and spears can push the victim away on hit when you aim groin.
	//Why are we using vars instead of defines or anything else?
	//Because we need them to be shown in the tool info UI.

	var/obj/item/master
	var/list/origin_tech = list()	//Used by R&D to determine what research bonuses it grants.
	var/list/attack_verb = list() //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"


	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/datum/action/item_action/action
	var/action_button_name //It is also the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. If it's not set, there'll be no button.
	var/action_button_is_hands_free = 0 //If 1, bypass the restrained, lying, and stunned checks action buttons normally test for
	var/action_button_proc //If set, when the button is used it calls the proc of that name
	var/action_button_arguments //If set, hands these arguments to the proc.

	//This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	//It should be used purely for appearance. For gameplay effects caused by items covering body parts, use body_parts_covered.
	var/flags_inv = 0
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/list/tool_qualities// List of item qualities for tools system. See qualities.dm.
	var/list/aspects = list()

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/slowdown_hold // How much holding an item slows you down.

	var/datum/armor/armor // Ref to the armor datum
	var/list/allowed = list() //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink // All items can have an uplink hidden inside, just remember to add the triggers.
	var/zoomdevicename //name used for message when binoculars/scope is used
	var/zoom = 0 //1 if item is actively being used to zoom. For scoped guns and binoculars.

	var/contained_sprite = FALSE //TRUE if object icon and related mob overlays are all in one dmi

	var/icon_override  //Used to override hardcoded clothing dmis in human clothing proc.

	//** These specify item/icon overrides for _slots_

	var/list/item_state_slots = list() //overrides the default item_state for particular slots.

	// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in question.
	// Only slot_l_hand/slot_r_hand are implemented at the moment. Others to be implemented as needed.
	var/list/item_icons = list()

	// HUD action buttons. Only used by guns atm.
	var/list/hud_actions

	//Damage vars
	var/force = 0	//How much damage the weapon deals
	var/embed_mult = 1 //Multiplier for the chance of embedding in mobs. Set to zero to completely disable embedding
	var/structure_damage_factor = STRUCTURE_DAMAGE_NORMAL	//Multiplier applied to the damage when attacking structures and machinery
	//Does not affect damage dealt to mobs
	var/style = STYLE_NONE // how much using this item increases your style

	var/list/item_upgrades = list()
	var/max_upgrades = 3

	var/can_use_lying = 0

	var/chameleon_type


/obj/item/Initialize()
	if(islist(armor))
		armor = getArmor(arglist(armor))
	else if(!armor)
		armor = getArmor()
	else if(!istype(armor, /datum/armor))
		error("Invalid type [armor.type] found in .armor during /obj Initialize()")
	if(chameleon_type)
		verbs.Add(/obj/item/proc/set_chameleon_appearance)
	. = ..()

/obj/item/Destroy(force)
	// This var exists as a weird proxy "owner" ref
	// It's used in a few places. Stop using it, and optimially replace all uses please
	master = null
	if(ismob(loc))
		var/mob/m = loc
		m.u_equip(src)
		remove_hud_actions(m)
		loc = null

	QDEL_NULL(hidden_uplink)
	blood_overlay = null
	QDEL_NULL(action)
	if(hud_actions)
		for(var/action in hud_actions)
			qdel(action)
		hud_actions = null

	return ..()

/obj/item/get_fall_damage()
	return w_class * 2

/obj/item/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		qdel(src)

/obj/item/explosion_act(target_power, explosion_handler/handler)
	take_damage(target_power)
	return 0

/obj/item/emp_act(severity)
	if(chameleon_type)
		name = initial(name)
		desc = initial(desc)
		icon = initial(icon)
		icon_state = initial(icon_state)
		update_icon()
		update_wear_icon()

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = loc

	loc = null

	loc = T

/obj/item/examine(user, distance = -1)
	var/message
	var/size
	switch(w_class)
		if(ITEM_SIZE_TINY)
			size = "tiny"
		if(ITEM_SIZE_SMALL)
			size = "small"
		if(ITEM_SIZE_NORMAL)
			size = "normal-sized"
		if(ITEM_SIZE_BULKY)
			size = "bulky"
		if(ITEM_SIZE_HUGE)
			size = "huge"
		if(ITEM_SIZE_GARGANTUAN)
			size = "gargantuan"
		if(ITEM_SIZE_COLOSSAL)
			size = "colossal"
		if(ITEM_SIZE_TITANIC)
			size = "titanic"
	message += "\nIt is a [size] item."

	for(var/Q in tool_qualities)
		message += "\n<blue>It possesses [tool_qualities[Q]] tier of [Q] quality.<blue>"

	. = ..(user, distance, "", message)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.stats.getPerk(PERK_MARKET_PROF))
			to_chat(user,SPAN_NOTICE("Export value: [get_item_cost() * SStrade.get_export_price_multiplier(src)][CREDITS]"))

			var/offer_message = "This item is requested at: "
			var/has_offers = FALSE
			for(var/datum/trade_station/TS in SStrade.discovered_stations)
				for(var/path in TS.special_offers)
					if(istype(src, path))
						has_offers = TRUE
						var/list/offer_content = TS.special_offers[path]
						var/offer_price = offer_content["price"]
						var/offer_amount = offer_content["amount"]
						if(offer_amount)
							offer_message += "[TS.name] ([round(offer_price / offer_amount, 1)][CREDITS] each, [offer_amount] requested), "
						else
							offer_message += "[TS.name] (offer fulfilled, awaiting new contract), "

			if(has_offers)
				offer_message = copytext(offer_message, 1, LAZYLEN(offer_message) - 1)
				to_chat(user, SPAN_NOTICE(offer_message))

/obj/item/attack_hand(mob/user as mob)
	if(pre_pickup(user))
		pickup(user)
		return TRUE
	return FALSE

//	Places item in active hand and invokes pickup animation
//	NOTE: This proc was created and replaced previous pickup() proc which is now called pre_pickup() as it makes more sense
//	keep that in mind when porting items form other builds
/obj/item/proc/pickup(mob/target)
	throwing = 0
	var/atom/old_loc = loc
	if(target.put_in_active_hand(src) && old_loc )
		if((target != old_loc) && (target != old_loc.get_holding_mob()))
			do_pickup_animation(target,old_loc)
		SEND_SIGNAL_OLD(src, COMSIG_ITEM_PICKED, src, target)
	add_hud_actions(target)

/obj/item/attack_ai(mob/user as mob)
	if(istype(loc, /obj/item/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
	//R.hud_used.update_robot_modules_display()

/obj/item/proc/talk_into(mob/living/M, message, channel, verb = "says", datum/language/speaking = null, speech_volume)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

// Called whenever an object is moved out of a mob's equip slot. Possibly into another slot, possibly to elsewhere
// Linker proc: mob/proc/prepare_for_slotmove, which is referenced in proc/handle_item_insertion and obj/item/attack_hand.
// This exists so that dropped() could exclusively be called when an item is dropped.
/obj/item/proc/on_slotmove(mob/user)
	if(wielded)
		unwield(user)
	if(zoom)
		zoom(user)
	if(get_equip_slot() in unworn_slots)
		SEND_SIGNAL_OLD(src, COMSIG_CLOTH_DROPPED, user)
		if(user)
			SEND_SIGNAL_OLD(user, COMSIG_CLOTH_DROPPED, src)


//	Called before an item is picked up (loc is not yet changed)
//	NOTE: This proc name was changed form pickup() as it makes more sense
//	keep that in mind when porting items form other builds
/obj/item/proc/pre_pickup(mob/user)
	return TRUE

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/the_storage)
	SEND_SIGNAL(the_storage, COMSIG_STORAGE_TAKEN, src)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/the_storage)
	SEND_SIGNAL(the_storage, COMSIG_STORAGE_INSERTED, src, the_storage)
	//SEND_SIGNAL(src, COMSIG_ATOM_CONTAINERED, the_storage.getContainingMovable())
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return
/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!usr) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if(!iscarbon(usr) || isbrain(usr))//Is humanoid, and is not a brain
		to_chat(usr, SPAN_WARNING("You can't pick things up!"))
		return
	if( usr.stat || usr.restrained() )//Is not asleep/dead and is not restrained
		to_chat(usr, SPAN_WARNING("You can't pick things up!"))
		return
	if(anchored) //Object isn't anchored
		to_chat(usr, SPAN_WARNING("You can't pick that up!"))
		return
	if(!usr.hand && usr.r_hand) //Right hand is not full
		to_chat(usr, SPAN_WARNING("Your right hand is full."))
		return
	if(usr.hand && usr.l_hand) //Left hand is not full
		to_chat(usr, SPAN_WARNING("Your left hand is full."))
		return
	if(!istype(loc, /turf)) //Object is on a turf
		to_chat(usr, SPAN_WARNING("You can't pick that up!"))
		return
	//All checks are done, time to pick it up!
	usr.UnarmedAttack(src)


//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click(mob/living/user, action_name)
	attack_self(usr)

//RETURN VALUES
//handle_shield should return a positive value to indicate that the attack is blocked and should be prevented.
//If a negative value is returned, it should be treated as a special return value for bullet_act() and handled appropriately.
//For non-projectile attacks this usually means the attack is blocked.
//Otherwise should return 0 to indicate that the attack is not affected in any way.
/obj/item/proc/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	return 0

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H))
		for(var/obj/item/protection in list(H.head, H.wear_mask, H.glasses))
			if(protection && (protection.body_parts_covered & EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
				return

	if(!M.has_eyes())
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on [M]!"))
		return

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)") //BS12 EDIT ALG

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	add_fingerprint(user)

	if(istype(H))

		var/obj/item/organ/internal/eyes/eyes = H.random_organ_by_process(OP_EYES)

		if(!eyes)
			return

		if(H != user)
			for(var/mob/O in (viewers(M) - user - M))
				O.show_message(SPAN_DANGER("[M] has been stabbed in the eye with [src] by [user]."), 1)
			to_chat(M, SPAN_DANGER("[user] stabs you in the eye with [src]!"))
			to_chat(user, SPAN_DANGER("You stab [M] in the eye with [src]!"))
		else
			user.visible_message( \
				SPAN_DANGER("[user] has stabbed themself with [src]!"), \
				SPAN_DANGER("You stab yourself in the eyes with [src]!") \
			)

		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != DEAD)
				if(BP_IS_ORGANIC(eyes) || BP_IS_ASSISTED(eyes)) //robot eyes bleeding might be a bit silly
					to_chat(M, SPAN_DANGER("Your eyes start to bleed profusely!"))
			if(prob(50))
				if(M.stat != DEAD)
					to_chat(M, SPAN_WARNING("You drop what you're holding and clutch at your eyes!"))
					M.drop_item()
				M.eye_blurry += 10
				M.Paralyse(1)
				M.Weaken(4)
			if(eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, SPAN_WARNING("You go blind!"))
		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		overlays.Remove(blood_overlay)

/obj/item/clothing/gloves/clean_blood()
	.=..()
	transfer_blood = 0

/obj/item/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = 1
		blood_color = COLOR_LUMINOL
		blood_overlay.color = COLOR_LUMINOL
		update_icon()

/obj/item/add_blood(mob/living/carbon/human/M as mob)
	if(!..())
		return 0

	if(istype(src, /obj/item/melee/energy))
		return

	if((flags & NOBLOODY)||(item_flags & NOBLOODY))
		return

	//if we haven't made our blood_overlay already
	if( !blood_overlay )
		generate_blood_overlay()

	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_DNA.len)
		blood_overlay.color = blood_color
		overlays += blood_overlay

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA[M.dna_trace])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna_trace] = M.b_type
	return 1 //we applied blood to the item

var/global/list/items_blood_overlay_by_type = list()
/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	var/image/IMG = items_blood_overlay_by_type[type]
	if(IMG)
		blood_overlay = IMG
	else
		var/icon/ICO = new /icon(icon, icon_state)
		ICO.Blend(new /icon('icons/effects/blood.dmi', rgb(255, 255, 255)), ICON_ADD) // fills the icon_state with white (except where it's transparent)
		ICO.Blend(new /icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY)   // adds blood and the remaining white areas become transparant
		IMG = image("icon" = ICO)
		items_blood_overlay_by_type[type] = IMG
		blood_overlay = IMG

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !I.abstract)
		I.showoff(src)

/mob/living/carbon/verb/spin_in_hand()
	set name = "Spin Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if (istype(I, /obj/item/grab)) // a grab signifies that it's another mob that should be spun
		var/obj/item/grab/inhand_grab = I
		var/mob/living/grabbed = inhand_grab.throw_held()
		if (grabbed)
			if (grabbed.stats.getPerk(PERK_ASS_OF_CONCRETE))
				visible_message(SPAN_WARNING("[src] tries to pick up [grabbed], and fails!"))

			else
				if(ishuman(grabbed)) // irish whip if human(grab special), else spin and force rest
					grabbed.external_recoil(40)
					var/whip_dir = (get_dir(grabbed, src))
					var/moves = 0
					//force move the victim on the attacker's tile so that the whip can be executed
					grabbed.loc = src.loc
					//yeet
					src.set_dir(whip_dir)
					visible_message(SPAN_WARNING("[src] spins and hurls [grabbed] away!"), SPAN_WARNING("You spin and hurl [grabbed] away!"))
					grabbed.update_lying_buckled_and_verb_status()
					unEquip(inhand_grab)
					//move grabbed for three tiles, if glass window/wall/railing encountered, proc interactions and break
					for(moves, moves<=3, ++moves)
						//low damage for walls, medium for windows, fall over for railings
						if(istype(get_step(grabbed, whip_dir), /turf/simulated/wall))
							visible_message(SPAN_WARNING("[grabbed] slams into the wall!"))
							grabbed.damage_through_armor(15, BRUTE, BP_CHEST, ARMOR_MELEE)
							break

						for(var/obj/structure/S in get_step(grabbed, whip_dir))
							if(istype(S, /obj/structure/window))
								visible_message(SPAN_WARNING("[grabbed] slams into \the [S]!"))
								grabbed.damage_through_armor(25, BRUTE, BP_CHEST, ARMOR_MELEE)

								moves = 3
								break
							if(istype(S, /obj/structure/railing))
								visible_message(SPAN_WARNING("[grabbed] falls over \the [S]!"))
								grabbed.forceMove(get_step(grabbed, whip_dir))

								moves = 3
								break
							if(istype(S, /obj/structure/table))
								visible_message(SPAN_WARNING("[grabbed] falls on \the [S]!"))
								grabbed.forceMove(get_step(grabbed, whip_dir))
								grabbed.Weaken(5)

								moves = 3
								break
						step_glide(grabbed, whip_dir,(DELAY2GLIDESIZE(0.2 SECONDS)))//very fast

					//admin messaging
					src.attack_log += text("\[[time_stamp()]\] <font color='red'>Irish-whipped [grabbed.name] ([grabbed.ckey])</font>")
					grabbed.attack_log += text("\[[time_stamp()]\] <font color='orange'>Irish-whipped by [src.name] ([src.ckey])</font>")
				else
					visible_message(SPAN_WARNING("[src] picks up, spins, and drops [grabbed]."), SPAN_WARNING("You pick up, spin, and drop [grabbed]."))
					grabbed.Weaken(1)
					grabbed.resting = TRUE
					grabbed.update_lying_buckled_and_verb_status()
					unEquip(inhand_grab)
		else
			to_chat(src, SPAN_WARNING("You do not have a firm enough grip to forcibly spin [inhand_grab.affecting]."))

	else if (I && !I.abstract && I.mob_can_unequip(src, get_active_hand_slot())) // being unable to unequip normally means
		I.SpinAnimation(5,1) // that the item is stuck on or in, and so cannot spin
		external_recoil(50)
		visible_message("[src] spins [I.name] in \his hand.") // had to mess with the macros a bit to get
		if (recoil > 60) // the text to work, which is why "a" is not included
			visible_message(SPAN_WARNING("[I] flies out of [src]\'s hand!"))
			unEquip(I)
			return
		I.hand_spin(src)

/obj/item/proc/hand_spin(mob/living/carbon/caller) // used for custom behaviour on the above proc
	return

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
//Looking through a scope or binoculars should /not/ improve your periphereal vision. Still, increase viewsize a tiny bit so that sniping isn't as restricted to NSEW
/obj/item/proc/zoom(tileoffset = 14,viewsize = 9, stayzoomed = FALSE) //tileoffset is client view offset in the direction the user is facing. viewsize is how far out this thing zooms. 7 is normal view
	if(!usr)
		return

	var/devicename

	if(zoomdevicename)
		devicename = zoomdevicename
	else
		devicename = name

	var/cannotzoom

	if(usr.stat || !(ishuman(usr)))
		to_chat(usr, "You are unable to focus through the [devicename]")
		cannotzoom = 1
	else if(!zoom && (global_hud.darkMask[1] in usr.client.screen))
		to_chat(usr, "Your visor gets in the way of looking through the [devicename]")
		cannotzoom = 1
	else if(!zoom && usr.get_active_hand() != src)
		to_chat(usr, "You are too distracted to look through the [devicename]. Perhaps if it was in your active hand you could look through it.")
		cannotzoom = 1

	if((!zoom && !cannotzoom)|stayzoomed)
		//if(usr.hud_used.hud_shown)
			//usr.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		usr.client.view = viewsize
		zoom = 1

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(usr.dir)
			if(NORTH)
				usr.client.pixel_x = 0
				usr.client.pixel_y = viewoffset
			if(SOUTH)
				usr.client.pixel_x = 0
				usr.client.pixel_y = -viewoffset
			if(EAST)
				usr.client.pixel_x = viewoffset
				usr.client.pixel_y = 0
			if(WEST)
				usr.client.pixel_x = -viewoffset
				usr.client.pixel_y = 0
		if(!stayzoomed)
			usr.visible_message("[usr] peers through the [zoomdevicename ? "[zoomdevicename] of the [name]" : "[name]"].")
		var/mob/living/carbon/human/H = usr
		H.using_scope = src
	else
		usr.client.view = world.view
		//if(!usr.hud_used.hud_shown)
			//usr.toggle_zoom_hud()
		zoom = 0

		usr.client.pixel_x = 0
		usr.client.pixel_y = 0

		if(!cannotzoom)
			usr.visible_message("[zoomdevicename ? "[usr] looks up from the [name]" : "[usr] lowers the [name]"].")
		var/mob/living/carbon/human/H = usr
		H.using_scope = null
	usr.parallax.update()
	return

/obj/item/proc/pwr_drain()
	return 0 // Process Kill


//Called when a human swaps hands to a hand which is holding this item
/obj/item/proc/swapped_to(mob/user)
	add_hud_actions(user)

//Called when a human swaps hands away from a hand which is holding this item
/obj/item/proc/swapped_from(mob/user)
	remove_hud_actions(user)

/obj/item/proc/add_hud_actions(mob/user)
	if(!hud_actions || !user.client)
		return

	update_hud_actions()

	for(var/action in hud_actions)
		user.client.screen |= action

/obj/item/proc/remove_hud_actions(mob/user)
	if(!user)
		return
	if(!hud_actions || !user.client)
		return

	for(var/action in hud_actions)
		user.client.screen -= action

/obj/item/proc/update_hud_actions()
	if(!hud_actions)
		return

	for(var/A in hud_actions)
		var/obj/item/action = A
		action.update_icon()

/obj/item/proc/refresh_upgrades()
	return

/obj/item/proc/on_embed(mob/user)
	return

/obj/item/proc/on_embed_removal(mob/living/user)
	return

/obj/item/proc/get_style()
	return style
