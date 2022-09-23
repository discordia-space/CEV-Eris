
/obj/item/grab/proc/inspect_organ(mob/living/carbon/human/H, mob/user, var/target_zone)

	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, SPAN_NOTICE("[H] is missing that bodypart."))
		return

	user.visible_message(SPAN_NOTICE("[user] starts inspecting [affecting]'s [E.name] carefully."))
	if(!do_mob(user,H, 10))
		to_chat(user, SPAN_NOTICE("You must stand still to inspect [E] for wounds."))
	else if(E.wounds.len)
		to_chat(user, SPAN_WARNING("You find [E.get_wounds_desc()]"))
	else
		to_chat(user, SPAN_NOTICE("You find no visible wounds."))
	if(locate(/obj/item/material/shard/shrapnel) in E.implants)
		to_chat(user, SPAN_WARNING("There is what appears to be shrapnel embedded within [affecting]'s [E.name]."))

	to_chat(user, SPAN_NOTICE("Checking bones now..."))
	if(!do_mob(user, H, 20))
		to_chat(user, SPAN_NOTICE("You must stand still to feel [E] for fractures."))
	else if(E.status & ORGAN_BROKEN)
		to_chat(user, "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>")
		H.custom_pain("Your [E.name] hurts where it's poked.")
	else
		to_chat(user, "<span class='notice'>The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.</span>")

	to_chat(user, SPAN_NOTICE("Checking skin now..."))
	if(!do_mob(user, H, 10))
		to_chat(user, SPAN_NOTICE("You must stand still to check [H]'s skin for abnormalities."))
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			to_chat(user, SPAN_WARNING("[H] has an unhealthy skin discoloration."))
			bad = 1
		if(H.getOxyLoss() >= 20)
			to_chat(user, SPAN_WARNING("[H]'s skin is unusually pale."))
			bad = 1
		if(E.status & ORGAN_DEAD)
			to_chat(user, SPAN_WARNING("[E] is decaying!"))
			bad = 1
		if(!bad)
			to_chat(user, SPAN_NOTICE("[H]'s skin is normal."))

/obj/item/grab/proc/slow_bleeding(mob/living/carbon/human/H, mob/user, var/obj/item/organ/external/bodypart)

	if(bodypart.is_stump() || !bodypart)
		to_chat(user, SPAN_WARNING("They are missing that limb!"))
		return
	else
		visible_message(SPAN_WARNING("[user] starts putting pressure on [H]'s wounds to stop the wounds on \his [bodypart.name] from bleeding!"))
		if(!do_mob(user, H, 50))//5 seconds
			to_chat(user, SPAN_NOTICE("You must stand still to stop the bleeding."))
			return
		else
			visible_message(SPAN_NOTICE("[user] finishes putting pressure on [H]'s wounds."))
			for(var/datum/wound/W in bodypart.wounds)
				W.current_stage++
				W.bleed_timer -= 5
	//do not kill the grab


/obj/item/grab/proc/force_vomit(mob/living/carbon/human/target, mob/attacker)
	//no check for grab levels
	attacker.next_move = world.time + 40 //4 seconds, also should prevent user from triggering this repeatedly
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & FACE))
			to_chat(attacker, SPAN_DANGER("You can't induce vomiting while [target]'s mouth is covered."))
			return
	visible_message(SPAN_WARNING("[attacker] places a finger in [target]'s throat, trying to induce vomiting."))//ewwies
	if(do_after(attacker, 40, progress=0) && target)
		//vomiting sets on cd for 35 secs, which means it's impossible to spam this
		target.vomit(TRUE)
		//admin messaging
		attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Induced vomiting [target.name] ([target.ckey])</font>")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Forced to vomit by [attacker.name] ([attacker.ckey])</font>")
		//do not kill the grab

/obj/item/grab/proc/jointlock(mob/living/carbon/human/target, mob/attacker, var/target_zone)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	var/obj/item/organ/external/organ = target.get_organ(check_zone(target_zone))
	if(!organ || organ.nerve_struck == -1)
		return

	if(!do_after(attacker, 7 SECONDS, target))
		to_chat(attacker, SPAN_WARNING("You must stand still to jointlock [target]!"))
	else
		visible_message(SPAN_WARNING("With a forceful twist, [attacker] bents [target]'s [organ.name] into a painful jointlock!"))
		to_chat(target, SPAN_DANGER("You feel extreme pain!"))
		playsound(loc, 'sound/weapons/jointORbonebreak.ogg', 50, 1, -1)
		affecting.adjustHalLoss(rand(30, 40))

