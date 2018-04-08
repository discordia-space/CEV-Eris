/obj/item/weapon/gun/projectile/clarissa
	name = "FS HG 9x19 \"Clarissa\""
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = ITEM_SIZE_SMALL
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/clarissa/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << SPAN_NOTICE("You unscrew [silenced] from [src].")
			user.put_in_hands(silenced)
			silenced = 0
			w_class = ITEM_SIZE_SMALL
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/clarissa/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << SPAN_NOTICE("You'll need [src] in your hands to do that.")
			return
		user.drop_item()
		user << SPAN_NOTICE("You screw [I] onto [src].")
		silenced = I	//dodgy?
		w_class = ITEM_SIZE_NORMAL
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/clarissa/update_icon()
	..()
	if(silenced)
		icon_state = "[initial(icon_state)]-silencer"
	else
		icon_state = initial(icon_state)


/obj/item/weapon/gun/projectile/clarissa/makarov
	name = "Excelsior 9x19 \"Makarov\""
	desc = "Old designed pistol of space communists. Small and easily concealable. Uses 9mm rounds."
	icon_state = "makarov"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 1)
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL
