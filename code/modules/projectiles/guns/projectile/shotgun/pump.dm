/obj/item/gun/projectile/shotgun/pump
	name = "FS SG \"Kammerer\""
	desc = "When an old Remington design meets modern materials, this is the result. A favourite weapon of militia forces throughout many worlds."
	icon = 'icons/obj/guns/projectile/shotgun.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/guns/fire/cal/shotgun.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	price_tag = 800
	recoil_buildup = 12
	one_hand_penalty = 15 //full sized shotgun level
	spawn_tags = SPANW_TAG_FS_SHOTGUN
	saw_off = TRUE
	sawn = /obj/item/gun/projectile/shotgun/pump/sawn
	wield_delay = 0.6 SECOND
	wield_delay_factor = 0.3 // 40 vig

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user)
	if(world.time >= recentpumpmsg + 10)
		pump(user)
		recentpumpmsg = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M)
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

/obj/item/gun/projectile/shotgun/pump/sawn
	name = "sawn-off FS SG \"Kammerer\""
	desc = "When an old Remington design meets a hacksaw, this is the result. Hacked up, sawn down, and ready to rob a liquor store."
	icon = 'icons/obj/guns/projectile/obrez_sg.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	max_shells = 3
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_WOOD = 5)
	ammo_type = /obj/item/ammo_casing/shotgun/pellet/scrap
	price_tag = 350
	damage_multiplier = 0.5
	penetration_multiplier = 0.7
	recoil_buildup = 24 //double that of full version
	one_hand_penalty = 20 //more than shotgun
	can_dual = TRUE
	saw_off = FALSE
	spawn_blacklisted = TRUE