/obj/item/grab/proc/attack_eye(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, BP_EYES)

	if(!attack)
		return
	if(state < GRAB_NECK)
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			to_chat(attacker, SPAN_DANGER("You're going to need to remove the eye covering first."))
			return
	if(!target.has_eyes())
		to_chat(attacker, SPAN_DANGER("You cannot locate any eyes on [target]!"))
		return

	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Attacked [target.name]'s eyes using grab ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had eyes attacked by [attacker.name]'s grab ([attacker.ckey])</font>")
	msg_admin_attack("[key_name(attacker)] attacked [key_name(target)]'s eyes using a grab action.")

	attack.handle_eye_attack(attacker, target)

/obj/item/grab/proc/dropkick(mob/living/carbon/target, mob/living/carbon/human/attacker)
	if(state < GRAB_AGGRESSIVE) //blue grab check
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	if(target.lying)
		return
	visible_message(SPAN_DANGER("[attacker] dropkicks [target], pushing \him onwards!"))
	attacker.Weaken(2)
	target.Weaken(6) //the target will fly over tables, railings, etc.
	var/kick_dir = get_dir(attacker, target)
	if(attacker.loc == target.loc) // if we are on the same tile(e.g. neck grab), turn the direction to still push them away
		kick_dir = turn(kick_dir, 180)
	target.throw_at(get_edge_target_turf(target, kick_dir), 3, 1)
	//deal damage AFTER the kick
	var/damage = max(1, min(30, (attacker.stats.getStat(STAT_ROB) / 3)))
	target.damage_through_armor(damage, BRUTE, BP_CHEST, ARMOR_MELEE)
	attacker.regen_slickness()
	//admin messaging
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Dropkicked [target.name] ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Dropkicked by [attacker.name] ([attacker.ckey])</font>")
	msg_admin_attack("[key_name(attacker)] has dropkicked [key_name(target)]")
	//kill the grab
	attacker.drop_from_inventory(src)
	loc = null
	qdel(src)

