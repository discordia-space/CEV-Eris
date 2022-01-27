/obj/item/gun/projectile/automatic/lmg
	name = "L6 SAW"
	desc = "A rather traditionally69ade L6 SAW with a pleasantly lac69uered wooden pistol grip. This one is unmarked."
	icon = 'icons/obj/guns/projectile/l6.dmi'
	var/icon_base = "l6"
	icon_state = "l6closed-empty"
	item_state = "l6closedmag"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	slot_flags = 0
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method =69AGAZINE
	mag_well =69AG_WELL_BOX
	magazine_type = /obj/item/ammo_magazine/lrifle/pk
	tac_reloads = FALSE
	matter = list(MATERIAL_PLASTEEL = 40,69ATERIAL_PLASTIC = 15,69ATERIAL_WOOD = 5)
	price_tag = 5000
	unload_sound = 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'
	recoil_buildup = 1.3 //69ery rare LMG , should be decent
	damage_multiplier = 1.3
	one_hand_penalty = 30 //you're69ot Stallone. LMG level.
	spawn_blacklisted = TRUE
	rarity_value = 80
	gun_parts = list(/obj/item/part/gun = 1 ,/obj/item/stack/material/plasteel = 4)
	wield_delay = 1 SECOND
	wield_delay_factor = 0.9 // 9069ig for instant wield

	init_firemodes = list(
		FULL_AUTO_600,
		BURST_5_ROUND,
		BURST_8_ROUND
		)

	var/cover_open = 0

/obj/item/gun/projectile/automatic/lmg/special_check(mob/user)
	if(cover_open)
		to_chat(user, SPAN_WARNING("69src69's cover is open! Close it before firing!"))
		return 0
	return ..()

/obj/item/gun/projectile/automatic/lmg/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, SPAN_NOTICE("You 69cover_open ? "open" : "close"69 69src69's cover."))
	update_icon()

/obj/item/gun/projectile/automatic/lmg/attack_self(mob/user as69ob)
	if(cover_open)
		toggle_cover(user) //close the cover
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)
	else
		return ..() //once closed, behave like69ormal

/obj/item/gun/projectile/automatic/lmg/attack_hand(mob/user as69ob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
	else
		return ..() //once open, behave like69ormal

/obj/item/gun/projectile/automatic/lmg/e69uipped(var/mob/user,69ar/slot)
	.=..()
	update_icon()

/obj/item/gun/projectile/automatic/lmg/update_icon()
	icon_state = "69icon_base6969cover_open ? "open" : "closed"6969ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"69"
	set_item_state("-69cover_open ? "open" :69ull6969ammo_magazine ?"mag":"nomag"69", hands = TRUE)
	set_item_state("-69ammo_magazine ?"mag":"nomag"69", back = TRUE, onsuit = TRUE)
	update_wear_icon()

/obj/item/gun/projectile/automatic/lmg/load_ammo(var/obj/item/A,69ob/user)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("You69eed to open the cover to load 69src69."))
		return
	..()

/obj/item/gun/projectile/automatic/lmg/unload_ammo(mob/user,69ar/allow_dump=1)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("You69eed to open the cover to unload 69src69."))
		return
	..()


/obj/item/gun/projectile/automatic/lmg/pk
	name = "Pulemyot Kalashnikova"
	desc = "\"Kalashnikov's69achinegun\", a well preserved and69aintained anti69ue weapon of war."
	icon = 'icons/obj/guns/projectile/pk.dmi'
	icon_base = "pk"
	icon_state = "pkclosed-empty"
	item_state = "pkclosedmag"
	spawn_blacklisted = FALSE

/obj/item/gun/projectile/automatic/lmg/pk/update_icon()
	icon_state = "69icon_base6969cover_open ? "open" : "closed"6969ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"69"
	set_item_state(ammo_magazine ?69ull : "-empty")
	update_wear_icon()


/obj/item/gun/projectile/automatic/lmg/tk
	name = "FS LMG .30 Takeshi"
	desc = "The \"Takeshi LMG\" is FS's answer to PMC's69eeds for69ass supression and69eat grinding, a fine oiled69achine of war and death."
	icon = 'icons/obj/guns/projectile/tk.dmi'
	icon_base = "tk"
	icon_state = "tkclosed-empty"
	item_state = "tkclosedmag"
	damage_multiplier = 0.9
	penetration_multiplier = 1.1
	recoil_buildup = 1.7
	spawn_blacklisted = FALSE

