/obj/item/weapon/gun/projectile/heavysniper
	name = "NT AMR \"Penetrator\""
	desc = "A portable anti-armour rifle, fitted with a scope, it was originally designed for use against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. Alt click it to access the chamber."
	icon = 'icons/obj/guns/projectile/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	caliber = "14.5mm"
	recoil = 0.2 //due to new dynamic crosshair recoil system, in order to hit something we need to have low recoil on it, but 0.2 will allow random misses as well
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_PLASTEEL = 40, MATERIAL_PLASTIC = 20)
	price_tag = 5000
	var/bolt_open = 0
	zoom_factor = 2.0

/obj/item/weapon/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"

/obj/item/weapon/gun/projectile/heavysniper/attack_self(mob/user) //Someone overrode attackself for this class, soooo.
	if(zoom)
		toggle_scope(user)
		return
	bolt_act(user)

/obj/item/weapon/gun/projectile/heavysniper/proc/bolt_act(mob/living/user)
	playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [chambered]!"))
			chambered.loc = get_turf(src)
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

/obj/item/weapon/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/weapon/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/weaponparts
	name = "weaponpart"
	desc = "how did you get it?"
	icon = 'icons/obj/buildingobject.dmi'

/obj/item/weapon/weaponparts/heavysniper/disassembled
	name = "disassembled sniper rifle"
	desc = "This is a disassembled sniper rifle. You need to attach the stock."
	icon_state = "sniperd"

/obj/item/weapon/weaponparts/heavysniper/stocked
	name = "disassembled sniper rifle with stock"
	desc = "This is a disassembled sniper rifle with stock. Now attach the barrel."
	icon_state = "snipersd"

/obj/item/weapon/weaponparts/heavysniper/stock
	name = "sniper rifle stock"
	desc = "This is a stock from a sniper rifle."
	icon_state = "sniperstock"

/obj/item/weapon/weaponparts/heavysniper/barrel
	name = "sniper rifle barrel"
	desc = "This is a barrel from a sniper rifle."
	icon_state = "sniperbarrel"

/obj/item/weapon/weaponparts/heavysniper/disassembled/attackby(obj/item/W, mob/user)
    if(istype(W,/obj/item/weapon/weaponparts/heavysniper/stock))
        to_chat(user, "You attach the barrel to the sniper")
        var/obj/item/weapon/weaponparts/heavysniper/stocked/HS = new (get_turf(src))
        if(loc == user)
            equip_slot = user.get_inventory_slot(src)
            if(equip_slot in list(slot_r_hand, slot_l_hand))
                user.drop_from_inventory(src)
                user.equip_to_slot_if_possible(HS, equip_slot)
            qdel(W)
            qdel(src)


/obj/item/weapon/weaponparts/heavysniper/stocked/attackby(obj/item/W, mob/user)
    if(istype(W,/obj/item/weapon/weaponparts/heavysniper/barrel))
        to_chat(user, "You attach the barrel to the sniper")
        var/obj/item/weapon/gun/projectile/heavysniper/HS = new (get_turf(src))
        if(loc == user)
            equip_slot = user.get_inventory_slot(src)
            if(equip_slot in list(slot_r_hand, slot_l_hand))
                user.drop_from_inventory(src)
                user.equip_to_slot_if_possible(HS, equip_slot)
            qdel(W)
            qdel(src)
