/obj/item/weapon/gun/projectile/automatic/maxim
	name = "Excelsior machine gun"
	desc = ""
	icon_state = "maxim"
	item_state = "maxim"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	slot_flags = 0
	max_shells = 96
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	ammo_type = "/obj/item/ammo_casing/a762"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PAN
	tac_reloads = FALSE
	magazine_type = /obj/item/ammo_magazine/maxim
	matter = list(MATERIAL_PLASTEEL = 42, MATERIAL_PLASTIC = 15, MATERIAL_WOOD = 5)
	price_tag = 5000
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'
	recoil_buildup = 0.3 //machinegun level

	firemodes = list(
		FULL_AUTO_600,
		list(mode_name="short bursts", burst=5,    burst_delay=1, move_delay=6,  icon="burst"),
		list(mode_name="long bursts",  burst=8, burst_delay=1, move_delay=8,  icon="burst"),
		list(mode_name="suppressing fire",  burst=16, burst_delay=1, move_delay=11,  icon="burst")
		)



/obj/item/weapon/gun/projectile/automatic/maxim/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		item_state = "[initial(item_state)]-full"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	return

/obj/item/weapon/gun/projectile/automatic/maxim/special_check(mob/user)
	if(!(user.get_active_hand() == src && user.get_inactive_hand() == null))
		to_chat(user, SPAN_WARNING("You can't fire \the [src] with [user.get_inactive_hand()] in the other hand."))
		return FALSE
	return ..()
