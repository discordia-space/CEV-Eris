/obj/item/weapon/gun/projectile/olivaw
	name = "FS HG .32 \"Olivaw\""
	desc = "That's the 'Frozen Star' popular traumatic pistol. This one seems to have a two-round burst-fire mode. Uses .32 rounds."
	icon_state = "olivawcivil"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	caliber = ".32"
	ammo_mag = "mag_cl32"
	fire_delay = 1.2
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	load_method = MAGAZINE
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=1.2, move_delay=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=0.2, move_delay=4,    dispersion=list(1.2, 1.8)),
		)

/obj/item/weapon/gun/projectile/olivaw/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"
