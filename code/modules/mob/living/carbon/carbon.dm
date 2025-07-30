/mob/living/carbon/Initialize()
	//setup reagent holders
	bloodstr = new /datum/reagents/metabolism(1000, src, CHEM_BLOOD)
	ingested = new /datum/reagents/metabolism(1000, src, CHEM_INGEST)
	touching = new /datum/reagents/metabolism(1000, src, CHEM_TOUCH)
	metabolism_effects = new /datum/metabolism_effects(src)
	reagents = bloodstr
	..()

/mob/living/carbon/Destroy()
	QDEL_NULL(metabolism_effects)
	reagents = null
	QDEL_NULL(ingested)
	QDEL_NULL(touching)
	QDEL_NULL(bloodstr)
	QDEL_NULL(vessel)
	QDEL_LIST(internal_organs)
	QDEL_LIST(stomach_contents)
	QDEL_LIST(hallucinations)
	return ..()

/mob/living/carbon/rejuvenate()
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	metabolism_effects.clear_effects()
	nutrition = 400
	shock_stage = 0
	..()

/mob/living/carbon/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	. = ..()
	if(.)
		if (src.nutrition && src.stat != 2)
			src.adjustNutrition(-DEFAULT_HUNGER_FACTOR/10)
			if (move_intent.flags & MOVE_INTENT_EXERTIVE)
				src.adjustNutrition(-DEFAULT_HUNGER_FACTOR/10)

		if(is_watching == TRUE)
			reset_view(null)
			is_watching = FALSE

/mob/living/carbon/relaymove(mob/living/user, direction)
	if((user in src.stomach_contents) && istype(user))
		if(user.last_special <= world.time)
			user.last_special = world.time + 50
			src.visible_message(span_danger("You hear something rumbling inside [src]'s stomach..."))
			var/obj/item/I = user.get_active_held_item()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/organ = H.get_organ(BP_CHEST)
					if (istype(organ))
						if(organ.take_damage(d, BRUTE))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				user.visible_message(span_danger("[user] attacks [src]'s stomach wall with the [I.name]!"))
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()

/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(get_turf(src)))
			if(N.client)
				N.show_message(span_red("<B>[M] bursts out of [src]!</B>"), 2)
	..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_ARM]
		if (H.hand)
			temp = H.organs_by_name[BP_L_ARM]
		if(temp && !temp.is_usable())
			to_chat(H, span_red("You can't use your [temp.name]"))
			return


/mob/living/carbon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")
	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			span_red("[src] was shocked by the [source]!"), \
			span_red("<B>You feel a powerful shock course through your body!</B>"), \
			span_red("You hear a heavy electrical crack.") \
		)
		SEND_SIGNAL_OLD(src, COMSIG_CARBON_ELECTROCTE)
		Weaken(max(min(10,round(shock_damage / 10 )), 2) SECONDS)
	else
		src.visible_message(
			span_red("[src] was mildly shocked by the [source]."), \
			span_red("You feel a mild shock course through your body."), \
			span_red("You hear a light zapping.") \
		)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage

/mob/living/carbon/swap_hand()

	//We cache the held items before and after swapping using get active hand.
	//This approach is future proof and will support people who possibly have >2 hands
	var/obj/item/prev_held = get_active_held_item()

	if(prev_held)
		if(prev_held.wielded)
			prev_held.unwield(src)

	//Now we do the hand swapping
	src.hand = !( src.hand )
	for (var/obj/screen/inventory/hand/H in src.HUDinventory)
		H.update_icon()

	var/obj/item/new_held = get_active_held_item()

	//Tell the old and new held items that they've been swapped

	if (prev_held != new_held)
		if (istype(prev_held))
			prev_held.swapped_from(src)
		if (istype(new_held))
			new_held.swapped_to(src)

	return TRUE

