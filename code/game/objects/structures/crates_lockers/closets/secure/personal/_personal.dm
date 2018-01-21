/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel."
	req_access = list(access_all_personal_lockers)
	var/registered_name = null
	var/list/access_occupy = list()
	icon_state = "secure"

/obj/structure/closet/secure_closet/personal/check_access(obj/item/weapon/card/id/I)
	if(istype(I))
		if(I.registered_name == src.registered_name)
			return TRUE
	return ..()

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W, mob/living/user)
	if (src.opened)
		user.unEquip(W, src.loc)
	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		if(emag_act(INFINITY, user, "The locker has been sliced open by [user] with \an [W]!", "You hear metal being sliced and sparks flying."))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
		return

	var/obj/item/weapon/card/id/I = W.GetID()
	if(istype(I))
		if(!src.registered_name && has_access(access_occupy, list(), I.GetAccess()))
			src.registered_name = I.registered_name
			name = "[initial(name)] ([registered_name])"
			user << SPAN_NOTICE("You occupied [src].")
			return

	return ..()

/obj/structure/closet/secure_closet/personal/emag_act(var/remaining_charges, var/mob/user, var/visual_feedback, var/audible_feedback)
	if(!broken)
		broken = TRUE
		locked = FALSE
		desc = "It appears to be broken."
		if(visual_feedback)
			visible_message(SPAN_WARNING("[visual_feedback]"), SPAN_WARNING("[audible_feedback]"))
		update_icon()
		return 1

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"
	// Don't use it if you're not able to! Checks for stuns, ghost and restrain
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(ishuman(usr))
		src.add_fingerprint(usr)
		if (src.locked || !src.registered_name)
			usr << SPAN_WARNING("You need to unlock it first.")
		else if (src.broken)
			usr << SPAN_WARNING("It appears to be broken.")
		else
			if (src.opened)
				if(!src.close())
					return
			src.locked = TRUE
			src.registered_name = null
			name = initial(name)
			update_icon()
