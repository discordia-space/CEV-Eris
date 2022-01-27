/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	w_class = ITEM_SIZE_NORMAL

	//spawn_values
	price_tag = 0
	//spawn_tags = SPAWN_TAG_ITEM
	rarity_value = 10
	spawn_fre69uency = 10
	bad_type = /obj/item

	pass_flags = PASSTABLE
	var/image/blood_overlay //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6
	var/abstract = 0
	var/r_speed = 1
	var/health
	var/max_health
	var/burn_point
	var/burning
	var/hitsound = 'sound/weapons/genhit1.ogg'
	var/worksound
	var/no_attack_log = 0			//If it's an item we don't want to log attack_logs with, set this to 1

	var/obj/item/master
	var/list/origin_tech = list()	//Used by R&D to determine what research bonuses it grants.
	var/list/attack_verb = list() //Used in attackby() to say how something was attacked "69x69 has been 69z.attack_verb69 by 69y69 with 69z69"


	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this69ariable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this69ariable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/datum/action/item_action/action
	var/action_button_name //It is also the text which gets displayed on the action button. If not set it defaults to 'Use 69name69'. If it's not set, there'll be no button.
	var/action_button_is_hands_free = 0 //If 1, bypass the restrained, lying, and stunned checks action buttons normally test for

	//This flag is used to determine when items in someone's inventory cover others. IE helmets69aking it so you can't see glasses, etc.
	//It should be used purely for appearance. For gameplay effects caused by items covering body parts, use body_parts_covered.
	var/flags_inv = 0
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/list/tool_69ualities// List of item 69ualities for tools system. See 69ualities.dm.
	var/list/aspects = list()

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to69ask and69ice-versa (for69asks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How69uch clothing is slowing you down. Negative69alues speeds you up
	var/slowdown_hold // How69uch holding an item slows you down.
	var/stiffness = 0 // How69uch recoil is caused by69oving
	var/obscuration = 0 // How69uch firearm accuracy is decreased

	var/datum/armor/armor // Ref to the armor datum
	var/list/allowed = list() //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink // All items can have an uplink hidden inside, just remember to add the triggers.
	var/zoomdevicename //name used for69essage when binoculars/scope is used
	var/zoom = 0 //1 if item is actively being used to zoom. For scoped guns and binoculars.

	var/contained_sprite = FALSE //TRUE if object icon and related69ob overlays are all in one dmi

	var/icon_override  //Used to override hardcoded clothing dmis in human clothing proc.

	//** These specify item/icon overrides for _slots_

	var/list/item_state_slots = list() //overrides the default item_state for particular slots.

	// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in 69uestion.
	// Only slot_l_hand/slot_r_hand are implemented at the69oment. Others to be implemented as needed.
	var/list/item_icons = list()

	// HUD action buttons. Only used by guns atm.
	var/list/hud_actions

	//Damage69ars
	var/force = 0	//How69uch damage the weapon deals
	var/embed_mult = 0.5 //Multiplier for the chance of embedding in69obs. Set to zero to completely disable embedding
	var/structure_damage_factor = STRUCTURE_DAMAGE_NORMAL	//Multiplier applied to the damage when attacking structures and69achinery
	//Does not affect damage dealt to69obs
	var/style = STYLE_NONE // how69uch using this item increases your style

	var/list/item_upgrades = list()
	var/max_upgrades = 3

	var/can_use_lying = 0

/obj/item/Initialize()
	if(islist(armor))
		armor = getArmor(arglist(armor))
	else if(!armor)
		armor = getArmor()
	else if(!istype(armor, /datum/armor))
		error("Invalid type 69armor.type69 found in .armor during /obj Initialize()")
	. = ..()

/obj/item/Destroy()
	69DEL_NULL(hidden_uplink)
	69DEL_NULL(blood_overlay)
	69DEL_NULL(action)
	if(ismob(loc))
		var/mob/m = loc
		m.u_e69uip(src)
		remove_hud_actions(m)
		loc = null
	if(hud_actions)
		for(var/action in hud_actions)
			69del(action)
		hud_actions = null

	return ..()

/obj/item/get_fall_damage()
	return w_class * 2

/obj/item/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if(prob(50))
				69del(src)
		if(3)
			if(prob(5))
				69del(src)

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
	message += "\nIt is a 69size69 item."

	for(var/69 in tool_69ualities)
		message += "\n<blue>It possesses 69tool_69ualities69696969 tier of 696969 69uality.<blue>"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.stats.getPerk(PERK_MARKET_PROF))
			message += SPAN_NOTICE("\nThis item cost: 69get_item_cost()6969CREDITS69")

	return ..(user, distance, "",69essage)

