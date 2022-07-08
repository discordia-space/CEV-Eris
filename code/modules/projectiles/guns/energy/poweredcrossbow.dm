/obj/item/gun/energy/poweredcrossbow
	name = "Powered Crossbow"
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

/obj/item/gun/energy/poweredcrossbow/consume_next_projectile()
	if(!cell) return null
	if(!ispath(projectile_type)) return null
	if(consume_cell && !cell.checked_use(charge_cost))
		visible_message(SPAN_WARNING("\The [cell] of \the [src] burns out!"))
		qdel(cell)
		cell = null
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		return new projectile_type(src)
	else if(!consume_cell && !cell.checked_use(charge_cost))
		return null
	else
		return new projectile_type(src)

/obj/item/gun/energy/poweredcrossbow/attackby(obj/item/I, mob/user)
	..()
	if(I.has_quality(QUALITY_BOLT_TURNING))
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
			if(consume_cell)
				consume_cell = FALSE
				to_chat(user, SPAN_NOTICE("You secure the safety bolts, preventing the weapon from destroying empty cells for use as ammuniton."))
			else
				consume_cell = TRUE
				to_chat(user, SPAN_NOTICE("You loosen the safety bolts, allowing the weapon to destroy empty cells for use as ammunition."))

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
