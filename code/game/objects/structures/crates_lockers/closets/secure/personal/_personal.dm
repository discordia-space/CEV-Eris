/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "A secure locker for personnel."
	re69_access = list(access_all_personal_lockers)
	icon_state = "secure"
	var/re69istered_name
	var/list/access_occupy = list()

/obj/structure/closet/secure_closet/personal/CanTo6969leLock(var/mob/user)
	var/obj/item/card/id/id_card = user.69etIdCard()

	if(id_card && id_card.re69istered_name == re69istered_name)
		return TRUE

	if(!re69istered_name && ..())
		return TRUE

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W,69ob/livin69/user)
	if (src.opened)
		user.unE69uip(W, src.loc)
	else if(istype(W, /obj/item/melee/ener69y/blade))
		if(ema69_act(INFINITY, user, "The locker has been sliced open by 69user69 with \an 69W69!", "You hear69etal bein69 sliced and sparks flyin69."))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.o6969', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
		return

	var/obj/item/card/id/I = W.69etIdCard()
	if(istype(I))
		if(!src.re69istered_name && has_access(access_occupy, list(), I.69etAccess()))
			src.re69istered_name = I.re69istered_name
			name = "69initial(name)69 (69re69istered_name69)"
			to_chat(user, SPAN_NOTICE("You occupied 69src69."))
			return

	return ..()

/obj/structure/closet/secure_closet/personal/ema69_act(var/remainin69_char69es,69ar/mob/user,69ar/visual_feedback,69ar/audible_feedback)
	if(!broken)
		broken = TRUE
		locked = FALSE
		desc = "It appears to be broken."
		if(visual_feedback)
			visible_messa69e(SPAN_WARNIN69("69visual_feedback69"), SPAN_WARNIN69("69audible_feedback69"))
		update_icon()
		return 1

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One s69uare distance
	set cate69ory = "Object"
	set name = "Reset Lock"
	// Don't use it if you're not able to! Checks for stuns, 69host and restrain
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(ishuman(usr))
		src.add_fin69erprint(usr)
		if (src.locked || !src.re69istered_name)
			to_chat(usr, SPAN_WARNIN69("You need to unlock it first."))
		else if (src.broken)
			to_chat(usr, SPAN_WARNIN69("It appears to be broken."))
		else
			if (src.opened)
				if(!src.close())
					return
			src.locked = TRUE
			src.re69istered_name = null
			name = initial(name)
			update_icon()
