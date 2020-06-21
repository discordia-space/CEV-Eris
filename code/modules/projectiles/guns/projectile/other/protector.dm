/obj/item/weapon/gun/projectile/grenade
	name = "NT GL \"Protector\""
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenade shells in a revolving magazine."
	icon = 'icons/obj/guns/launcher/riotgun.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_WOOD = 10)
	caliber = CAL_GRENADE
	load_method = SINGLE_CASING
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2)
	handle_casings = EJECT_CASINGS
	price_tag = 5500
	fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'   //Placeholder, could use a new sound
	fire_sound_text = "a metallic thunk"
	recoil_buildup = 20
	max_shells = 6
	zoom_factor = 2.0
	var/throw_distance = 7
	var/release_force = 5
	twohanded = TRUE

/obj/item/weapon/gun/projectile/grenade/proc/load_grenade(obj/item/weapon/grenade/A, mob/user)  //For loading hand grenades, not ammo
	if(!A.loadable)
		to_chat(user, SPAN_WARNING("\The [A] doesn't seem to fit in \the [src]!"))
		return
	if(loaded.len >= max_shells)
		to_chat(user, SPAN_WARNING("\The [src] is full."))
		return
	user.remove_from_mob(A)
	A.forceMove(src)
	loaded.Insert(1, A) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("\The [user] inserts \a [A] into \the [src].", SPAN_NOTICE("You insert \a [A] into \the [src]."))
	pump(user)
	update_icon()

/obj/item/weapon/gun/projectile/grenade/load_ammo(var/obj/item/A, mob/user)  //Allows us to load both hand grenades and grenade shells
	if(istype(A, /obj/item/weapon/grenade))
		load_grenade(A, user)
	else
		..()


//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/weapon/gun/projectile/grenade/proc/pump(mob/user as mob)
	playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)

	var/obj/item/ammo_casing/next
	if(loaded.len)
		next = loaded[1]
	if(next)
		loaded -= next
		loaded += next  //Moves the first loaded grenade to the end of the loaded list
		next = loaded[1]
		to_chat(user, SPAN_WARNING("Mechanism pumps [src], loading \a [next] into the chamber."))
	else
		to_chat(user, SPAN_WARNING("Mechanism pumps [src], but the magazine is empty."))
	update_icon()

/obj/item/weapon/gun/projectile/grenade/examine(mob/user)
	if(..(user, 2))
		var/grenade_count = loaded.len + (chambered? 1 : 0)
		to_chat(user, "Has [grenade_count] grenade\s remaining.")
		if(chambered)
			to_chat(user, "\A [chambered] is chambered.")

/obj/item/weapon/gun/projectile/grenade/attack_self(mob/user)
	pump(user)

