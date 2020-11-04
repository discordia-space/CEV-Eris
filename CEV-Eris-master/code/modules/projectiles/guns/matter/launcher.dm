/obj/item/weapon/gun/matter/launcher
	w_class = ITEM_SIZE_HUGE

	var/release_force = 1
	var/throw_distance = 7
	muzzle_flash = 0

//This normally uses a proc on projectiles and our ammo is not strictly speaking a projectile.
/obj/item/weapon/gun/matter/launcher/can_hit(mob/living/target, mob/living/user)
	return 1

/obj/item/weapon/gun/matter/launcher/handle_suicide(mob/living/user)
	to_chat(user, SPAN_WARNING("Shooting yourself with \a [src] is pretty tricky. You can't seem to manage it."))
	return

/obj/item/weapon/gun/matter/launcher/proc/update_release_force(obj/item/projectile)
	return 0

/obj/item/weapon/gun/matter/launcher/process_projectile(obj/item/projectile, mob/user, atom/target)
	update_release_force(projectile)
	projectile.loc = get_turf(user)
	projectile.throw_at(target, throw_distance, release_force, user)
	return 1
