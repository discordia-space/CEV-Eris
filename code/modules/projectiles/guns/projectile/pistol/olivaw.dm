/obj/item/weapon/gun/projectile/olivaw
	name = "FS HG .32 \"Olivaw\""
	desc = "That's a \"Frozen Star\" popular non-lethal pistol. This one seems to have a two-round burst-fire mode. Uses .32 rounds."
	icon_state = "olivawcivil"
	item_state = "pistol"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	caliber = ".32"
	ammo_mag = "mag_cl32"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 800
	damage_multiplier = 1.2
	recoil = 0.4 //low-caliber peashooter, but more complicated and robust than giskard so less than normal recoil

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=1.2, move_delay=null, 				icon="semi"),
		list(mode_name="2-round bursts", burst=2, fire_delay=0.2, move_delay=4,    	icon="burst"),
		)

/obj/item/weapon/gun/projectile/olivaw/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"
