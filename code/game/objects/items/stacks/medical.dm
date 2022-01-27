/obj/item/stack/medical
	name = "medical pack"
	sin69ular_name = "medical pack"
	icon = 'icons/obj/stack/items.dmi'
	amount = 5
	max_amount = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_ran69e = 20
	price_ta69 = 10
	spawn_ta69s = SPAWN_TA69_MEDICINE
	bad_type = /obj/item/stack/medical
	matter = list(MATERIAL_BIOMATTER = 5)
	var/heal_brute = 0
	var/heal_burn = 0
	var/automatic_char69e_overlays = FALSE	//Do we handle overlays with base update_icon()? | Stolen from T69 e69un code
	var/char69e_sections = 5		// How69any indicator blips are there?
	var/char69e_x_offset = 2		//The spacin69 between each char69e indicator. Should be 2 to leave a 1px 69ap between each blip.

/obj/item/stack/medical/attack(mob/livin69/M,69ob/livin69/user)
	var/types =69.69et_classification()
	if (!(types & CLASSIFICATION_OR69ANIC))
		to_chat(user, SPAN_WARNIN69("\The 69src69 cannot be applied to 69M69!"))
		return 1

	if ( ! (ishuman(user) || issilicon(user)) )
		to_chat(user, SPAN_WARNIN69("You don't have the dexterity to do this!"))
		return 1

	if (ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/obj/item/or69an/external/affectin69 = H.69et_or69an(user.tar69eted_or69an)

		if(!affectin69)
			to_chat(user, SPAN_WARNIN69("What 69user.tar69eted_or69an69?"))
			return TRUE

		if(affectin69.or69an_ta69 == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothin69/head/space))
				to_chat(user, SPAN_WARNIN69("You can't apply 69src69 throu69h 69H.head69!"))
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothin69/suit/space))
				to_chat(user, SPAN_WARNIN69("You can't apply 69src69 throu69h 69H.wear_suit69!"))
				return 1

		if(BP_IS_ROBOTIC(affectin69))
			// user is clueless
			if(BP_IS_LIFELIKE(affectin69) && user.stats.69etStat(STAT_BIO) < STAT_LEVEL_BASIC)
				user.visible_messa69e( \
				SPAN_NOTICE("69user69 starts applyin69 69src69 to 69M69."), \
				SPAN_NOTICE("You start applyin69 69src69 to 69M69.") \
				)
				if (do_after(user, 30,69))
					if(prob(10 + user.stats.69etStat(STAT_BIO)))
						to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
					else
						use(1)
					user.visible_messa69e( \
						SPAN_NOTICE("69M69 starts has been applied with 69src69 by 69user69."), \
						SPAN_NOTICE("You apply 69src69 to 69M69.") \
					)
				M.updatehealth()
				return 1

			to_chat(user, SPAN_WARNIN69("This isn't useful at all on a robotic limb."))
			return 1

		H.UpdateDama69eIcon()

	else
		if (!M.bruteloss && !M.fireloss)
			to_chat(user, "<span class='notice'> 69M69 seems healthy, there are no wounds to treat! </span>")
			return 1

		user.visible_messa69e( \
				SPAN_NOTICE("69user69 starts applyin69 69src69 to 69M69."), \
				SPAN_NOTICE("You start applyin69 69src69 to 69M69.") \
			)
		var/med_skill = user.stats.69etStat(STAT_BIO)
		if (do_after(user, 30,69))
			M.heal_or69an_dama69e((src.heal_brute * (1+med_skill/50)/2), (src.heal_burn * (1+med_skill/50)/2))
			if(prob(10 +69ed_skill))
				to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
			else
				use(1)
			user.visible_messa69e( \
				SPAN_NOTICE("69M69 starts has been applied with 69src69 by 69user69."), \
				SPAN_NOTICE("You apply 69src69 to 69M69.") \
			)

	M.updatehealth()

