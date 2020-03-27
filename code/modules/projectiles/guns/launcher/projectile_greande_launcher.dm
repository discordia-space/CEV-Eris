obj/item/weapon/gun/projectile/china
    name = "China Lake"
    desc = "This centuries-old design was recently rediscovered and adapted for use in modern battlefields. \
        Working similar to a pump-action combat shotgun, its light weight and robust design quickly made it a popular weapon. \
        It uses specialised grenade shells."
    icon = 'icons/obj/guns/projectile/chinalake.dmi'
    icon_state = "china_lake"
    item_state = "china_lake"
    w_class = ITEM_SIZE_HUGE
    slot_flags = SLOT_BACK
    force = WEAPON_FORCE_PAINFUL
    matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_WOOD = 10)  //Work on those numbers later 
    price_tag = 4500
    caliber = CAL_GRENADE
    load_method = SINGLE_CASING
    origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
    handle_casings = HOLD_CASINGS
    fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
    bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'   //Placeholder, could use a new sound
    max_shells = 3
    recoil_buildup = 20
    twohanded = TRUE
    var/recentpumpmsg = 0

/obj/item/weapon/gun/projectile/china/consume_next_projectile()    //Taken from shotgun/pump
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/china/attack_self(mob/living/user as mob)
	if(wielded)
		pump(user)
	else if(world.time >= recentpumpmsg + 5)
		to_chat(user, SPAN_WARNING("You need to wield this gun to pump it!"))
		recentpumpmsg = world.time

/obj/item/weapon/gun/projectile/china/proc/pump(mob/M as mob)
	var/turf/newloc = get_turf(src)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.forceMove(newloc) //Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()


