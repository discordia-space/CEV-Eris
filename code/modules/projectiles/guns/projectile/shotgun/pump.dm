/obj/item/gun/projectile/shotgun/pump
	name = "FS SG \"Kammerer\""
	desc = "When an old Remington design meets modern materials, this is the result. A favourite weapon of militia forces throughout many worlds. Can hold up to 4+1 shells in its tube"
	icon = 'icons/obj/guns/projectile/shotgun.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	volumeClass = ITEM_SIZE_HUGE
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	price_tag = 800
	damage_multiplier = 1.1
	init_recoil = RIFLE_RECOIL(2.8)
	spawn_tags = SPANW_TAG_FS_SHOTGUN
	saw_off = TRUE
	sawn = /obj/item/gun/projectile/shotgun/pump/sawn
	gun_parts = list(/obj/item/part/gun/frame/kammerer = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/shotgun = 1, /obj/item/part/gun/modular/barrel/shotgun = 1)
	serial_type = "FS"

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

/obj/item/part/gun/frame/kammerer
	name = "Kammerer frame"
	desc = "A Kammerer shotgun frame. A militiaman's favorite."
	icon_state = "frame_shotgun"
	resultvars = list(/obj/item/gun/projectile/shotgun/pump)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/shotgun
	barrelvars = list(/obj/item/part/gun/modular/barrel/shotgun)

/obj/item/gun/projectile/shotgun/pump/sawn
	name = "sawn-off FS SG \"Kammerer\""
	desc = "When an old Remington design meets a hacksaw, this is the result. Hacked up, sawn down, and ready to rob a liquor store."
	icon = 'icons/obj/guns/projectile/obrez_sg.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	max_shells = 3
	volumeClass = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_WOOD = 5)
	proj_step_multiplier = 1.1 // becomes 1.2 with slugs, following bolt action sawn off behaviour
	ammo_type = /obj/item/ammo_casing/shotgun/pellet/scrap
	price_tag = 350
	damage_multiplier = 1
	init_recoil = CARBINE_RECOIL(4) // 48 recoil -> 32, still huge
	can_dual = TRUE
	saw_off = FALSE
	spawn_blacklisted = TRUE
