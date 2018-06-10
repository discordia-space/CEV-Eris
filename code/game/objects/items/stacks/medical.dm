/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 5
	max_amount = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if (!istype(M))
		user << SPAN_WARNING("\The [src] cannot be applied to [M]!")
		return 1

	if ( ! (ishuman(user) || issilicon(user)) )
		user << SPAN_WARNING("You don't have the dexterity to do this!")
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				user << SPAN_WARNING("You can't apply [src] through [H.head]!")
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				user << SPAN_WARNING("You can't apply [src] through [H.wear_suit]!")
				return 1

		if(affecting.robotic >= ORGAN_ROBOT)
			user << SPAN_WARNING("This isn't useful at all on a robotic limb.")
			return 1

		H.UpdateDamageIcon()

	else

		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message(
			SPAN_NOTICE("[M] has been applied with [src] by [user]."),
			SPAN_NOTICE("You apply \the [src] to [M].")
		)
		if(prob(10 + user.stats.getStat(STAT_BIO)))
			user << SPAN_NOTICE("You have managed to waste less [src].")
		else
			use(1)

	M.updatehealth()

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(affecting.open == 0)
			if(affecting.is_bandaged())
				user << SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged.")
				return 1
			else
				user.visible_message(
					SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."),
					SPAN_NOTICE("You start treating [M]'s [affecting.name].")
				)
				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						continue
					if(W.bandaged)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						user << SPAN_NOTICE("You must stand still to bandage wounds.")
						break

					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message(
							SPAN_NOTICE("\The [user] bandages \a [W.desc] on [M]'s [affecting.name]."),
							SPAN_NOTICE("You bandage \a [W.desc] on [M]'s [affecting.name].")
						)
						//H.add_side_effect("Itch")
					else if (W.damage_type == BRUISE)
						user.visible_message(
							SPAN_NOTICE("\The [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name]."),
							SPAN_NOTICE("You place a bruise patch over \a [W.desc] on [M]'s [affecting.name].")
						)
					else
						user.visible_message(
							SPAN_NOTICE("\The [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name]."),
							SPAN_NOTICE("You place a bandaid over \a [W.desc] on [M]'s [affecting.name].")
						)
					W.bandage()
					if(prob(10 + user.stats.getStat(STAT_BIO)))
						user << SPAN_NOTICE("You have managed to waste less [src].")
					else
						used++
				affecting.update_damages()
				if(used == amount)
					if(affecting.is_bandaged())
						user << SPAN_WARNING("\The [src] is used up.")
					else
						user << SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name].")
				use(used)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!")

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(affecting.open == 0)
			if(affecting.is_salved())
				user << SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved.")
				return 1
			else
				user.visible_message(
					SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."),
					SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].")
				)
				if(!do_mob(user, M, 10))
					user << SPAN_NOTICE("You must stand still to salve wounds.")
					return 1
				user.visible_message(
					SPAN_NOTICE("[user] salved wounds on [M]'s [affecting.name]."),
					SPAN_NOTICE("You salved wounds on [M]'s [affecting.name].")
				)
				if(prob(10 + user.stats.getStat(STAT_BIO)))
					user << SPAN_NOTICE("You have managed to waste less [src].")
				else
					use(1)
				affecting.salve()
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a [src]!")

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 0
	origin_tech = list(TECH_BIO = 1)

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

	if(affecting.open == 0)
		if(affecting.is_bandaged() && affecting.is_disinfected())
			user << SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been treated.")
			return 1
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."),
				SPAN_NOTICE("You start treating [M]'s [affecting.name].")
			)
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if (W.internal)
					continue
				if (W.bandaged && W.disinfected)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					user << SPAN_NOTICE("You must stand still to bandage wounds.")
					break
				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message(
						SPAN_NOTICE("\The [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue."),
						SPAN_NOTICE("You clean and seal \a [W.desc] on [M]'s [affecting.name].")
					)
				else if (W.damage_type == BRUISE)
					user.visible_message(
						SPAN_NOTICE("\The [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name]."),
						SPAN_NOTICE("You place a medical patch over \a [W.desc] on [M]'s [affecting.name].")
					)
				else
					user.visible_message(
						SPAN_NOTICE("\The [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name]."),
						SPAN_NOTICE("You smear some bioglue over \a [W.desc] on [M]'s [affecting.name].")
					)
				W.bandage()
				W.disinfect()
				W.heal_damage(heal_brute)
				if(prob(10 + user.stats.getStat(STAT_BIO)))
					user << SPAN_NOTICE("You have managed to waste less [src].")
				else
					used++
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					user << SPAN_WARNING("\The [src] is used up.")
				else
					user << SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name].")
			use(used)
	else
		if (can_operate(H))        //Checks if mob is lying down on table for surgery
			if (do_surgery(H,user,src))
				return
		else
			user << SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!")

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 0
	origin_tech = list(TECH_BIO = 1)


