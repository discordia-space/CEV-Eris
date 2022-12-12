/obj/item/gun/energy/poweredcrossbow
	name = "powered crossbow"
	desc = "An handmade crossbow linked to an attached power cell, a weapon of desperation and ingenuity. There is a rudimentary scope built into the design."
	icon = 'icons/obj/guns/energy/poweredcrossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	wielded_item_state = "_doble"
	fire_delay = 6 //Lowered to match plasma weapons
	fire_sound = 'sound/weapons/tablehit1.ogg'
	init_firemodes = list(
		list(mode_name = "Bolt", mode_desc = "Fires a charged quarrel", projectile_type = /obj/item/projectile/bullet/bolt, charge_cost = 50, icon = "kill"))
	price_tag = 200
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 5)
	zoom_factors = list(0.5)
	var/obj/item/ammo_casing/crossbow/bolt/bolt
	var/is_drawn
	init_recoil = RIFLE_RECOIL(1)
	damage_multiplier = 1
	penetration_multiplier = 0
	safety = FALSE
	restrict_safety = TRUE

/obj/item/gun/energy/poweredcrossbow/update_icon()
	icon_state = bolt ? "crossbow_drawn" : "crossbow"

/obj/item/gun/energy/poweredcrossbow/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/ammo_casing/crossbow/bolt) && !bolt)
		var/obj/item/ammo_casing/crossbow/bolt/B = I
		bolt = new B.type()
		bolt.amount = 1
		if(B.amount > 1)
			B.amount--
			B.update_icon()
		else
			qdel(B)
		to_chat(user, SPAN_NOTICE("You load a bolt into the powered crossbow!"))
	else
		..()

/obj/item/gun/energy/poweredcrossbow/attack_hand(mob/living/user)
	if(bolt && is_held())
		user.put_in_active_hand(bolt)
		bolt = null
		to_chat(user, SPAN_NOTICE("You unload a bolt from the powered crossbow!"))
	else
		..()

/obj/item/gun/energy/poweredcrossbow/consume_next_projectile()
	if(bolt && cell.use(charge_cost))
		. = new bolt.projectile_type
		bolt = null

/obj/item/gun/energy/poweredcrossbow/generate_guntags()
	gun_tags = list(SLOT_BAYONET)
