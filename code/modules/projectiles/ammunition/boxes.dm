/*This code for boxes with ammo, you cant use them as magazines, but should be able to fill magazines with them.*/
/obj/item/ammo_magazine/ammobox	//Should not be used bu its own
	name = "ammunition box"
	desc = "Gun ammunition stored in a shiny new box. You can see caliber information on the label."
	mag_type = SPEEDLOADER	//To prevent load in magazine filled guns
	icon = 'icons/obj/ammo.dmi'
	multiple_sprites = 1
	reload_delay = 30
	ammo_mag = "box"

/obj/item/ammo_magazine/ammobox/resolve_attackby(atom/A, mob/user)
	if(isturf(A) && locate(/obj/item/ammo_casing) in A || istype(A, /obj/item/ammo_casing))
		if(!do_after(user, src.reload_delay, src))
			to_chat(user, SPAN_WARNING("You stoped scooping ammo into [src]."))
			return
		if(collectAmmo(get_turf(A), user))
			return TRUE
	..()

/obj/item/ammo_magazine/ammobox/proc/collectAmmo(var/turf/target, var/mob/user)
	ASSERT(istype(target))
	. = FALSE
	for(var/obj/item/ammo_casing/I in target)
		if(stored_ammo.len >= max_ammo)
			break
		if(I.caliber == src.caliber)
			for(var/j = 1 to I.amount)
				if(stored_ammo.len >= max_ammo)
					break
				. |= TRUE
				insertCasing(I)
	if(user)
		if(.)
			user.visible_message(SPAN_NOTICE("[user] scoopes some ammo in [src]."),SPAN_NOTICE("You scoop some ammo in [src]."),SPAN_NOTICE("You hear metal clanging."))
		else
			to_chat(user, SPAN_NOTICE("You fail to pick anything up with \the [src]."))
	update_icon()


/obj/item/ammo_magazine/ammobox/pistol
	name = "ammunition box (.35 Auto)"
	icon_state = "box9mm"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "pistol"
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/pistol/flash
	name = "ammunition box (.35 Auto flash)"
	icon_state = "box9mm-flash"
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/ammobox/pistol/practice
	name = "ammunition box (.35 Auto practice)"
	icon_state = "box9mm-practice"
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/ammobox/pistol/rubber
	name = "ammunition box (.35 Auto rubber)"
	icon_state = "box9mm-rubber"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/ammobox/srifle
	name = "ammunition box (.20 Rifle)"
	icon_state = "box556mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_BULKY
	caliber = "srifle"
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/srifle/practice
	name = "ammunition box (.20 Rifle practice)"
	icon_state = "box556mm-practice"
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/ammobox/clrifle
	name = "ammunition box (.25 Caseless Rifle)"
	icon_state = "box65mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_BULKY
	caliber = "clrifle"
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/clrifle/rubber
	name = "ammunition box (.25 Caseless Rifle rubber)"
	icon_state = "box65mm-rubber"
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

/obj/item/ammo_magazine/ammobox/lrifle
	name = "ammunition box (.30 Rifle)"
	icon_state = "box762mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_BULKY
	caliber = "lrifle"
	ammo_type = /obj/item/ammo_casing/lrifle
	mag_type = SPEEDLOADER | MAGAZINE
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/magnum
	name = "ammunition box (.40 Magnum)"
	icon_state = "box44"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "40m"
	ammo_type = /obj/item/ammo_casing/magnum
	max_ammo = 20

/obj/item/ammo_magazine/ammobox/magnum/rubber
	name = "ammunition box (.40 Magnum rubber)"
	icon_state = "box44-rubber"
	ammo_type = /obj/item/ammo_casing/magnum/rubber

/obj/item/ammo_magazine/ammobox/antim
	name = "ammunition box (.60 Anti Material)"
	icon_state = "box145mm"
	matter = list(MATERIAL_STEEL = 8)
	w_class = ITEM_SIZE_BULKY
	caliber = "antim"
	ammo_type = /obj/item/ammo_casing/antim
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/lrifle_small
	name = "FS .30 ammo pack"
	icon_state = "box_lrifle"
	caliber = "lrifle"
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 10