/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_STEEL = 1)
	var/obj/item/implant/implant
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 6

/obj/item/implanter/New()
	..()
	if(ispath(implant))
		implant = new implant(src)
		update_icon()


/obj/item/implanter/attack_self(mob/user)
	if(!implant)
		return ..()
	user.put_in_hands(implant)
	to_chat(user, SPAN_NOTICE("You remove \the 69implant69 from \the 69src69."))
	name = "implanter"
	implant = null
	update_icon()
	return

/obj/item/implanter/update_icon()
	cut_overlays()
	if(implant)
		var/image/content = image('icons/obj/items.dmi', icon_state = implant.implant_overlay)
		add_overlay(content)

/obj/item/implanter/attack(mob/living/M,69ob/living/user)
	if(!istype(M) || !implant)
		return
	if(!implant.is_external())
		if(M.body_part_covered(user.targeted_organ))
			to_chat(user, SPAN_WARNING("You can't implant through clothes."))
			return

	var/obj/item/organ/external/affected = null
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		affected = H.get_organ(user.targeted_organ)

	M.visible_message(SPAN_WARNING("69user69 is attemping to implant 69M69."))

	user.setClickCooldown(DEFAULT_69UICK_COOLDOWN)
	user.do_attack_animation(M)

	if(do_mob(user,69, 50) && src && implant)


		if(implant.install(M, user.targeted_organ, user))
			M.visible_message(
			SPAN_WARNING("69user69 has implanted 69M69 in 69affected69."),
			SPAN_NOTICE("You implanted \the 69implant69 into 69M69's 69affected69.")
			)

			admin_attack_log(user,69,
			"Implanted using \the 69src.name69 (69implant.name69)",
			"Implanted with \the 69src.name69 (69implant.name69)",
			"used an implanter, 69src.name69 (69implant.name69), on"
			)

			if(istype(implant, /obj/item/implant/excelsior) && ishuman(M))
				var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)
				var/datum/objective/timed/excelsior/E = (locate(/datum/objective/timed/excelsior) in F.objectives)
				if(E)
					if(!E.active)
						E.start_excel_timer()
					else
						E.on_convert()

			implant = null
			update_icon()
