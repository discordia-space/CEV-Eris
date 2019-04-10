/obj/item/weapon/gun/projectile/clarissa
	name = "FS HG 9x19 \"Clarissa\""
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = ITEM_SIZE_SMALL
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1200
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = MAGAZINE
	silencer_type = /obj/item/weapon/silencer
	damage_multiplier = 0.8


/obj/item/weapon/gun/projectile/clarissa/update_icon()
	..()
	if(silenced)
		icon_state = "[initial(icon_state)]-silencer"
	else
		icon_state = initial(icon_state)


/obj/item/weapon/gun/projectile/clarissa/makarov
	name = "Excelsior 9x19 \"Makarov\""
	desc = "Old-designed pistol of space communists. Small and easily concealable. Uses 9mm rounds."
	icon_state = "makarov"


