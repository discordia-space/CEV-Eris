/obj/item/weapon/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	var/obj/item/weapon/implant/implant = null
	var/implant_type = null

/obj/item/weapon/implanter/New()
	if(implant_type)
		src.implant = new implant_type(src)
	..()
	update()
	return

/obj/item/weapon/implanter/attack_self(var/mob/user)
	if(!implant)
		return ..()
	implant.loc = get_turf(src)
	user.put_in_hands(implant)
	user << "<span class='notice'>You remove \the [implant] from \the [src].</span>"
	name = "implanter"
	implant = null
	update()
	return

/obj/item/weapon/implanter/proc/update()
	if (src.implant)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return

/obj/item/weapon/implanter/attack(mob/living/L as mob, mob/user as mob)
	if (!istype(L, /mob/living/carbon))
		return
	var/mob/living/carbon/M = L
	if (user && src.implant && !src.implant.is_external())
		if(M.body_part_covered(user.targeted_organ))
			user << "<span class='warning'>You can't implant through clothes.</span>"
			return
		if(src.implant.allowed_organs.len && !(user.targeted_organ in src.implant.allowed_organs))
			user << "<span class='warning'>[src.implant] cannot be implaned in this limb.</span>"
			return
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 50, M)))
			if(user && M && (get_turf(M) == T1) && src && src.implant)
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")
				admin_attack_log(user, M, "Implanted using \the [src.name] ([src.implant.name])", "Implanted with \the [src.name] ([src.implant.name])", "used an implanter, [src.name] ([src.implant.name]), on")
				src.implant.install(M, user.targeted_organ)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.update_implants()
				src.implant = null
				update()

	return