/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(affecting.open == 0)
			if(affecting.is_salved())
				user << SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved.")
				return 1
			else
				user.visible_message(
					SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."),
					SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].")
				)
				if(!do_mob(user, M, 10))
					user << SPAN_NOTICE("You must stand still to salve wounds.")
					return 1
				user.visible_message(
					SPAN_NOTICE("[user] covers wounds on [M]'s [affecting.name] with regenerative membrane."),
					SPAN_NOTICE("You cover wounds on [M]'s [affecting.name] with regenerative membrane.")
				)
				affecting.heal_damage(0,heal_burn)
				if(prob(10 + user.stats.getStat(STAT_BIO)))
					user << SPAN_NOTICE("You have managed to waste less [src].")
				else
					use(1)
				affecting.salve()
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				user << SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!")

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)
		var/limb = affecting.name
		if(!(affecting.organ_tag in list(BP_L_ARM,BP_R_ARM,BP_L_LEG ,BP_R_LEG)))
			user << SPAN_DANGER("You can't apply a splint there!")
			return
		if(affecting.status & ORGAN_SPLINTED)
			user << SPAN_DANGER("[M]'s [limb] is already splinted!")
			return
		if (M != user)
			user.visible_message(
				SPAN_DANGER("[user] starts to apply \the [src] to [M]'s [limb]."),
				SPAN_DANGER("You start to apply \the [src] to [M]'s [limb]."),
				SPAN_DANGER("You hear something being wrapped.")
			)
		else
			if((!user.hand && affecting.organ_tag == BP_R_ARM) || (user.hand && affecting.organ_tag == BP_L_ARM))
				user << SPAN_DANGER("You can't apply a splint to the arm you're using!")
				return
			user.visible_message(
				SPAN_DANGER("[user] starts to apply \the [src] to their [limb]."),
				SPAN_DANGER("You start to apply \the [src] to your [limb]."),
				SPAN_DANGER("You hear something being wrapped.")
			)
		if(do_after(user, max(0, 60 - user.stats.getStat(STAT_BIO)), M))
			if (M != user)
				user.visible_message(
					SPAN_DANGER("[user] finishes applying \the [src] to [M]'s [limb]."),
					SPAN_DANGER("You finish applying \the [src] to [M]'s [limb]."),
					SPAN_DANGER("You hear something being wrapped.")
				)
			else
				if(prob(25 + user.stats.getStat(STAT_BIO)))
					user.visible_message(
						SPAN_DANGER("[user] successfully applies \the [src] to their [limb]."),
						SPAN_DANGER("You successfully apply \the [src] to your [limb]."),
						SPAN_DANGER("You hear something being wrapped.")
					)
				else
					user.visible_message(
						SPAN_DANGER("[user] fumbles \the [src]."),
						SPAN_DANGER("You fumble \the [src]."),
						SPAN_DANGER("You hear something being wrapped.")
					)
					return
			affecting.status |= ORGAN_SPLINTED
			if(prob(10 + user.stats.getStat(STAT_BIO)))
				user << SPAN_NOTICE("You have managed to waste less [src].")
			else
				use(1)
		return
