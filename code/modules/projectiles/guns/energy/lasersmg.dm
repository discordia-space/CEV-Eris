/obj/item/gun/energy/lasersmg
	name = "HM Disco Vazer \"Lasblender\""
	desc = "This conversion of the \"Atreides\" enables it to shoot lasers. Unlike in other laser weapons, the process of creating a laser is based on a chain reaction of localized micro-explosions.\
			While this method is charge-effective, the chain-reaction makes the gun always fire in bursts. \
			Sometimes jokingly called the \"Disco Vazer\"."
	icon = 'icons/obj/guns/energy/lasersmg.dmi'
	icon_state = "lasersmg"
	item_state = "lasersmg"
	volumeClass = ITEM_SIZE_NORMAL
	fire_sound = 'sound/weapons/Laser.ogg'
	suitable_cell = /obj/item/cell/medium
	can_dual = TRUE
	projectile_type = /obj/item/projectile/beam
	charge_meter = FALSE //TODO: Rework overlays, check assets storage for charge states.
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_PLASTEEL = 11, MATERIAL_STEEL = 13, MATERIAL_PLASTIC = 2, MATERIAL_SILVER = 1, MATERIAL_GLASS = 2)
	price_tag = 1000
	damage_multiplier = 0.6 //makeshift laser
	projectile_type = /obj/item/projectile/beam
	init_offset = 0
	suitable_cell = /obj/item/cell/medium
	charge_cost = 25 // 4 bursts with a 800m cell

	init_firemodes = list(
		BURST_8_ROUND,
		FULL_AUTO_300
		)

	wield_delay = 1 SECOND
	wield_delay_factor = 0.1 // 10 vig
	init_recoil = SMG_RECOIL(1)


/obj/item/gun/energy/lasersmg/process_projectile(var/obj/item/projectile/P, mob/living/user, atom/target, var/target_zone, var/params)
	projectile_color = pick(list("#FF0000", "#0000FF", "#00FF00", "#FFFF00", "#FF00FF", "#00FFFF", "#FFFFFF", "#000000"))
	..()
	return ..()

/obj/item/gun/energy/lasersmg/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (cell)
		iconstring += "_mag"
		itemstring += "_mag"
		wielded_item_state = "_doble_mag"
	else
		wielded_item_state = "_doble"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/energy/lasersmg/update_icon()//TODO: Rework overlays, check assets storage for charge states.
	cut_overlays()
	..()

	if(istype(cell, /obj/item/cell/medium/moebius/nuclear))
		overlays += image(icon, "nuke_cell")

	else if(istype(cell, /obj/item/cell/medium/moebius))
		overlays += image(icon, "moeb_cell")

	else if(istype(cell, /obj/item/cell/medium/excelsior))
		overlays += image(icon, "excel_cell")

	else if(istype(cell, /obj/item/cell/medium))
		overlays += image(icon, "guild_cell")
