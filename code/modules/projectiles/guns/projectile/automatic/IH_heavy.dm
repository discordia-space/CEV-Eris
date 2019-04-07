//The heavy rifle is ironhammer's go-to weapon for dealing with serious threats. It weighs a ton and hits hard
/obj/item/weapon/gun/projectile/automatic/IH_heavyrifle
	name = "FS BR \"Wintermute\""
	desc = "A high end military grade automatic battle rifle, designed for use against armoured infantry. Has a slightly slower firing rate than its contemporaries, but hits like a truck. Uses 7.62mm rounds."
	icon_state = "IH_heavyrifle"
	item_state = "IH_heavyrifle"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFULL
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/ak47
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 4000
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1.3 //Significant power increase, but fires at a fairly slow rate
	firemodes = list(
		FULL_AUTO_250,
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    dispersion=list(0.0, 0.6, 0.6), icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/IH_heavyrifle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		item_state = "[initial(item_state)]-full"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	return