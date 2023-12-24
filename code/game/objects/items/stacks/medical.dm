/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stack/items.dmi'
	amount = 5
	max_amount = 5
	volumeClass = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20
	price_tag = 10
	spawn_tags = SPAWN_TAG_MEDICINE
	bad_type = /obj/item/stack/medical
	matter = list(MATERIAL_BIOMATTER = 5)
	var/heal_brute = 0
	var/heal_burn = 0
	var/automatic_charge_overlays = FALSE	//Do we handle overlays with base update_icon()? | Stolen from TG egun code
	var/charge_sections = 5		// How many indicator blips are there?
	var/charge_x_offset = 2		//The spacing between each charge indicator. Should be 2 to leave a 1px gap between each blip.

/obj/item/stack/medical/attack(mob/living/M, mob/living/user)
	var/types = M.get_classification()
	if (!(types & CLASSIFICATION_ORGANIC))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to [M]!"))
		return 1

	if ( ! (ishuman(user) || issilicon(user)) )
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(!affecting)
			to_chat(user, SPAN_WARNING("What [user.targeted_organ]?"))
			return TRUE

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
				return 1

		if(BP_IS_ROBOTIC(affecting))
			// user is clueless
			if(BP_IS_LIFELIKE(affecting) && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
				user.visible_message( \
				SPAN_NOTICE("[user] starts applying [src] to [M]."), \
				SPAN_NOTICE("You start applying [src] to [M].") \
				)
				if (do_after(user, 30, M))
					if(prob(10 + user.stats.getStat(STAT_BIO)))
						to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
					else
						use(1)
					user.visible_message( \
						SPAN_NOTICE("[M] starts has been applied with [src] by [user]."), \
						SPAN_NOTICE("You apply [src] to [M].") \
					)
				M.updatehealth()
				return 1

			to_chat(user, SPAN_WARNING("This isn't useful at all on a robotic limb."))
			return 1

		H.UpdateDamageIcon()

	else
		if (!M.bruteloss && !M.fireloss)
			to_chat(user, "<span class='notice'> [M] seems healthy, there are no wounds to treat! </span>")
			return 1

		user.visible_message( \
				SPAN_NOTICE("[user] starts applying [src] to [M]."), \
				SPAN_NOTICE("You start applying [src] to [M].") \
			)
		var/med_skill = user.stats.getStat(STAT_BIO)
		if (do_after(user, 30, M))
			M.heal_organ_damage((src.heal_brute * (1+med_skill/50)/2), (src.heal_burn * (1+med_skill/50)/2))
			if(prob(10 + med_skill))
				to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
			else
				use(1)
			user.visible_message( \
				SPAN_NOTICE("[M] starts has been applied with [src] by [user]."), \
				SPAN_NOTICE("You apply [src] to [M].") \
			)

	M.updatehealth()

/obj/item/stack/medical/update_icon()
	if(QDELETED(src)) //Checks if the item has been deleted
		return	//If it has, do nothing
	..()
	if(!automatic_charge_overlays)	//Checks if the item has this feature enabled
		return	//If it does not, do nothing
	var/ratio = CEILING(CLAMP(amount / max_amount, 0, 1) * charge_sections, 1)
	cut_overlays()
	var/iconState = "[icon_state]_charge"
	if(!amount)	//Checks if there are still charges left in the item
		return //If it does not, do nothing, as the overlays have been cut before this already.
	else
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
		for(var/i = ratio, i >= 1, i--)
			charge_overlay.pixel_x = charge_x_offset * (i - 1)
			add_overlay(charge_overlay)

/obj/item/stack/medical/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	heal_brute = 4
	preloaded_reagents = list("silicon" = 4, "ethanol" = 8)
	rarity_value = 5
	spawn_tags = SPAWN_TAG_MEDICINE_COMMON

/obj/item/stack/medical/bruise_pack/update_icon()
	icon_state = "[initial(icon_state)][amount]"
	..()

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M, mob/living/user)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(!affecting)
			to_chat(user, SPAN_WARNING("What [user.targeted_organ]?"))
			return TRUE

		if(affecting.open == 0)
			if(affecting.is_bandaged())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
				return 1
			else
				user.visible_message(
					SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."),
					SPAN_NOTICE("You start treating [M]'s [affecting.name].")
				)
				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if(W.internal)
						continue
					if(W.bandaged)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
						break
					if(W.internal)
						continue
					if(W.bandaged)
						continue
					if(used == amount)
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
					// user's stat check that causing pain if they are amateurs
					if(user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
						if(prob(affecting.get_damage() - user.stats.getStat(STAT_BIO)))
							var/pain = rand(min(30,affecting.get_damage()), max(affecting.get_damage() + 30,60) - user.stats.getStat(STAT_BIO))
							H.pain(affecting, pain)
							if(user != H)
								to_chat(H, "<span class='[pain > 50 ? "danger" : "warning"]'>\The [user]'s amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
								to_chat(user, SPAN_WARNING("Your amateur actions caused [H] [pain > 50 ? "a lot of " : ""]pain."))
							else
								to_chat(user, "<span class='[pain > 50 ? "danger" : "warning"]'>Your amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
					if(prob(10 + user.stats.getStat(STAT_BIO)))
						to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
					else
						used++
				affecting.update_damages()
				if(used == amount)
					if(affecting.is_bandaged())
						to_chat(user, SPAN_WARNING("\The [src] is used up."))
					else
						to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
				use(used)
		else
			if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src, TRUE))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/bruise_pack/handmade
	name = "non sterile bandage"
	singular_name = "non sterile bandage"
	desc = "Parts of clothes that can be wrapped around bloody stumps."
	icon_state = "hm_brutepack"
	spawn_blacklisted = TRUE

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment5"
	heal_burn = 4
	origin_tech = list(TECH_BIO = 1)
	preloaded_reagents = list("silicon" = 4, "carbon" = 8)
	rarity_value = 5
	spawn_tags = SPAWN_TAG_MEDICINE_COMMON

/obj/item/stack/medical/bruise_pack/update_icon()
	icon_state = "[initial(icon_state)][amount]"
	..()

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M, mob/living/user)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(!affecting)
			to_chat(user, SPAN_WARNING("What [user.targeted_organ]?"))
			return TRUE

		if(affecting.open == 0)
			if(affecting.is_salved())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
				return 1
			else
				user.visible_message(
					SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."),
					SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].")
				)
				if(!do_mob(user, M, 10))
					to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
					return 1
				user.visible_message(
					SPAN_NOTICE("[user] salved wounds on [M]'s [affecting.name]."),
					SPAN_NOTICE("You salved wounds on [M]'s [affecting.name].")
				)
				if(prob(10 + user.stats.getStat(STAT_BIO)))
					to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
				else
					use(1)
				affecting.salve()
				// user's stat check that causing pain if they are amateurs
				if(user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
					if(prob(affecting.get_damage() - user.stats.getStat(STAT_BIO)))
						var/pain = rand(min(30,affecting.get_damage()), max(affecting.get_damage() + 30,60) - user.stats.getStat(STAT_BIO))
						H.pain(affecting, pain)
						if(user != H)
							to_chat(H, "<span class='[pain > 50 ? "danger" : "warning"]'>\The [user]'s amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
							to_chat(user, SPAN_WARNING("Your amateur actions caused [H] [pain > 50 ? "a lot of " : ""]pain."))
						else
							to_chat(user, "<span class='[pain > 50 ? "danger" : "warning"]'>Your amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
		else
			if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src, TRUE))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a [src]!"))

/obj/item/stack/medical/advanced
	bad_type = /obj/item/stack/medical/advanced
	spawn_tags = SPAWN_TAG_MEDICINE_ADVANCED

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 8
	origin_tech = list(TECH_BIO = 2)
	automatic_charge_overlays = TRUE
	consumable = FALSE	// Will the stack disappear entirely once the amount is used up?
	splittable = FALSE	// Is the stack capable of being splitted?
	preloaded_reagents = list("silicon" = 4, "ethanol" = 10, "lithium" = 4)
	rarity_value = 10

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M, mob/living/user)
	if(..())
		return 1

	if(amount < 1)
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

	if(!affecting)
		to_chat(user, SPAN_WARNING("What [user.targeted_organ]?"))
		return TRUE

	if(affecting.open == 0)
		if(affecting.is_bandaged())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been treated."))
			return 1
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."),
				SPAN_NOTICE("You start treating [M]'s [affecting.name].")
			)
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if(W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
					break
				if(W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
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
				W.heal_damage(heal_brute)
				if(prob(10 + user.stats.getStat(STAT_BIO)))
					to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
				else
					used++
			affecting.update_damages()
			// user's stat check that causing pain if they are amateurs
			if(user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
				if(prob(affecting.get_damage() - user.stats.getStat(STAT_BIO)))
					var/pain = rand(min(30,affecting.get_damage()), max(affecting.get_damage() + 30,60) - user.stats.getStat(STAT_BIO))
					H.pain(affecting, pain)
					if(user != H)
						to_chat(H, "<span class='[pain > 50 ? "danger" : "warning"]'>\The [user]'s amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
						to_chat(user, SPAN_WARNING("Your amateur actions caused [H] [pain > 50 ? "a lot of " : ""]pain."))
					else
						to_chat(user, "<span class='[pain > 50 ? "danger" : "warning"]'>Your amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("\The [src] is used up."))
				else
					to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
			use(used)
			update_icon()
	else
		if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if mob is lying down on table for surgery
			if (do_surgery(H,user,src, TRUE))
				return
		else
			to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 8
	origin_tech = list(TECH_BIO = 2)
	automatic_charge_overlays = TRUE
	consumable = FALSE	// Will the stack disappear entirely once the amount is used up?
	splittable = FALSE	// Is the stack capable of being splitted?
	preloaded_reagents = list("silicon" = 4, "ethanol" = 10, "mercury" = 4)
	rarity_value = 10

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M, mob/living/user)
	if(..())
		return 1

	if(amount < 1)
		return

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(!affecting)
			to_chat(user, SPAN_WARNING("What [user.targeted_organ]?"))
			return TRUE

		if(affecting.open == 0)
			if(affecting.is_salved())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
				return 1
			else
				user.visible_message(
					SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."),
					SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].")
				)
				if(!do_mob(user, M, 10))
					to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
					return 1
				user.visible_message(
					SPAN_NOTICE("[user] covers wounds on [M]'s [affecting.name] with regenerative membrane."),
					SPAN_NOTICE("You cover wounds on [M]'s [affecting.name] with regenerative membrane.")
				)
				affecting.heal_damage(0,heal_burn)
				if(prob(10 + user.stats.getStat(STAT_BIO)))
					to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
				else
					use(1)
					update_icon()
				affecting.salve()
				// user's stat check that causing pain if they are amateurs
				if(user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
					if(prob(affecting.get_damage() - user.stats.getStat(STAT_BIO)))
						var/pain = rand(min(30,affecting.get_damage()), max(affecting.get_damage() + 30,60) - user.stats.getStat(STAT_BIO))
						H.pain(affecting, pain)
						if(user != H)
							to_chat(H, "<span class='[pain > 50 ? "danger" : "warning"]'>\The [user]'s amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
							to_chat(user, SPAN_WARNING("Your amateur actions caused [H] [pain > 50 ? "a lot of " : ""]pain."))
						else
							to_chat(user, "<span class='[pain > 50 ? "danger" : "warning"]'>Your amateur actions caused you [pain > 50 ? "a lot of " : ""]pain.</span>")
		else
			if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src, TRUE))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	rarity_value = 20
	spawn_tags = SPAWN_TAG_MEDICINE_COMMON

/obj/item/stack/medical/splint/attack(mob/living/carbon/M, mob/living/user)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)

		if(!affecting)
			to_chat(user, SPAN_WARNING("What [user.targeted_organ]?"))
			return TRUE

		var/limb = affecting.name
		if(!(affecting.organ_tag in list(BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG, BP_GROIN, BP_HEAD, BP_CHEST)))
			to_chat(user, SPAN_DANGER("You can't apply a splint there!"))
			return
		if(affecting.status & ORGAN_SPLINTED)
			to_chat(user, SPAN_DANGER("[M]'s [limb] is already splinted!"))
			return
		if (M != user)
			user.visible_message(
				SPAN_DANGER("[user] starts to apply \the [src] to [M]'s [limb]."),
				SPAN_DANGER("You start to apply \the [src] to [M]'s [limb]."),
				SPAN_DANGER("You hear something being wrapped.")
			)
		else
			if((!user.hand && affecting.organ_tag == BP_R_ARM) || (user.hand && affecting.organ_tag == BP_L_ARM))
				to_chat(user, SPAN_DANGER("You can't apply a splint to the arm you're using!"))
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
				to_chat(user, SPAN_NOTICE("You have managed to waste less [src]."))
			else
				use(1)
		return

/obj/item/stack/medical/advanced/bruise_pack/nt
	name = "NeoTheology bruisepack"
	singular_name = "NeoTheology bruisepack"
	desc = "An advanced bruisepack for severe injuries. Created by will of God."
	icon_state = "nt_traumakit"
	heal_brute = 10
	automatic_charge_overlays = FALSE
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 3)
	origin_tech = list(TECH_BIO = 4)

/obj/item/stack/medical/advanced/bruise_pack/nt/update_icon()
	icon_state = "[initial(icon_state)][amount]"
	..()

/obj/item/stack/medical/advanced/ointment/nt
	name = "NeoTheology burnpack"
	singular_name = "NeoTheology burnpack"
	desc = "An advanced treatment kit for severe burns. Created by will of God."
	icon_state = "nt_burnkit"
	heal_brute = 10
	automatic_charge_overlays = FALSE
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 3)
	origin_tech = list(TECH_BIO = 4)

/obj/item/stack/medical/advanced/ointment/nt/update_icon()
	icon_state = "[initial(icon_state)][amount]"
	..()