/obj/item/attack_hand(mob/user as69ob)
	if(pre_pickup(user))
		pickup(user)
		return TRUE
	return FALSE

//	Places item in active hand and invokes pickup animation
//	NOTE: This proc was created and replaced previous pickup() proc which is now called pre_pickup() as it69akes69ore sense
//	keep that in69ind when porting items form other builds
/obj/item/proc/pickup(mob/target)
	throwing = 0
	var/atom/old_loc = loc
	if(target.put_in_active_hand(src) && old_loc )
		if((target != old_loc) && (target != old_loc.get_holding_mob()))
			do_pickup_animation(target,old_loc)
		SEND_SIGNAL(src, COMSIG_ITEM_PICKED, src, target)
	add_hud_actions(target)

/obj/item/attack_ai(mob/user as69ob)
	if(istype(loc, /obj/item/robot_module))
		//If the item is part of a cyborg69odule, e69uip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
	//R.hud_used.update_robot_modules_display()

/obj/item/proc/talk_into(mob/living/M,69essage, channel,69erb = "says", datum/language/speaking = null, speech_volume)
	return

/obj/item/proc/moved(mob/user as69ob, old_loc as turf)
	return

// Called whenever an object is69oved out of a69ob's e69uip slot. Possibly into another slot, possibly to elsewhere
// Linker proc:69ob/proc/prepare_for_slotmove, which is referenced in proc/handle_item_insertion and obj/item/attack_hand.
// This exists so that dropped() could exclusively be called when an item is dropped.
/obj/item/proc/on_slotmove(mob/user)
	if(wielded)
		unwield(user)
	if(zoom)
		zoom(user)
	if(get_e69uip_slot() in unworn_slots)
		SEND_SIGNAL(src, COMSIG_CLOTH_DROPPED, user)
		if(user)
			SEND_SIGNAL(user, COMSIG_CLOTH_DROPPED, src)


//	Called before an item is picked up (loc is not yet changed)
//	NOTE: This proc name was changed form pickup() as it69akes69ore sense
//	keep that in69ind when porting items form other builds
/obj/item/proc/pre_pickup(mob/user)
	return TRUE

// called when this item is removed from a storage item, which is passed on as S. The loc69ariable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/the_storage)
	SEND_SIGNAL(the_storage, COMSIG_STORAGE_TAKEN, src, the_storage)
	return

// called when this item is added into a storage item, which is passed on as S. The loc69ariable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/the_storage)
	SEND_SIGNAL(the_storage, COMSIG_STORAGE_INSERTED, src, the_storage)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as69ob)
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


//This proc is executed when someone clicks the on-screen UI button. To69ake the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are:69ob is alive,69ob is not restrained, paralyzed, asleep, resting, laying, item is on the69ob.
/obj/item/proc/ui_action_click(mob/living/user, action_name)
	attack_self(usr)

//RETURN69ALUES
//handle_shield should return a positive69alue to indicate that the attack is blocked and should be prevented.
//If a negative69alue is returned, it should be treated as a special return69alue for bullet_act() and handled appropriately.
//For non-projectile attacks this usually69eans the attack is blocked.
//Otherwise should return 0 to indicate that the attack is not affected in any way.
/obj/item/proc/handle_shield(mob/user, damage, atom/damage_source = null,69ob/attacker = null, def_zone = null, attack_text = "the attack")
	return 0

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc

