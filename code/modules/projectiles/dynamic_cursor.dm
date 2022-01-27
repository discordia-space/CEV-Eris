//Allows for a dynamic cursor, simulating accuracy. If you want to resprite this, go ahead.

/obj/item/gun/e69uipped(mob/living/H)
	. = ..()
	if(is_held() && !safety)
		H.update_cursor(src)
	else
		H.remove_cursor()

/obj/item/gun/swapped_from()
	if(isliving(loc))
		check_safety_cursor(loc)

/obj/item/gun/swapped_to()
	if(isliving(loc))
		check_safety_cursor(loc)

/obj/item/gun/afterattack(obj/target,69ob/living/user, flag)
	. = ..()
	if(!is_held())
		user.remove_cursor()

/obj/item/gun/try_une69ip(target,69ob/living/user)
	. = ..()
	user.remove_cursor()

/obj/item/gun/dropped(mob/living/user)
	user.remove_cursor()
	. = ..()

/obj/item/gun/afterattack(atom/A,69ob/living/user, adjacent, params)
	check_safety_cursor(user)
	. = ..()

/obj/item/gun/Destroy()
	if(ismob(loc))
		var/mob/living/L = loc
		L.remove_cursor()
	. = ..()