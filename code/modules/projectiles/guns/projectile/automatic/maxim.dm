obj/item/weapon/gun/projectile/automatic/maxim
	name = "Excelsior machine gun"
	desc = ""
	icon_state = "maxim"
	item_state = "maxim"
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = 0
	max_shells = 96
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	ammo_type = "/obj/item/ammo_casing/a762"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/maxim
	matter = list(MATERIAL_PLASTEEL = 42, MATERIAL_PLASTIC = 15, MATERIAL_WOOD = 5)
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'
	burst_delay = 2

	firemodes = list(
		list(mode_name="short bursts", burst=5,    burst_delay=2, move_delay=6, dispersion=list(0.0, 0.6, 0.6, 0.8, 1.0)),
		list(mode_name="long bursts",  burst=8, burst_delay=2, move_delay=8, dispersion=list(0.0, 0.6, 0.6, 0.8, 1.0, 1.2, 1.2, 1.2)),
		list(mode_name="suppressing fire",  burst=16, burst_delay=1, move_delay=11, dispersion=list(1.0, 1.2, 1.2, 1.2, 1.4, 1.4, 1.4, 1.4, 1.4, 1.4, 1.4, 1.6, 1.6, 2.0, 2.0, 2.2))
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
	if(cover_open)
		user << SPAN_WARNING("[src]'s cover is open! Close it before firing!")
		return 0
	return ..()