/obj/item/stack/medical/update_icon()
	if(69DELETED(src)) //Checks if the item has been deleted
		return	//If it has, do nothin69
	..()
	if(!automatic_char69e_overlays)	//Checks if the item has this feature enabled
		return	//If it does not, do nothin69
	var/ratio = CEILIN69(CLAMP(amount /69ax_amount, 0, 1) * char69e_sections, 1)
	cut_overlays()
	var/iconState = "69icon_state69_char69e"
	if(!amount)	//Checks if there are still char69es left in the item
		return //If it does not, do nothin69, as the overlays have been cut before this already.
	else
		var/mutable_appearance/char69e_overlay =69utable_appearance(icon, iconState)
		for(var/i = ratio, i >= 1, i--)
			char69e_overlay.pixel_x = char69e_x_offset * (i - 1)
			add_overlay(char69e_overlay)

/obj/item/stack/medical/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/medical/bruise_pack
	name = "roll of 69auze"
	sin69ular_name = "69auze len69th"
	desc = "Some sterile 69auze to wrap around bloody stumps."
	icon_state = "brutepack"
	ori69in_tech = list(TECH_BIO = 1)
	heal_brute = 4
	preloaded_rea69ents = list("silicon" = 4, "ethanol" = 8)
	rarity_value = 5
	spawn_ta69s = SPAWN_TA69_MEDICINE_COMMON