/obj/item/grab/proc/suplex(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(state < GRAB_NECK) //red grab check
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	visible_message(SPAN_WARNING("[attacker] lifts [target] off the ground..." ))
	attacker.next_move = world.time + 20 //2 seconds, also should prevent user from triggering this repeatedly
	if(do_after(attacker, 20, progress=0) && target)
		visible_message(SPAN_DANGER("...And falls backwards, slamming the opponent back onto the floor!"))
		target.SpinAnimation(5,1)
		var/damage = min(80, attacker.stats.getStat(STAT_ROB) + 15) //WE ARE GONNA KILL YOU
		target.damage_through_armor(damage, BRUTE, BP_CHEST, ARMOR_MELEE) //crunch
		attacker.Weaken(2)
		target.Stun(6)
		playsound(loc, 'sound/weapons/jointORbonebreak.ogg', 50, 1, -1)
		attacker.regen_slickness()
		//admin messaging
		attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Suplexed [target.name] ([target.ckey])</font>")
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Suplexed by [attacker.name] ([attacker.ckey])</font>")
		msg_admin_attack("[key_name(attacker)] has suplexed [key_name(target)]")
		//kill the grab
		attacker.drop_from_inventory(src)
		loc = null
		qdel(src)

/obj/item/grab/proc/gut_punch(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	//no check for grab levels
	visible_message(SPAN_DANGER("[attacker] thrusts \his fist in [target]'s guts!"))
	var/damage = max(1, (10 - target.stats.getStat(STAT_TGH) / 4))//40+ TGH = 1 dmg
	target.damage_through_armor(damage, BRUTE, BP_GROIN, ARMOR_MELEE, wounding_multiplier = 2)
	//vomiting goes on cd for 35 secs, which means it's impossible to spam this
	target.vomit(TRUE)
	//admin messaging
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Gutpunched [target.name] ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Gutpunched by [attacker.name] ([attacker.ckey])</font>")
	//kill the grab
	attacker.drop_from_inventory(src)
	loc = null
	qdel(src)

/obj/item/grab/proc/headbutt(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	if(target.lying)
		return
	attacker.visible_message(SPAN_DANGER("[attacker] thrusts \his head into [target]'s skull!"))

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	var/victim_armor = target.getarmor(BP_HEAD, ARMOR_MELEE)
	if(istype(hat))
		damage += hat.force * 3

	target.damage_through_armor(damage, BRUTE, BP_HEAD, ARMOR_MELEE)
	attacker.damage_through_armor(10, BRUTE, BP_HEAD, ARMOR_MELEE)
	target.make_dizzy(15)

	if(!victim_armor && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message(SPAN_DANGER("[target] [target.species.knockout_message]"))

	playsound(attacker.loc, "swing_hit", 25, 1, -1)
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Headbutted [target.name] ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Headbutted by [attacker.name] ([attacker.ckey])</font>")
	msg_admin_attack("[key_name(attacker)] has headbutted [key_name(target)]")

	attacker.drop_from_inventory(src)
	src.loc = null
	qdel(src)
	return

/obj/item/grab/proc/nerve_strike(mob/living/carbon/human/target, mob/living/attacker, var/target_zone)
	if(target.grab_joint(attacker, target_zone))
		return

/obj/item/grab/proc/pin_down(mob/target, mob/attacker)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	if(force_down)
		to_chat(attacker, SPAN_WARNING("You are already pinning [target] to the ground."))

	attacker.visible_message(SPAN_DANGER("[attacker] starts forcing [target] to the ground!"))
	if(do_after(attacker, 20, progress=0) && target)
		last_action = world.time
		attacker.visible_message(SPAN_DANGER("[attacker] forces [target] to the ground!"))
		apply_pinning(target, attacker)

/obj/item/grab/proc/apply_pinning(mob/target, mob/attacker)
	playsound(loc, 'sound/weapons/pinground.ogg', 50, 1, -1)
	force_down = 1
	target.Weaken(3)
	target.lying = 1
	step_to(attacker, target)
	attacker.set_dir(EAST) //face the victim
	target.set_dir(SOUTH) //face up

/obj/item/grab/proc/fireman_throw(mob/living/carbon/human/target, mob/living/carbon/human/attacker)//in short, suplex + irish whip
	if(state < GRAB_AGGRESSIVE)//blue grab check
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	visible_message(SPAN_DANGER("[attacker] lifts [target] over the shoulders, just to drop \him behind!" ))
	target.SpinAnimation(5,1)
	var/fireman_dir = (get_dir(target, attacker))
	if(attacker.loc == target.loc) // if we are on the same tile(e.g. neck grab), turn the direction to still push them away
		fireman_dir = turn(attacker.dir, 180)
	var/damage = max(1, min(20, (attacker.stats.getStat(STAT_ROB) / 3)))

	target.loc = attacker.loc
	attacker.drop_from_inventory(src)
	loc = null
	qdel(src)
	target.update_lying_buckled_and_verb_status()

	if(!istype(get_step(attacker, fireman_dir), /turf/simulated/wall))
		target.forceMove(get_step(target, fireman_dir))

	target.damage_through_armor(damage, HALLOSS, BP_CHEST, ARMOR_MELEE)

	target.Weaken(1)
	playsound(loc, 'sound/weapons/jointORbonebreak.ogg', 50, 1, -1)
	attacker.regen_slickness(0.15)//sick, but a dropkick is even sicker

	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Fireman-thrown [target.name] ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Fireman-thrown by [attacker.name] ([attacker.ckey])</font>")
	msg_admin_attack("[key_name(attacker)] has fireman-thrown [key_name(target)]")

/obj/item/grab/proc/swing(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(state < GRAB_NECK) //red grab check
		to_chat(attacker, SPAN_WARNING("You require a better grab to do this."))
		return
	if(!target.lying)
		to_chat(attacker, SPAN_WARNING("\The [target] needs to be on the ground to do this."))
		return
	var/free_space = TRUE//if there are walls or structures around us, we can't do this.
	for (var/turf/T in range(1, attacker.loc))
		if(istype(T, /turf/simulated/wall))
			free_space = FALSE
		if(!T.CanPass(attacker, T))
			free_space = FALSE
	if(!free_space)
		to_chat(attacker, SPAN_WARNING("There is not enough space around you to do this."))
		return
	//finally, we SWING
	target.loc = attacker.loc
	visible_message(SPAN_DANGER("[attacker] pivots, spinning [target] around!"))
	attacker.next_move = world.time + 30 //3 seconds
	var/spin = 2
	var/damage = 30
	var/dir = attacker.dir
	if(dir & NORTH || dir & SOUTH)
		dir = turn(dir, 90)
	while(spin < 10 && target)//while we have a grab
		step_glide(target, dir,(DELAY2GLIDESIZE(0.2 SECONDS)))//very fast
		if((spin % 2) == 0)
			dir = turn(dir, 90)
		spin++
		damage += 5
		for(var/mob/living/L in get_step(target, dir))
			visible_message(SPAN_DANGER("[target] collides with [L], pushing \him on the ground!"))
			L.Weaken(4)
		attacker.set_dir(dir)
		sleep(1)

	target.throw_at(get_edge_target_turf(target, dir), 7, 2)//this is very fast, and very painful for any obstacle involved
	target.damage_through_armor(damage, HALLOSS, armour_divisor = 2)
	attacker.regen_slickness(0.4)

	//admin messaging
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Swung [target.name] ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Swung by [attacker.name] ([attacker.ckey])</font>")
	msg_admin_attack("[key_name(attacker)] has swung [key_name(target)]")
	//kill the grab
	attacker.drop_from_inventory(src)
	loc = null
	qdel(src)
