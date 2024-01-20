/obj/item/implanter
	name = "implanter"
	desc = "A medical applicator of small electronics called implants."
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	volumeClass = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_STEEL = 1)
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
	to_chat(user, SPAN_NOTICE("You remove \the [implant] from \the [src]."))
	name = "implanter"
	implant = null
	update_icon()
	return

/obj/item/implanter/update_icon()
	cut_overlays()
	if(implant)
		var/image/content = image('icons/obj/items.dmi', icon_state = implant.implant_overlay)
		add_overlay(content)

/obj/item/implanter/attack(mob/living/M, mob/living/user)
	if(!istype(M) || !implant)
		return
	if(!implant.is_external())
		if(M.body_part_covered(user.targeted_organ))
			to_chat(user, SPAN_WARNING("You can't implant through clothes."))
			return

	var/obj/item/organ/external/affected = null
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		affected = H.get_organ(user.targeted_organ)

	M.visible_message(SPAN_WARNING("[user] is attemping to implant [M]."))

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(do_mob(user, M, 50) && src && implant)


		if(implant.install(M, user.targeted_organ, user))
			M.visible_message(
			SPAN_WARNING("[user] has implanted [M] in [affected]."),
			SPAN_NOTICE("You implanted \the [implant] into [M]'s [affected].")
			)

			admin_attack_log(user, M,
			"Implanted using \the [src.name] ([implant.name])",
			"Implanted with \the [src.name] ([implant.name])",
			"used an implanter, [src.name] ([implant.name]), on"
			)
			implant = null
			update_icon()

/obj/item/implanter/installer
	name = "cybernetic installer"
	desc = "A medical applicator of cybernetics."
	icon_state = "installer_empty"
	volumeClass = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_PLASTIC = 5, MATERIAL_STEEL = 3)
	var/obj/item/organ_module/mod
	var/mod_overlay = null
	spawn_blacklisted = TRUE

/obj/item/implanter/installer/New()
	..()
	if(ispath(mod))
		mod = new mod(src)
		update_icon()

/obj/item/implanter/installer/attack_self(mob/user)
	if(!mod)
		return ..()
	user.put_in_hands(mod)
	to_chat(user, SPAN_NOTICE("You remove \the [mod] from \the [src]."))
	mod = null
	update_icon()
	return

/obj/item/implanter/installer/update_icon()
	if(mod)
		if(mod.mod_overlay == null)
			icon_state = "installer_full"
		else
			icon_state = mod.mod_overlay
	else
		icon_state = "installer_empty"

/obj/item/implanter/installer/attack(mob/living/M, mob/living/user)
	if(!istype(M) || !mod)
		return

	var/obj/item/organ/external/affected = null
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		affected = H.get_organ(user.targeted_organ)
	
		if(!affected)
			to_chat(user, SPAN_WARNING("[M] is missing that body part."))
			return

		if(!(affected.organ_tag in mod.allowed_organs))
			to_chat(user, SPAN_NOTICE("You cannot install the [mod] into the [affected]."))
			return
	
		if(affected.module != null) //Probably not the most effective way to do this, but it works.
			to_chat(user, SPAN_WARNING("[mod] cannot be installed into this [affected], as it's already occupied."))
			return

	M.visible_message(SPAN_WARNING("[user] is attemping to install something into [M]."))

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(do_mob(user, M, 50) && src && mod)

		if(mod.install(affected))
			M.visible_message(
			SPAN_WARNING("[user] has installed something into [M]'s' [affected]."),
			SPAN_NOTICE("You installed \the [mod] into [M]'s [affected].")
			)

			admin_attack_log(user, M,
			"Installed using \the [src.name] ([mod.name])",
			"Installed with \the [src.name] ([mod.name])",
			"used an installer, [src.name] ([mod.name]), on"
			)

		mod = null
		update_icon()

/obj/item/implanter/installer/disposable
	name = "cybernetic installer (disposable)"
	desc = "A single use medical applicator of cybernetics."

/obj/item/implanter/installer/disposable/New()
	..()
	if(ispath(mod))
		mod = new mod(src)
		update_icon()
