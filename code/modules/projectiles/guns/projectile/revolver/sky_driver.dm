/obj/item/gun/projectile/revolver/sky_driver
	name = "S REV .35 Auto \"Sky Driver\""
	desc = "Old, Syndicate revolver made on lost tech before the Corporate war. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/sky_driver.dmi'
	icon_state = "sky_driver"
	item_state = "sky_driver"
	drawChargeMeter = FALSE
	origin_tech = list(TECH_COMBAT = 10, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/pistol
	magazine_type = /obj/item/ammo_magazine/slpistol
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	caliber = CAL_PISTOL
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/pistol
	price_tag = 20000
	damage_multiplier = 1.3
	penetration_multiplier = 9
	pierce_multiplier = 10
	init_recoil = HANDGUN_RECOIL(1.6)
	spawn_frequency = 0
	spawn_blacklisted = TRUE
	noricochet = TRUE
	gun_parts = list(/obj/item/part/gun/frame/sky_driver = 1, /obj/item/part/gun/grip/black = 1, /obj/item/part/gun/mechanism/revolver = 1, /obj/item/part/gun/barrel/pistol = 1)
	serial_type = "S"

/obj/item/gun/projectile/revolver/sky_driver/New()
	..()
	GLOB.all_faction_items[src] = GLOB.department_security

/obj/item/gun/projectile/revolver/sky_driver/Destroy()
	for(var/mob/living/carbon/human/H in viewers(get_turf(src)))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	GLOB.ironhammer_faction_item_loss++
	..()

/obj/item/gun/projectile/revolver/sky_driver/attackby(obj/item/I, mob/user, params)
	if(nt_sword_attack(I, user))
		return FALSE
	..()

/obj/item/part/gun/frame/sky_driver
	name = "Sky Driver frame"
	desc = "A Sky Driver revolver frame. A device that can put holes in ships, let alone a person."
	icon_state = "frame_skydriver"
	result = /obj/item/gun/projectile/revolver/sky_driver
	grip = /obj/item/part/gun/grip/black
	mechanism = /obj/item/part/gun/mechanism/revolver
	barrel = /obj/item/part/gun/barrel/pistol
	spawn_blacklisted = TRUE
