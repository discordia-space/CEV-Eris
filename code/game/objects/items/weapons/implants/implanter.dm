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

/obj/item/weapon/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && src.implant)
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 50, M)))
			if(user && M && (get_turf(M) == T1) && src && src.implant)
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")
				admin_attack_log(user, M, "Implanted using \the [src.name] ([src.implant.name])", "Implanted with \the [src.name] ([src.implant.name])", "used an implanter, [src.name] ([src.implant.name]), on")
				src.implant.install(M, user.targeted_organ)
				src.implant = null
				update()

	return
