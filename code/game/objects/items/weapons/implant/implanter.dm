/obj/item/weapon/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	var/obj/item/weapon/implant/implant = null

/obj/item/weapon/implanter/New()
	..()
	if(ispath(implant))
		implant = new implant(src)
		update_icon()


/obj/item/weapon/implanter/attack_self(var/mob/user)
	if(!implant)
		return ..()
	user.put_in_hands(implant)
	user << "<span class='notice'>You remove \the [implant] from \the [src].</span>"
	name = "implanter"
	implant = null
	update_icon()
	return

/obj/item/weapon/implanter/update_icon()
	if(implant)
		icon_state = "implanter1"
	else
		icon_state = "implanter0"
	return

/obj/item/weapon/implanter/attack(mob/living/carbon/M, mob/living/user)
	if(!istype(M) || !implant)
		return
	if(!implant.is_external())
		if(M.body_part_covered(user.targeted_organ))
			user << "<span class='warning'>You can't implant through clothes.</span>"
			return

	var/obj/item/organ/external/affected = null
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		affected = H.get_organ(user.targeted_organ)

	M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(do_mob(user, M, 50) && src && implant)
		M.visible_message(
			"<span class='warning'>[user] has implanted [M] in [affected].</span>",
			"<span class='notice'>You implanted \the [implant] into [M]'s [affected].</span>"
		)

		admin_attack_log(user, M,
			"Implanted using \the [src.name] ([implant.name])",
			"Implanted with \the [src.name] ([implant.name])",
			"used an implanter, [src.name] ([implant.name]), on"
		)

		if(implant.install(M, user.targeted_organ, user))
			implant = null
			update_icon()
