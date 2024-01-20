/obj/item/gun/projectile/boltgun
	name = "Excelsior BR .30 \"Kardashev-Mosin\""
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything."
	icon = 'icons/obj/guns/projectile/boltgun.dmi'
	icon_state = "boltgun"
	item_state = "boltgun"
	volumeClass = ITEM_SIZE_HUGE
	melleDamages = list(ARMOR_POINTY = list(DELEM(BRUTE, 25)))
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CAL_LRIFLE
	fire_delay = 8
	damage_multiplier = 1.4
	init_recoil = RIFLE_RECOIL(1.5)
	init_offset = 4 //bayonet's effect on aim, reduced from 4
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	magazine_type = /obj/item/ammo_magazine/lrifle
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 8, MATERIAL_PLASTIC = 10)
	price_tag = 900
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut") // Considering attached bayonet
	sharp = TRUE
	spawn_blacklisted = TRUE
	gun_parts = list(/obj/item/stack/material/steel = 16)
	saw_off = TRUE
	sawn = /obj/item/gun/projectile/boltgun/obrez
	var/bolt_open = 0
	var/item_suffix = ""
	var/message = "bolt"        // what message appears when cocking, eg "You work the [bolt] open, ejecting a casing!"
	gun_parts = list(/obj/item/part/gun/frame/boltgun = 1, /obj/item/part/gun/modular/grip/excel = 1, /obj/item/part/gun/modular/mechanism/boltgun = 1, /obj/item/part/gun/modular/barrel/lrifle/steel = 1)

/obj/item/part/gun/frame/boltgun
	name = "bolt-action rifle frame"
	desc = "A bolt-action rifle frame. For hunting or endless trench warfare."
	icon_state = "frame_serbrifle"
	result = /obj/item/gun/projectile/boltgun
	gripvars = list(/obj/item/part/gun/modular/grip/excel, /obj/item/part/gun/modular/grip/wood)
	resultvars = list(/obj/item/gun/projectile/boltgun, /obj/item/gun/projectile/boltgun/serbian)
	mechanismvar = /obj/item/part/gun/modular/mechanism/boltgun
	barrelvars = list(/obj/item/part/gun/modular/barrel/lrifle/steel)

/obj/item/gun/projectile/boltgun/update_icon()
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

/obj/item/gun/projectile/boltgun/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/boltgun/attack_self(mob/user) //Someone overrode attackself for this class, soooo.
	bolt_act(user)

/obj/item/gun/projectile/boltgun/proc/bolt_act(mob/living/user)

    playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
    bolt_open = !bolt_open
    if(bolt_open)
        if(contents.len)
            if(chambered)
                to_chat(user, SPAN_NOTICE("You work the [message] open, ejecting [chambered]!"))
                chambered.forceMove(get_turf(src))
                loaded -= chambered
                chambered = null
            else
                var/obj/item/ammo_casing/B = loaded[loaded.len]
                if(!B.is_caseless)
                    to_chat(user, SPAN_NOTICE("You work the [message] open, ejecting [B]!"))
                    B.forceMove(get_turf(src))
                    loaded -= B
                else
                    to_chat(user, SPAN_NOTICE("You work the [message] open."))
                    B = loaded[1]
                    loaded -= B
                    qdel(B)
        else
            to_chat(user, SPAN_NOTICE("You work the [message] open."))
    else
        to_chat(user, SPAN_NOTICE("You work the [message] closed."))
        playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltforward.ogg', 75, 1)
        bolt_open = 0
    add_fingerprint(user)
    update_icon()

/obj/item/gun/projectile/boltgun/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the [message] is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/boltgun/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/boltgun/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/boltgun/serbian
	name = "SA BR .30 \"Novakovic\""
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything. \
			This copy, in fact, is a reverse-engineered poor-quality copy of a more perfect copy of an ancient rifle"
	icon = 'icons/obj/guns/projectile/novakovic.dmi'
	icon_state = "boltgun_wood"
	item_suffix  = "_wood"
	init_recoil = RIFLE_RECOIL(1.7)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	wielded_item_state = "_doble_wood"
	spawn_blacklisted = FALSE
	gun_parts = list(/obj/item/stack/material/steel = 16)
	sawn = /obj/item/gun/projectile/boltgun/obrez/serbian
	gun_parts = list(/obj/item/part/gun/frame/boltgun = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/boltgun = 1, /obj/item/part/gun/modular/barrel/lrifle/steel = 1)
	atomFlags = AF_ICONGRABNEEDSINSTANTATION

/obj/item/gun/projectile/boltgun/fs
	name = "FS BR .20 \"Kadmin\""
	desc = "Weapon for hunting, or endless coastal warfare. \
			A replica of an ancient bolt action known for its easy maintenance and low price. \
			This is mounted with a scope, for ranges longer than a maintenance tunnel."
	icon = 'icons/obj/guns/projectile/arisaka.dmi'
	icon_state = "arisaka_ih_scope"
	item_suffix  = "_ih_scope"
	caliber = CAL_SRIFLE
	damage_multiplier = 1.6
	init_recoil = RIFLE_RECOIL(1.8)
	init_offset = 0 //no bayonet
	max_shells = 6
	zoom_factors = list(0.8) //vintorez level
	proj_step_multiplier = 0.8 //high pressure and long barrel
	magazine_type = /obj/item/ammo_magazine/srifle
	matter = list(MATERIAL_STEEL = 25, MATERIAL_PLASTIC = 15)
	wielded_item_state = "_doble_ih_scope"
	sharp = FALSE
	spawn_blacklisted = TRUE
	saw_off = FALSE
	gun_parts = list(/obj/item/part/gun/frame/kadmin = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/boltgun = 1, /obj/item/part/gun/modular/barrel/srifle/steel = 1)
	price_tag = 1200
	serial_type = "FS"


