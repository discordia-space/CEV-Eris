/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "nanopaste"
	matter = list(MATERIAL_PLASTEEL = 0.1, MATERIAL_STEEL = 1)
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	amount = 10
	volumeClass = ITEM_SIZE_SMALL //just so you can place same places that a brute pack would be
	price_tag = 80
	spawn_tags = SPAWN_TAG_MEDICINE
	rarity_value = 40


/obj/item/stack/nanopaste/attack(mob/living/M, mob/user)
	if(..())
		return 1
	if (!istype(M) || !istype(user))
		return 0
	if (isrobot(M))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if (R.getBruteLoss() || R.getFireLoss() )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			R.adjustBruteLoss(-15)
			R.adjustFireLoss(-15)
			R.updatehealth()
			use(1)
			user.visible_message(SPAN_NOTICE("\The [user] applied some [src] at [R]'s damaged areas."),\
				SPAN_NOTICE("You apply some [src] at [R]'s damaged areas."))
		else
			to_chat(user, SPAN_NOTICE("All [R]'s systems are nominal."))

	if (ishuman(M))		//Repairing robolimbs
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.get_organ(user.targeted_organ)

		if(S && BP_IS_ROBOTIC(S) && S.get_damage() && S.open == 0)
			for(var/datum/wound/W in S.wounds)
				if(W.internal)
					return
				if(amount <= 0)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, SPAN_NOTICE("You must stand still to repair \the [S]."))
					break
				if(!use(1))
					to_chat(user, SPAN_WARNING("You have run out of \the [src]."))
					return
				W.heal_damage(CLAMP(user.stats.getStat(STAT_MEC)/2.5, 5, 20))
				to_chat(user, SPAN_NOTICE("You patch some wounds on \the [S]."))
			S.update_damages()
			if(S.get_damage())
				to_chat(user, SPAN_WARNING("\The [S] still needs further repair."))
				return
		if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if mob is lying down on table for surgery
			do_surgery(H,user,src, TRUE)