/obj/item/proc/eyestab(mob/living/carbon/M as69ob,69ob/living/carbon/user as69ob)

	var/mob/living/carbon/human/H =69
	if(istype(H))
		for(var/obj/item/protection in list(H.head, H.wear_mask, H.glasses))
			if(protection && (protection.body_parts_covered & EYES))
				// you can't stab someone in the eyes wearing a69ask!
				to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
				return

	if(!M.has_eyes())
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on 69M69!"))
		return

	user.attack_log += "\6969time_stamp()69\69<font color='red'> Attacked 69M.name69 (69M.ckey69) with 69name69 (INTENT: 69uppertext(user.a_intent)69)</font>"
	M.attack_log += "\6969time_stamp()69\69<font color='orange'> Attacked by 69user.name69 (69user.ckey69) with 69name69 (INTENT: 69uppertext(user.a_intent)69)</font>"
	msg_admin_attack("69user.name69 (69user.ckey69) attacked 69M.name69 (69M.ckey69) with 69name69 (INTENT: 69uppertext(user.a_intent)69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)") //BS12 EDIT ALG

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		to_chat(M, SPAN_WARNING("You stab yourself in the eye."))
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/

	if(istype(H))

		var/obj/item/organ/internal/eyes/eyes = H.random_organ_by_process(OP_EYES)

		if(!eyes)
			return

		if(H != user)
			for(var/mob/O in (viewers(M) - user -69))
				O.show_message(SPAN_DANGER("69M69 has been stabbed in the eye with 69src69 by 69user69."), 1)
			to_chat(M, SPAN_DANGER("69user69 stabs you in the eye with 69src69!"))
			to_chat(user, SPAN_DANGER("You stab 69M69 in the eye with 69src69!"))
		else
			user.visible_message( \
				SPAN_DANGER("69user69 has stabbed themself with 69src69!"), \
				SPAN_DANGER("You stab yourself in the eyes with 69src69!") \
			)

		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != DEAD)
				if(BP_IS_ORGANIC(eyes) || BP_IS_ASSISTED(eyes)) //robot eyes bleeding69ight be a bit silly
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

/obj/item/add_blood(mob/living/carbon/human/M as69ob)
	if(!..())
		return 0

	if(istype(src, /obj/item/melee/energy))
		return

	if((flags & NOBLOODY)||(item_flags & NOBLOODY))
		return

	//if we haven't69ade our blood_overlay already
	if( !blood_overlay )
		generate_blood_overlay()

	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_DNA.len)
		blood_overlay.color = blood_color
		overlays += blood_overlay

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA69M.dna.uni69ue_enzymes69)
			return 0 //already bloodied with this blood. Cannot add69ore.
		blood_DNA69M.dna.uni69ue_enzymes69 =69.dna.b_type
	return 1 //we applied blood to the item

