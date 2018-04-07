/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"
	w_class = ITEM_SIZE_NORMAL
	load_method = SPEEDLOADER //yup. until someone sprites a magazine for it.
	max_shells = 22
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c9mm
	multi_aim = 1
	burst_delay = 2
	fire_sound = 'sound/weapons/guns/fire/smg_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/smg_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/smg_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/smg_cock.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)
