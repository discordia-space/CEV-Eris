/obj/item/weapon/gun/projectile/automatic/lmg/l6_saw
	name = "L6 SAW"
	desc = "A rather traditionally made L6 SAW with a pleasantly lacquered wooden pistol grip. This one is unmarked."
	icon_base = "l6"
	icon_state = "l6closed-empty"
	item_state = "l6closedmag"


/obj/item/weapon/gun/projectile/automatic/lmg/pk
	name = "Pulemyot Kalashnikova"
	desc = "\"Kalashnikov's Machinegun\", a well preserved and maintained antique weapon of war."
	icon_base = "pk"
	icon_state = "pkclosed-empty"
	item_state = "pkclosedmag"

/obj/item/weapon/gun/projectile/automatic/lmg
	w_class = ITEM_SIZE_HUGE
	icon = 'icons/obj/weapons/lmg.dmi'
	force = 10
	slot_flags = 0
	max_shells = 50
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = "/obj/item/ammo_casing/a762"
	ammo_mag = "box"
	load_method = MAGAZINE
	magazine_type = null //Magazine type is for preloaded spawning. This spawns empty
	matter = list(MATERIAL_PLASTEEL = 40, MATERIAL_PLASTIC = 15, MATERIAL_WOOD = 5)
	price_tag = 5000
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'
	var/icon_base
	firemodes = list(
		FULL_AUTO_600,
		list(mode_name="short bursts",	burst=5, move_delay=6, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2), icon="burst"),
		list(mode_name="long bursts",	burst=8, move_delay=8, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2), icon="burst"),
		)

	var/cover_open = 0

/obj/item/weapon/gun/projectile/automatic/lmg/special_check(mob/user)
	if(cover_open)
		user << SPAN_WARNING("[src]'s cover is open! Close it before firing!")
		return 0
	return ..()

/obj/item/weapon/gun/projectile/automatic/lmg/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/lmg/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/lmg/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/lmg/equipped(var/mob/user, var/slot)
	.=..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/lmg/update_icon()
	icon_state = "[icon_base][cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"
	item_state = "[icon_base][ammo_magazine ?"mag":"nomag"]"
	update_wear_icon()

/obj/item/weapon/gun/projectile/automatic/lmg/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		user << SPAN_WARNING("You need to open the cover to load [src].")
		return
	..()

/obj/item/weapon/gun/projectile/automatic/lmg/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		user << SPAN_WARNING("You need to open the cover to unload [src].")
		return
	..()