var/global/list/items_blood_overlay_by_type = list()
/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	var/image/IMG = items_blood_overlay_by_type69type69
	if(IMG)
		blood_overlay = IMG
	else
		var/icon/ICO = new /icon(icon, icon_state)
		ICO.Blend(new /icon('icons/effects/blood.dmi', rgb(255, 255, 255)), ICON_ADD) // fills the icon_state with white (except where it's transparent)
		ICO.Blend(new /icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY)   // adds blood and the remaining white areas become transparant
		IMG = image("icon" = ICO)
		items_blood_overlay_by_type69type69 = IMG
		blood_overlay = IMG

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in69iew(user))
		M.show_message("69user69 holds up 69src69. <a HREF=?src=\ref69M69;lookitem=\ref69src69>Take a closer look.</a>",1)

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
	if (istype(I, /obj/item/grab)) // a grab signifies that it's another69ob that should be spun
		var/obj/item/grab/inhand_grab = I
		var/mob/living/grabbed = inhand_grab.throw_held()
		if (a_intent == I_HELP && inhand_grab.affecting.a_intent == I_HELP) // this doesn't use grabbed to allow passive twirl
			visible_message(SPAN_NOTICE("69src69 twirls 69inhand_grab.affecting69."), SPAN_NOTICE("You twirl 69inhand_grab.affecting69."))
		else if (grabbed)
			if (grabbed.stats.getPerk(PERK_ASS_OF_CONCRETE))
				visible_message(SPAN_WARNING("69src69 tries to pick up 69grabbed69, and fails!"))
				if (ishuman(src))
					var/mob/living/carbon/human/depleted = src
					depleted.regen_slickness(-1) // unlucky and unobservant gets the penalty
					return
			else
				visible_message(SPAN_WARNING("69src69 picks up, spins, and drops 69grabbed69."), SPAN_WARNING("You pick up, spin, and drop 69grabbed69."))
				grabbed.external_recoil(60)
				grabbed.Weaken(1)
				grabbed.resting = TRUE
				grabbed.update_lying_buckled_and_verb_status()
				unE69uip(inhand_grab)
		else
			to_chat(src, SPAN_WARNING("You do not have a firm enough grip to forcibly spin 69inhand_grab.affecting69."))

	else if (I && !I.abstract && I.mob_can_une69uip(src, get_active_hand_slot())) // being unable to une69uip normally69eans
		I.SpinAnimation(5,1) // that the item is stuck on or in, and so cannot spin
		external_recoil(60)
		visible_message("69src69 spins 69I.name69 in \his hand.") // had to69ess with the69acros a bit to get
		if (recoil > 60) // the text to work, which is why "a" is not included
			visible_message(SPAN_WARNING("69I69 flies out of 69src69\'s hand!"))
			unE69uip(I)
			return
	if (ishuman(src))
		var/mob/living/carbon/human/stylish = src
		stylish.regen_slickness()

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you69ove you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
//Looking through a scope or binoculars should /not/ improve your periphereal69ision. Still, increase69iewsize a tiny bit so that sniping isn't as restricted to NSEW
/obj/item/proc/zoom(tileoffset = 14,viewsize = 9) //tileoffset is client69iew offset in the direction the user is facing.69iewsize is how far out this thing zooms. 7 is normal69iew
	if(!usr)
		return

	var/devicename

	if(zoomdevicename)
		devicename = zoomdevicename
	else
		devicename = name

	var/cannotzoom

	if(usr.stat || !(ishuman(usr)))
		to_chat(usr, "You are unable to focus through the 69devicename69")
		cannotzoom = 1
	else if(!zoom && (global_hud.darkMask69169 in usr.client.screen))
		to_chat(usr, "Your69isor gets in the way of looking through the 69devicename69")
		cannotzoom = 1
	else if(!zoom && usr.get_active_hand() != src)
		to_chat(usr, "You are too distracted to look through the 69devicename69. Perhaps if it was in your active hand you could look through it.")
		cannotzoom = 1

	if(!zoom && !cannotzoom)
		//if(usr.hud_used.hud_shown)
			//usr.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		usr.client.view =69iewsize
		zoom = 1

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(usr.dir)
			if(NORTH)
				usr.client.pixel_x = 0
				usr.client.pixel_y =69iewoffset
			if(SOUTH)
				usr.client.pixel_x = 0
				usr.client.pixel_y = -viewoffset
			if(EAST)
				usr.client.pixel_x =69iewoffset
				usr.client.pixel_y = 0
			if(WEST)
				usr.client.pixel_x = -viewoffset
				usr.client.pixel_y = 0

		usr.visible_message("69usr69 peers through the 69zoomdevicename ? "69zoomdevicename69 of the 69name69" : "69name69"69.")

	else
		usr.client.view = world.view
		//if(!usr.hud_used.hud_shown)
			//usr.toggle_zoom_hud()
		zoom = 0

		usr.client.pixel_x = 0
		usr.client.pixel_y = 0

		if(!cannotzoom)
			usr.visible_message("69zoomdevicename ? "69usr69 looks up from the 69name69" : "69usr69 lowers the 69name69"69.")
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
