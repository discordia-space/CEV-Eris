/obj/item/weapon/gun/projectile/automatic/bulldog
	name = "Syndicate SG \"Foxhound\""
	desc = "A semi-auto, mag-fed shotgun for combat in narrow corridors, nicknamed 'Bulldog' by boarding parties. \
	Compatible only with specialized 8-round drum magazines."
	icon = 'icons/obj/guns/projectile/bulldog.dmi'
	icon_state = "bulldog"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = "shotgun"
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/m12
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 5000
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	recoil_buildup = 0.7
	damage_multiplier = 0.7

	firemodes = list(
		FULL_AUTO_250,
		SEMI_AUTO_NODELAY)

/obj/item/weapon/gun/projectile/automatic/bulldog/update_icon()
	overlays.Cut()
	icon_state = "[initial(icon_state)]"
	if(ammo_magazine)
		overlays += "m12[ammo_magazine.ammo_color]"
	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide"

/obj/item/weapon/gun/projectile/automatic/bulldog/Initialize()
	. = ..()
	update_icon()
