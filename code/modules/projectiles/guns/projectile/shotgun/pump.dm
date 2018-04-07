/obj/item/weapon/gun/projectile/shotgun/pump
	name = "FS SG \"Kammerer\""
	desc = "Old Remington design from modern materials, this shotgun is a favourite of militia forces on many worlds."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFULL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	bulletinsert_sound 	= 'sound/weapons/guns/interact/shotgun_instert.ogg'
	var/recentpump = 0 // to prevent spammage
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()
