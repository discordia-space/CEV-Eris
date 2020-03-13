/obj/item/weapon/gun/projectile/shotgun/pump
	name = "FS SG \"Kammerer\""
	desc = "When an old Remington design meets modern materials, this is the result. A favourite weapon of militia forces throughout many worlds."
	icon = 'icons/obj/guns/projectile/shotgun.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	bulletinsert_sound 	= 'sound/weapons/guns/interact/shotgun_insert.ogg'
	var/recentpump = 0 // to prevent spammage
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	price_tag = 2200
	recoil_buildup = 20
	one_hand_penalty = 15 //full sized shotgun level

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10  & wielded)
		pump(user)
		recentpump = world.time
	else
		to_chat(user, SPAN_DANGER("You need to wield this gun to pump it!"))

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
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
