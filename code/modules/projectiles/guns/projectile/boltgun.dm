/obj/item/weapon/gun/projectile/boltgun
	name = "Excelsior BR .30 \"Kardashev-Mosin\""
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything."
	icon = 'icons/obj/guns/projectile/boltgun.dmi'
	icon_state = "boltgun"
	item_state = "boltgun"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_ROBUST
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CAL_LRIFLE
	fire_delay = 12 // double the standart
	damage_multiplier = 2.4
	penetration_multiplier  = 1.5
	recoil_buildup = 40 //same as AMR
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	ammo_type = /obj/item/ammo_magazine/lrifle
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 1600
	one_hand_penalty = 20 //full sized rifle with bayonet is hard to keep on target
	var/bolt_open = 0
	var/item_suffix = ""
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut") // Considering attached bayonet
	sharp = TRUE

/obj/item/weapon/gun/projectile/boltgun/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (item_suffix)
		itemstring += "[item_suffix]"

	if (bolt_open)
		iconstring += "_open"
	else
		iconstring += "_closed"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/weapon/gun/projectile/boltgun/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/boltgun/attack_self(mob/user) //Someone overrode attackself for this class, soooo.
	if(zoom)
		toggle_scope(user)
		return
	bolt_act(user)

/obj/item/weapon/gun/projectile/boltgun/proc/bolt_act(mob/living/user)
	playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [chambered]!"))
			chambered.forceMove(get_turf(src))
			loaded -= chambered
			chambered = null
		else
			to_chat(user, SPAN_NOTICE("You work the bolt open."))
	else
		to_chat(user, SPAN_NOTICE("You work the bolt closed."))
		playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltforward.ogg', 75, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/boltgun/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/weapon/gun/projectile/boltgun/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/boltgun/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/boltgun/serbian
	name = "SA BR .30 \"Novakovic\""
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything. \
			This copy, in fact, is a reverse-engineered poor-quality copy of a more perfect copy of an ancient rifle"
	icon_state = "boltgun_wood"
	item_suffix  = "_wood"
	recoil_buildup = 0.4 // Double the excel variant
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	wielded_item_state = "_doble_wood"
	rarity_value = 48
