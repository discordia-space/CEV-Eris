/obj/item/stack/nanopaste
	name = "nanopaste"
	sin69ular_name = "nanite swarm"
	desc = "A tube of paste containin69 swarms of repair nanites.69ery effective in repairin69 robotic69achinery."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "nanopaste"
	matter = list(MATERIAL_PLASTEEL = 0.1,69ATERIAL_STEEL = 1)
	ori69in_tech = list(TECH_MATERIAL = 4, TECH_EN69INEERIN69 = 3)
	amount = 10
	w_class = ITEM_SIZE_SMALL //just so you can place same places that a brute pack would be
	price_ta69 = 80
	spawn_ta69s = SPAWN_TA69_MEDICINE
	rarity_value = 40


/obj/item/stack/nanopaste/attack(mob/livin69/M,69ob/user)
	if(..())
		return 1
	if (!istype(M) || !istype(user))
		return 0
	if (isrobot(M))	//Repairin69 cybor69s
		var/mob/livin69/silicon/robot/R =69
		if (R.69etBruteLoss() || R.69etFireLoss() )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			R.adjustBruteLoss(-15)
			R.adjustFireLoss(-15)
			R.updatehealth()
			use(1)
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 applied some 69src69 at 69R69's dama69ed areas."),\
				SPAN_NOTICE("You apply some 69src69 at 69R69's dama69ed areas."))
		else
			to_chat(user, SPAN_NOTICE("All 69R69's systems are nominal."))

	if (ishuman(M))		//Repairin69 robolimbs
		var/mob/livin69/carbon/human/H =69
		var/obj/item/or69an/external/S = H.69et_or69an(user.tar69eted_or69an)

		if(S && BP_IS_ROBOTIC(S) && S.69et_dama69e() && S.open == 0)
			for(var/datum/wound/W in S.wounds)
				if(W.internal)
					return
				if(amount <= 0)
					break
				if(!do_mob(user,69, W.dama69e/5))
					to_chat(user, SPAN_NOTICE("You69ust stand still to repair \the 69S69."))
					break
				if(!use(1))
					to_chat(user, SPAN_WARNIN69("You have run out of \the 69src69."))
					return
				W.heal_dama69e(CLAMP(user.stats.69etStat(STAT_MEC)/2.5, 5, 20))
				to_chat(user, SPAN_NOTICE("You patch some wounds on \the 69S69."))
			S.update_dama69es()
			if(S.69et_dama69e())
				to_chat(user, SPAN_WARNIN69("\The 69S69 still needs further repair."))
				return
		if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if69ob is lyin69 down on table for sur69ery
			do_sur69ery(H,user,src, TRUE)
