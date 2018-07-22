/obj/item/weapon/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/traps.dmi'
	icon_state = "beartrap0"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = WEAPON_FORCE_WEAK
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "materials=1"
	matter = list(MATERIAL_STEEL = 6)
	var/deployed = 0

/obj/item/weapon/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			SPAN_DANGER("[user] starts to deploy \the [src]."),
			SPAN_DANGER("You begin deploying \the [src]!"),
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60, src))
			user.visible_message(
				SPAN_DANGER("\The [user] has deployed \the [src]."),
				SPAN_DANGER("You have deployed \the [src]!"),
				"You hear a latch click loudly."
				)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = 1

/obj/item/weapon/beartrap/attack_hand(mob/user as mob)
	if(buckled_mob && can_use(user))
		user.visible_message(
			SPAN_NOTICE("[user] begins freeing [buckled_mob] from \the [src]."),
			SPAN_NOTICE("You carefully begin to free [buckled_mob] from \the [src]."),
			)
		if(do_after(user, 60, src))
			user.visible_message(SPAN_NOTICE("[buckled_mob] has been freed from \the [src] by [user]."))
			unbuckle_mob()
			anchored = 0
	else if(deployed && can_use(user))
		user.visible_message(
			SPAN_DANGER("[user] starts to disarm \the [src]."),
			SPAN_NOTICE("You begin disarming \the [src]!"),
			"You hear a latch click followed by the slow creaking of a spring."
			)
		if(do_after(user, 60, src))
			user.visible_message(
				SPAN_DANGER("[user] has disarmed \the [src]."),
				SPAN_NOTICE("You have disarmed \the [src]!")
				)
			deployed = 0
			anchored = 0
			update_icon()
	else
		..()

/obj/item/weapon/beartrap/proc/attack_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG , BP_R_LEG)

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")

	if(blocked >= 2)
		return

	if(!L.apply_damage(30, BRUTE, target_zone, blocked, used_weapon=src))
		return 0

	//trap the victim in place
	if(!blocked)
		set_dir(L.dir)
		can_buckle = 1
		buckle_mob(L)
		L << SPAN_DANGER("The steel jaws of \the [src] bite into you, trapping you in place!")
		deployed = 0
		can_buckle = initial(can_buckle)

/obj/item/weapon/beartrap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == "run")
			L.visible_message(
				SPAN_DANGER("[L] steps on \the [src]."),
				SPAN_DANGER("You step on \the [src]!"),
				"<b>You hear a loud metallic snap!</b>"
				)
			attack_mob(L)
			if(!buckled_mob)
				anchored = 0
			deployed = 0
			update_icon()
	..()

/obj/item/weapon/beartrap/update_icon()
	..()

	if(!deployed)
		icon_state = "beartrap0"
	else
		icon_state = "beartrap1"