/obj/item/gun/projectile/boltgun/fs/civilian
	name = "FS BR .20 \"Arasaka\""
	desc = "Weapon for hunting, or endless coastal warfare. \
			A replica of a replica, this simple, low-cost bolt-action rifle offers superb armor-piercing short of anti-materiel rounds. \
			This is mounted with a short scope, for ranges mildly longer than a maintenance tunnel."
	icon = 'icons/obj/guns/projectile/arisaka_civ.dmi'
	icon_state = "arisaka_civilian"
	item_suffix  = "_civilian"
	atomFlags = AF_ICONGRABNEEDSINSTANTATION
	init_recoil = RIFLE_RECOIL(2)
	zoom_factors = list(0.5) //like the xbow
	wielded_item_state = "_doble_arisaka"
	spawn_blacklisted = FALSE
	gun_parts = list(/obj/item/part/gun/frame/kadmin = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/boltgun = 1, /obj/item/part/gun/modular/barrel/srifle/steel = 1)
	price_tag = 1000

/obj/item/part/gun/frame/kadmin
	name = "Kadmin frame"
	desc = "A Kadmin bolt-action rifle frame. For hunting or endless coastal warfare."
	icon_state = "frame_weebrifle"
	result = /obj/item/gun/projectile/boltgun/fs
	resultvars = list(/obj/item/gun/projectile/boltgun/fs, /obj/item/gun/projectile/boltgun/fs/civilian)
	gripvars = list(/obj/item/part/gun/modular/grip/rubber, /obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/boltgun
	barrelvars = list(/obj/item/part/gun/modular/barrel/srifle/steel)

/obj/item/gun/projectile/boltgun/handmade
	name = "HM BR \"Riose\""
	desc = "A handmade bolt action rifle, made from junk and some spare parts."
	icon = 'icons/obj/guns/projectile/riose.dmi'
	icon_state = "boltgun_hand"
	item_suffix = "_hand"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 5)
	wielded_item_state = "_doble_hand"
	volumeClass = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	damage_multiplier = 1.5
	init_recoil = RIFLE_RECOIL(2)
	max_shells = 5
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	price_tag = 800
	sharp = TRUE //no bayonet here
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	saw_off = TRUE // yeah, we are getting the ghetto sawn off too
	sawn = /obj/item/gun/projectile/boltgun/obrez/handmade
	gun_parts = list(/obj/item/part/gun/frame/riose = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/boltgun = 1, /obj/item/part/gun/modular/barrel/lrifle/steel = 1)

/obj/item/part/gun/frame/riose
	name = "Riose frame"
	desc = "A Riose bolt-action rifle frame. For hunting or endless maintenance warfare."
	icon_state = "frame_riose"
	matter = list(MATERIAL_STEEL = 5)
	resultvars = list(/obj/item/gun/projectile/boltgun/handmade)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/boltgun
	barrelvars = list(/obj/item/part/gun/modular/barrel/lrifle/steel, /obj/item/part/gun/modular/barrel/srifle/steel, /obj/item/part/gun/modular/barrel/clrifle/steel)

//// OBREZ ////

/obj/item/gun/projectile/boltgun/obrez
	name = "sawn-off Excelsior BR .30 \"Kardashev-Mosin\""
	desc = "Weapon for hunting, or endless trench warfare. \
	     This one has been sawed down into an \"Obrez\" style."
	icon = 'icons/obj/guns/projectile/obrez_bolt.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	volumeClass = ITEM_SIZE_NORMAL
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE, 10)))
	armor_divisor = 1
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	proj_step_multiplier = 1.2
	init_recoil = CARBINE_RECOIL(3)
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5)
	price_tag = 600
	attack_verb = list("struck","hit","bashed")
	can_dual = TRUE
	sharp = FALSE
	spawn_blacklisted = TRUE
	saw_off = FALSE

/obj/item/gun/projectile/boltgun/obrez/serbian
	name = "sawn-off SA BR .30 \"Novakovic\""
	icon = 'icons/obj/guns/projectile/obrez_bolt.dmi'
	icon_state = "obrez_wood"
	item_suffix  = "_wood"
	init_recoil = CARBINE_RECOIL(3.3)
	wielded_item_state = "_doble_wood"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 5)

/obj/item/gun/projectile/boltgun/obrez/handmade
	name = "sawn-off HM BR \"Riose\""
	icon = 'icons/obj/guns/projectile/obrez_bolt.dmi'
	icon_state = "obrez_hand"
	item_suffix  = "_hand"
	init_recoil = CARBINE_RECOIL(4.5)
	wielded_item_state = "_doble_hand"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 5)
