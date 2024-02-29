
//New shotgun dm, could be expanded
/obj/item/gun/projectile/shotgun
	spawn_tags = SPAWN_TAG_GUN_SHOTGUN
	bad_type = /obj/item/gun/projectile/shotgun
	rarity_value = 10
	spawn_frequency = 10
	twohanded = TRUE
	var/recentpumpmsg = 0 //	Variable to prevent chat message spam
	var/fired_one_handed = FALSE
	/// How much angle offset does our shotgun have?
	var/angleOffset = 12
	wield_delay = 0 SECOND
	wield_delay_factor = 0

/obj/item/gun/projectile/shotgun/twohanded_check(var/mob/living/user)
	if(twohanded && !wielded)
		user.recoil += 10
		fired_one_handed = TRUE
	return TRUE

/obj/item/gun/projectile/shotgun/process_projectile(obj/item/projectile/P, mob/living/user, atom/target, target_zone, params)
	if(istype(P, /obj/item/projectile/bullet/shotgunBuckshot))
		var/obj/item/projectile/bullet/shotgunBuckshot/buck = P
		buck.angleOffset = src.angleOffset
	. = ..()

/obj/item/gun/projectile/shotgun/handle_post_fire(var/mob/living/user)
	..()
	if(fired_one_handed)
		fired_one_handed = FALSE
		var/robustness = user.stats.getStat(STAT_ROB)
		if(robustness < STAT_LEVEL_GODLIKE)
			if(!prob(robustness))
				step(user, pick(cardinal - user.dir))