/mob/living/carbon/proc/activate_hand(selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if (src.health >= CONFIG_GET(number/health_threshold_crit))
		if(src == M && ishuman(src))
			var/mob/living/carbon/human/H = src
			H.check_self_for_injuries()
		else if (on_fire)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if (M.on_fire)
				M.visible_message(span_warning("[M] tries to pat out [src]'s flames, but to no avail!"),
				span_warning("You try to pat out [src]'s flames, but to no avail! Put yourself out first!"))
			else
				M.visible_message(span_warning("[M] tries to pat out [src]'s flames!"),
				span_warning("You try to pat out [src]'s flames! Hot!"))
				if(do_mob(M, src, 15))
					src.fire_stacks -= 0.5
					if (prob(10) && (M.fire_stacks <= 0))
						M.fire_stacks += 1
					M.IgniteMob()
					if (M.on_fire)
						M.visible_message(span_danger("The fire spreads from [src] to [M]!"),
						span_danger("The fire spreads to you as well!"))
					else
						src.fire_stacks -= 0.5 //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
						if (src.fire_stacks <= 0)
							M.visible_message(span_warning("[M] successfully pats out [src]'s flames."),
							span_warning("You successfully pat out [src]'s flames."))
							src.ExtinguishMob()
							src.fire_stacks = 0
		else
			var/t_him = "it"
			if (src.gender == MALE)
				t_him = "him"
			else if (src.gender == FEMALE)
				t_him = "her"
			if (ishuman(src) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/target_organ_exists = FALSE
			var/mob/living/carbon/human/H = src
			if(istype(H))
				show_ssd = H.species.show_ssd
				var/obj/item/organ/external/O = H.get_organ(M.targeted_organ)
				target_organ_exists = (O && O.is_usable())
			if(show_ssd && !client && !teleop)
				M.visible_message(span_notice("[M] shakes [src] trying to wake [t_him] up!"), \
				span_notice("You shake [src], but they do not respond... Maybe they have S.S.D?"))
				jiggle()
			else if(lying || src.sleeping)
				src.sleeping = max(0,src.sleeping-5)
				if(src.sleeping == 0)
					src.resting = 0
				M.visible_message(span_notice("[M] shakes [src] trying to wake [t_him] up!"), \
									span_notice("You shake [src] trying to wake [t_him] up!"))
				jiggle()
			else if((M.targeted_organ == BP_HEAD) && target_organ_exists)
				M.visible_message(span_notice("[M] pats [src]'s head."), \
									span_notice("You pat [src]'s head."))
			else if(M.targeted_organ == BP_R_ARM || M.targeted_organ == BP_L_ARM)
				if(target_organ_exists)
					M.visible_message(span_notice("[M] shakes hands with [src]."), \
										span_notice("You shake hands with [src]."))
					animate_interact(src, INTERACT_GENERIC)
				else
					M.visible_message(span_notice("[M] holds out \his hand to [src]."), \
										span_notice("You hold out your hand to [src]."))
			else
				var/mob/living/carbon/human/hugger = M
				if(istype(hugger))
					hugger.species.hug(hugger,src)
				else
					M.visible_message(span_notice("[M] hugs [src] to make [t_him] feel better!"), \
								span_notice("You hug [src] to make [t_him] feel better!"))
					animate_interact(src, INTERACT_HELP)
				if(M.fire_stacks >= (src.fire_stacks + 3))
					src.fire_stacks += 1
					M.fire_stacks -= 1
				if(M.on_fire)
					src.IgniteMob()
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/proc/eyecheck()
	return 0

/mob/living/carbon/proc/earcheck()
	return 0

/mob/living/carbon/flash(duration = 0, drop_items = FALSE, doblind = FALSE, doblurry = FALSE)
	if(blinded)
		return
	if(species)
		..(duration * species.flash_mod, drop_items, doblind, doblurry)
	else
		..(duration, drop_items, doblind, doblurry)
//Throwing stuff
/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	src.throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /obj/screen) return

	var/atom/movable/item = src.get_active_held_item()

	if(!item) return

	if(istype(item, /obj/item/stack/thrown))
		var/obj/item/stack/thrown/V = item
		V.fireAt(target, src)
		return

	if (istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(!item) return
		unEquip(G, loc)
		if(ismob(item))
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been thrown by [usr.name] ([usr.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
				msg_admin_attack("[usr.name] ([usr.ckey]) has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor] [ADMIN_JMP(usr)]")
				item.throw_at(target, item.throw_range, item.throw_speed, src)
				return

	//Grab processing has a chance of returning null
	if(item)
		if((target.z > src.z) && istype(get_turf(GetAbove(src)), /turf/open))
			var/obj/item/I = item
			var/robust = stats.getStat(STAT_ROB)
			var/timer = ((5 * I.w_class) - (robust * 0.1)) //(W_CLASS * 5) - (STR * 0.1)
			visible_message(span_danger("[src] is trying to toss \the [item] into the air!"))
			if((I.w_class < ITEM_SIZE_GARGANTUAN) && do_after(src, timer))
				item.throwing = TRUE
				unEquip(item, loc)
				item.forceMove(get_turf(GetAbove(src)))
			else
				to_chat(src, span_warning("You were interrupted!"))
				return
		visible_message(span_danger("[src] has thrown [item]."))
		if(incorporeal_move)
			inertia_dir = 0
		else if(!check_gravity() && !src.allow_spacemove()) // spacemove would return one with magboots, -1 with adjacent tiles
			inertia_dir = get_dir(target, src)
			step(src, inertia_dir)

		unEquip(item, loc)
		item.throw_at(target, item.throw_range, item.throw_speed, src)

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()

	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
	 ..()

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		to_chat(usr, span_red("You are already sleeping"))
		return
	if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
		usr.sleeping = 20 //Short nap

/mob/living/carbon/Bump(atom/movable/AM, yes)
	if(now_pushing || !yes)
		return
	..()

/mob/living/carbon/cannot_use_vents()
	return

/mob/living/carbon/slip(slipped_on,stun_duration=8)
	if(buckled)
		return FALSE
	stop_pulling()
	if (slipped_on)
		to_chat(src, span_warning("You slipped on [slipped_on]!"))
		playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	Weaken(stun_duration)

	return TRUE

/mob/living/carbon/proc/add_chemical_effect(effect, magnitude = 1)
	if(effect == CE_ALCOHOL)
		if(stats.getPerk(/datum/perk/inspiration))
			stats.addPerk(/datum/perk/active_inspiration)
		if(stats.getPerk(PERK_ALCOHOLIC))
			stats.addPerk(PERK_ALCOHOLIC_ACTIVE)
	if(effect in chem_effects)
		chem_effects[effect] += magnitude
	else
		chem_effects[effect] = magnitude

/mob/living/carbon/get_default_language()
	if(default_language)
		return default_language

	if(!species)
		return null
	return species.default_language ? GLOB.all_languages[species.default_language] : null

/mob/living/carbon/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='byond://?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='byond://?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='byond://?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='byond://?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='byond://?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='byond://?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='byond://?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='byond://?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='byond://?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
// hi nerd
	var/datum/browser/panel = new(user, "mob[name]", "Mob", 325, 400)
	panel.set_content(dat)
	panel.open()

/mob/living/carbon/proc/should_have_process(organ_check)
	return 0

/mob/living/carbon/proc/has_appendage(limb_check)
	return 0

/mob/living/carbon/proc/need_breathe()
	return TRUE

/mob/living/carbon/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", VV_HK_SPACER)
	VV_DROPDOWN_OPTION(VV_HK_MAKE_ROBOT, "Make Robot")
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_ORGANS, "Modify Oranges")

/mob/living/carbon/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_MODIFY_ORGANS] && check_rights(R_FUN))
		var/organoption = input(usr, "What do you want to do?", "Modify Organs", null) as null|anything in list("Add Organ", "Remove Organ")

		if(isnull(organoption))
			return
		if (organoption == "Add Organ")
			var/new_organ = input("Please choose an organ to add.","Organ",null) as null|anything in typesof(/obj/item/organ)-/obj/item/organ
			if(!new_organ) return

			if(locate(new_organ) in src.internal_organs)
				to_chat(usr, "Mob already has that organ.")
				return

			new new_organ(src)
		if (organoption == "Remove Organ")
			var/obj/item/organ/rem_organ = input("Please choose an organ to remove.","Organ",null) as null|anything in src.internal_organs

			if(!(locate(rem_organ) in src.internal_organs))
				to_chat(usr, "Mob does not have that organ.")
				return

			to_chat(usr, "Removed [rem_organ] from [src].")
			rem_organ.removed()
			qdel(rem_organ)
