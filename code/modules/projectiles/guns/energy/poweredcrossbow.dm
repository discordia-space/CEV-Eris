/obj/item/gun/energy/poweredcrossbow
	name = "powered crossbow"
	desc = "An handmade crossbow linked to an attached power cell, a weapon of desperation and ingenuity."
	icon = 'icons/obj/guns/energy/poweredcrossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	flags = CONDUCT
	slot_flags = SLOT_BACK
	wielded_item_state = "_doble"
	charge_cost = 100
	suitable_cell = /obj/item/cell/large
	cell_type = /obj/item/cell/large
	projectile_type = /obj/item/projectile/bullet/bolt
	fire_delay = 12 //Equivalent to a pump then fire time
	fire_sound = 'sound/weapons/tablehit1.ogg'
	init_firemodes = list(
		list(mode_name="Bolt", mode_desc="Fires a charged quarrel", projectile_type=/obj/item/projectile/bullet/bolt, charge_cost=100, icon="kill"),)
	price_tag = 200
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 5)
	twohanded = FALSE
	var/consume_cell = TRUE
	var/obj/item/ammo_casing/crossbow/bolt/bolt
	var/is_drawn
	init_recoil = RIFLE_RECOIL(1)
	safety = FALSE
	restrict_safety = TRUE

/obj/item/gun/energy/poweredcrossbow/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/ammo_casing/crossbow/bolt) && !bolt)
		bolt = TRUE
		qdel(I)
	else
		..()

/obj/item/gun/energy/poweredcrossbow/update_icon()
	if(bolt)
		icon_state = "crossbow_drawn"
	else
		icon_state = "crossbow"

/obj/item/gun/energy/poweredcrossbow/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/ammo_casing/crossbow/bolt) && !bolt)
		var/obj/item/ammo_casing/crossbow/bolt/B = I
		bolt = new B.type()
		bolt.amount = 1
		(B.amount > 1) ? B.amount-- : qdel(B)
	else if(!..())to_chat(user, SPAN_WARNING("The crossbow is already loaded."))
	else
		..()

/obj/item/gun/energy/poweredcrossbow/attack_hand(mob/living/user)
	if(bolt)
		user.put_in_active_hand(bolt)
		bolt = null
	else
		..()

/obj/item/gun/energy/poweredcrossbow/consume_next_projectile()
	if(bolt && cell.use(charge_cost))
		. = new bolt.projectile_type
		bolt = null