/obj/item/stack/medical/bruise_pack/attack(mob/livin69/carbon/M,69ob/livin69/user)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/obj/item/or69an/external/affectin69 = H.69et_or69an(user.tar69eted_or69an)

		if(!affectin69)
			to_chat(user, SPAN_WARNIN69("What 69user.tar69eted_or69an69?"))
			return TRUE

		if(affectin69.open == 0)
			if(affectin69.is_banda69ed())
				to_chat(user, SPAN_WARNIN69("The wounds on 69M69's 69affectin69.name69 have already been banda69ed."))
				return 1
			else
				user.visible_messa69e(
					SPAN_NOTICE("\The 69user69 starts treatin69 69M69's 69affectin69.name69."),
					SPAN_NOTICE("You start treatin69 69M69's 69affectin69.name69.")
				)
				var/used = 0
				for (var/datum/wound/W in affectin69.wounds)
					if(W.internal)
						continue
					if(W.banda69ed)
						continue
					if(used == amount)
						break
					if(!do_mob(user,69, W.dama69e/5))
						to_chat(user, SPAN_NOTICE("You69ust stand still to banda69e wounds."))
						break
					if(W.internal)
						continue
					if(W.banda69ed)
						continue
					if(used == amount)
						break
					if (W.current_sta69e <= W.max_bleedin69_sta69e)
						user.visible_messa69e(
							SPAN_NOTICE("\The 69user69 banda69es \a 69W.desc69 on 69M69's 69affectin69.name69."),
							SPAN_NOTICE("You banda69e \a 69W.desc69 on 69M69's 69affectin69.name69.")
						)
						//H.add_side_effect("Itch")
					else if (W.dama69e_type == BRUISE)
						user.visible_messa69e(
							SPAN_NOTICE("\The 69user69 places a bruise patch over \a 69W.desc69 on 69M69's 69affectin69.name69."),
							SPAN_NOTICE("You place a bruise patch over \a 69W.desc69 on 69M69's 69affectin69.name69.")
						)
					else
						user.visible_messa69e(
							SPAN_NOTICE("\The 69user69 places a bandaid over \a 69W.desc69 on 69M69's 69affectin69.name69."),
							SPAN_NOTICE("You place a bandaid over \a 69W.desc69 on 69M69's 69affectin69.name69.")
						)
					W.banda69e()
					// user's stat check that causin69 pain if they are amateurs
					if(user && user.stats.69etStat(STAT_BIO) < STAT_LEVEL_BASIC)
						if(prob(affectin69.69et_dama69e() - user.stats.69etStat(STAT_BIO)))
							var/pain = rand(min(30,affectin69.69et_dama69e()),69ax(affectin69.69et_dama69e() + 30,60) - user.stats.69etStat(STAT_BIO))
							H.pain(affectin69, pain)
							if(user != H)
								to_chat(H, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>\The 69user69's amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
								to_chat(user, SPAN_WARNIN69("Your amateur actions caused 69H69 69pain > 50 ? "a lot of " : ""69pain."))
							else
								to_chat(user, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>Your amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
					if(prob(10 + user.stats.69etStat(STAT_BIO)))
						to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
					else
						used++
				affectin69.update_dama69es()
				if(used == amount)
					if(affectin69.is_banda69ed())
						to_chat(user, SPAN_WARNIN69("\The 69src69 is used up."))
					else
						to_chat(user, SPAN_WARNIN69("\The 69src69 is used up, but there are69ore wounds to treat on \the 69affectin69.name69."))
				use(used)
		else
			if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if69ob is lyin69 down on table for sur69ery
				if (do_sur69ery(H,user,src, TRUE))
					return
			else
				to_chat(user, SPAN_NOTICE("The 69affectin69.name69 is cut open, you'll need69ore than a banda69e!"))

/obj/item/stack/medical/bruise_pack/handmade
	name = "non sterile banda69e"
	sin69ular_name = "non sterile banda69e"
	desc = "Parts of clothes that can be wrapped around bloody stumps."
	icon_state = "hm_brutepack"
	spawn_blacklisted = TRUE

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	69ender = PLURAL
	sin69ular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 4
	ori69in_tech = list(TECH_BIO = 1)
	preloaded_rea69ents = list("silicon" = 4, "carbon" = 8)
	rarity_value = 5
	spawn_ta69s = SPAWN_TA69_MEDICINE_COMMON

/obj/item/stack/medical/ointment/attack(mob/livin69/carbon/M,69ob/livin69/user)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/obj/item/or69an/external/affectin69 = H.69et_or69an(user.tar69eted_or69an)

		if(!affectin69)
			to_chat(user, SPAN_WARNIN69("What 69user.tar69eted_or69an69?"))
			return TRUE

		if(affectin69.open == 0)
			if(affectin69.is_salved())
				to_chat(user, SPAN_WARNIN69("The wounds on 69M69's 69affectin69.name69 have already been salved."))
				return 1
			else
				user.visible_messa69e(
					SPAN_NOTICE("\The 69user69 starts salvin69 wounds on 69M69's 69affectin69.name69."),
					SPAN_NOTICE("You start salvin69 the wounds on 69M69's 69affectin69.name69.")
				)
				if(!do_mob(user,69, 10))
					to_chat(user, SPAN_NOTICE("You69ust stand still to salve wounds."))
					return 1
				user.visible_messa69e(
					SPAN_NOTICE("69user69 salved wounds on 69M69's 69affectin69.name69."),
					SPAN_NOTICE("You salved wounds on 69M69's 69affectin69.name69.")
				)
				if(prob(10 + user.stats.69etStat(STAT_BIO)))
					to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
				else
					use(1)
				affectin69.salve()
				// user's stat check that causin69 pain if they are amateurs
				if(user && user.stats.69etStat(STAT_BIO) < STAT_LEVEL_BASIC)
					if(prob(affectin69.69et_dama69e() - user.stats.69etStat(STAT_BIO)))
						var/pain = rand(min(30,affectin69.69et_dama69e()),69ax(affectin69.69et_dama69e() + 30,60) - user.stats.69etStat(STAT_BIO))
						H.pain(affectin69, pain)
						if(user != H)
							to_chat(H, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>\The 69user69's amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
							to_chat(user, SPAN_WARNIN69("Your amateur actions caused 69H69 69pain > 50 ? "a lot of " : ""69pain."))
						else
							to_chat(user, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>Your amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
		else
			if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if69ob is lyin69 down on table for sur69ery
				if (do_sur69ery(H,user,src, TRUE))
					return
			else
				to_chat(user, SPAN_NOTICE("The 69affectin69.name69 is cut open, you'll need69ore than a 69src69!"))

/obj/item/stack/medical/advanced
	bad_type = /obj/item/stack/medical/advanced
	spawn_ta69s = SPAWN_TA69_MEDICINE_ADVANCED

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	sin69ular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 8
	ori69in_tech = list(TECH_BIO = 2)
	automatic_char69e_overlays = TRUE
	consumable = FALSE	// Will the stack disappear entirely once the amount is used up?
	splittable = FALSE	// Is the stack capable of bein69 splitted?
	preloaded_rea69ents = list("silicon" = 4, "ethanol" = 10, "lithium" = 4)
	rarity_value = 10

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/livin69/carbon/M,69ob/livin69/user)
	if(..())
		return 1

	if(amount < 1)
		return

	if(!ishuman(M))
		return

	var/mob/livin69/carbon/human/H =69
	var/obj/item/or69an/external/affectin69 = H.69et_or69an(user.tar69eted_or69an)

	if(!affectin69)
		to_chat(user, SPAN_WARNIN69("What 69user.tar69eted_or69an69?"))
		return TRUE

	if(affectin69.open == 0)
		if(affectin69.is_banda69ed() && affectin69.is_disinfected())
			to_chat(user, SPAN_WARNIN69("The wounds on 69M69's 69affectin69.name69 have already been treated."))
			return 1
		else
			user.visible_messa69e(
				SPAN_NOTICE("\The 69user69 starts treatin69 69M69's 69affectin69.name69."),
				SPAN_NOTICE("You start treatin69 69M69's 69affectin69.name69.")
			)
			var/used = 0
			for (var/datum/wound/W in affectin69.wounds)
				if(W.internal)
					continue
				if(W.banda69ed && W.disinfected)
					continue
				if(used == amount)
					break
				if(!do_mob(user,69, W.dama69e/5))
					to_chat(user, SPAN_NOTICE("You69ust stand still to banda69e wounds."))
					break
				if(W.internal)
					continue
				if(W.banda69ed && W.disinfected)
					continue
				if(used == amount)
					break
				if (W.current_sta69e <= W.max_bleedin69_sta69e)
					user.visible_messa69e(
						SPAN_NOTICE("\The 69user69 cleans \a 69W.desc69 on 69M69's 69affectin69.name69 and seals the ed69es with bio69lue."),
						SPAN_NOTICE("You clean and seal \a 69W.desc69 on 69M69's 69affectin69.name69.")
					)
				else if (W.dama69e_type == BRUISE)
					user.visible_messa69e(
						SPAN_NOTICE("\The 69user69 places a69edical patch over \a 69W.desc69 on 69M69's 69affectin69.name69."),
						SPAN_NOTICE("You place a69edical patch over \a 69W.desc69 on 69M69's 69affectin69.name69.")
					)
				else
					user.visible_messa69e(
						SPAN_NOTICE("\The 69user69 smears some bio69lue over \a 69W.desc69 on 69M69's 69affectin69.name69."),
						SPAN_NOTICE("You smear some bio69lue over \a 69W.desc69 on 69M69's 69affectin69.name69.")
					)
				W.banda69e()
				W.disinfect()
				W.heal_dama69e(heal_brute)
				if(prob(10 + user.stats.69etStat(STAT_BIO)))
					to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
				else
					used++
			affectin69.update_dama69es()
			// user's stat check that causin69 pain if they are amateurs
			if(user && user.stats.69etStat(STAT_BIO) < STAT_LEVEL_BASIC)
				if(prob(affectin69.69et_dama69e() - user.stats.69etStat(STAT_BIO)))
					var/pain = rand(min(30,affectin69.69et_dama69e()),69ax(affectin69.69et_dama69e() + 30,60) - user.stats.69etStat(STAT_BIO))
					H.pain(affectin69, pain)
					if(user != H)
						to_chat(H, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>\The 69user69's amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
						to_chat(user, SPAN_WARNIN69("Your amateur actions caused 69H69 69pain > 50 ? "a lot of " : ""69pain."))
					else
						to_chat(user, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>Your amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
			if(used == amount)
				if(affectin69.is_banda69ed())
					to_chat(user, SPAN_WARNIN69("\The 69src69 is used up."))
				else
					to_chat(user, SPAN_WARNIN69("\The 69src69 is used up, but there are69ore wounds to treat on \the 69affectin69.name69."))
			use(used)
			update_icon()
	else
		if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if69ob is lyin69 down on table for sur69ery
			if (do_sur69ery(H,user,src, TRUE))
				return
		else
			to_chat(user, SPAN_NOTICE("The 69affectin69.name69 is cut open, you'll need69ore than a banda69e!"))

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	sin69ular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 8
	ori69in_tech = list(TECH_BIO = 2)
	automatic_char69e_overlays = TRUE
	consumable = FALSE	// Will the stack disappear entirely once the amount is used up?
	splittable = FALSE	// Is the stack capable of bein69 splitted?
	preloaded_rea69ents = list("silicon" = 4, "ethanol" = 10, "mercury" = 4)
	rarity_value = 10

/obj/item/stack/medical/advanced/ointment/attack(mob/livin69/carbon/M,69ob/livin69/user)
	if(..())
		return 1

	if(amount < 1)
		return

	if (ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/obj/item/or69an/external/affectin69 = H.69et_or69an(user.tar69eted_or69an)

		if(!affectin69)
			to_chat(user, SPAN_WARNIN69("What 69user.tar69eted_or69an69?"))
			return TRUE

		if(affectin69.open == 0)
			if(affectin69.is_salved())
				to_chat(user, SPAN_WARNIN69("The wounds on 69M69's 69affectin69.name69 have already been salved."))
				return 1
			else
				user.visible_messa69e(
					SPAN_NOTICE("\The 69user69 starts salvin69 wounds on 69M69's 69affectin69.name69."),
					SPAN_NOTICE("You start salvin69 the wounds on 69M69's 69affectin69.name69.")
				)
				if(!do_mob(user,69, 10))
					to_chat(user, SPAN_NOTICE("You69ust stand still to salve wounds."))
					return 1
				user.visible_messa69e(
					SPAN_NOTICE("69user69 covers wounds on 69M69's 69affectin69.name69 with re69enerative69embrane."),
					SPAN_NOTICE("You cover wounds on 69M69's 69affectin69.name69 with re69enerative69embrane.")
				)
				affectin69.heal_dama69e(0,heal_burn)
				if(prob(10 + user.stats.69etStat(STAT_BIO)))
					to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
				else
					use(1)
					update_icon()
				affectin69.salve()
				// user's stat check that causin69 pain if they are amateurs
				if(user && user.stats.69etStat(STAT_BIO) < STAT_LEVEL_BASIC)
					if(prob(affectin69.69et_dama69e() - user.stats.69etStat(STAT_BIO)))
						var/pain = rand(min(30,affectin69.69et_dama69e()),69ax(affectin69.69et_dama69e() + 30,60) - user.stats.69etStat(STAT_BIO))
						H.pain(affectin69, pain)
						if(user != H)
							to_chat(H, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>\The 69user69's amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
							to_chat(user, SPAN_WARNIN69("Your amateur actions caused 69H69 69pain > 50 ? "a lot of " : ""69pain."))
						else
							to_chat(user, "<span class='69pain > 50 ? "dan69er" : "warnin69"69'>Your amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
		else
			if (can_operate(H, user) == CAN_OPERATE_ALL)        //Checks if69ob is lyin69 down on table for sur69ery
				if (do_sur69ery(H,user,src, TRUE))
					return
			else
				to_chat(user, SPAN_NOTICE("The 69affectin69.name69 is cut open, you'll need69ore than a banda69e!"))

/obj/item/stack/medical/splint
	name = "medical splints"
	sin69ular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	rarity_value = 20
	spawn_ta69s = SPAWN_TA69_MEDICINE_COMMON

/obj/item/stack/medical/splint/attack(mob/livin69/carbon/M,69ob/livin69/user)
	if(..())
		return 1

	if (ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/obj/item/or69an/external/affectin69 = H.69et_or69an(user.tar69eted_or69an)

		if(!affectin69)
			to_chat(user, SPAN_WARNIN69("What 69user.tar69eted_or69an69?"))
			return TRUE

		var/limb = affectin69.name
		if(!(affectin69.or69an_ta69 in list(BP_R_ARM, BP_L_ARM, BP_R_LE69, BP_L_LE69, BP_69ROIN, BP_HEAD, BP_CHEST)))
			to_chat(user, SPAN_DAN69ER("You can't apply a splint there!"))
			return
		if(affectin69.status & OR69AN_SPLINTED)
			to_chat(user, SPAN_DAN69ER("69M69's 69limb69 is already splinted!"))
			return
		if (M != user)
			user.visible_messa69e(
				SPAN_DAN69ER("69user69 starts to apply \the 69src69 to 69M69's 69limb69."),
				SPAN_DAN69ER("You start to apply \the 69src69 to 69M69's 69limb69."),
				SPAN_DAN69ER("You hear somethin69 bein69 wrapped.")
			)
		else
			if((!user.hand && affectin69.or69an_ta69 == BP_R_ARM) || (user.hand && affectin69.or69an_ta69 == BP_L_ARM))
				to_chat(user, SPAN_DAN69ER("You can't apply a splint to the arm you're usin69!"))
				return
			user.visible_messa69e(
				SPAN_DAN69ER("69user69 starts to apply \the 69src69 to their 69limb69."),
				SPAN_DAN69ER("You start to apply \the 69src69 to your 69limb69."),
				SPAN_DAN69ER("You hear somethin69 bein69 wrapped.")
			)
		if(do_after(user,69ax(0, 60 - user.stats.69etStat(STAT_BIO)),69))
			if (M != user)
				user.visible_messa69e(
					SPAN_DAN69ER("69user69 finishes applyin69 \the 69src69 to 69M69's 69limb69."),
					SPAN_DAN69ER("You finish applyin69 \the 69src69 to 69M69's 69limb69."),
					SPAN_DAN69ER("You hear somethin69 bein69 wrapped.")
				)
			else
				if(prob(25 + user.stats.69etStat(STAT_BIO)))
					user.visible_messa69e(
						SPAN_DAN69ER("69user69 successfully applies \the 69src69 to their 69limb69."),
						SPAN_DAN69ER("You successfully apply \the 69src69 to your 69limb69."),
						SPAN_DAN69ER("You hear somethin69 bein69 wrapped.")
					)
				else
					user.visible_messa69e(
						SPAN_DAN69ER("69user69 fumbles \the 69src69."),
						SPAN_DAN69ER("You fumble \the 69src69."),
						SPAN_DAN69ER("You hear somethin69 bein69 wrapped.")
					)
					return
			affectin69.status |= OR69AN_SPLINTED
			if(prob(10 + user.stats.69etStat(STAT_BIO)))
				to_chat(user, SPAN_NOTICE("You have69ana69ed to waste less 69src69."))
			else
				use(1)
		return

/obj/item/stack/medical/advanced/bruise_pack/nt
	name = "NeoTheolo69ian Bruisepack"
	sin69ular_name = "NeoTheolo69ian Bruisepack"
	desc = "An advanced bruisepack for severe injuries. Created by will of 69od."
	icon_state = "nt_traumakit"
	heal_brute = 10
	automatic_char69e_overlays = FALSE
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 3)
	ori69in_tech = list(TECH_BIO = 4)

/obj/item/stack/medical/advanced/bruise_pack/nt/update_icon()
	icon_state = "69initial(icon_state)6969amount69"
	..()

/obj/item/stack/medical/advanced/ointment/nt
	name = "NeoTheolo69ian Burnpack"
	sin69ular_name = "NeoTheolo69ian Burnpack"
	desc = "An advanced treatment kit for severe burns. Created by will of 69od."
	icon_state = "nt_burnkit"
	heal_brute = 10
	automatic_char69e_overlays = FALSE
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 3)
	ori69in_tech = list(TECH_BIO = 4)

/obj/item/stack/medical/advanced/ointment/nt/update_icon()
	icon_state = "69initial(icon_state)6969amount69"
	..()
