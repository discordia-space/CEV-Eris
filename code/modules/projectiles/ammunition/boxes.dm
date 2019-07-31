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

/obj/item/ammo_magazine/ammobox/a10mm
	name = "ammunition box (10mm)"
	icon_state = "box10mm"
	matter = list(MATERIAL_STEEL = 6)
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 32

/obj/item/ammo_magazine/ammobox/a10mm/rubber
	name = "ammunition box (10mm rubber)"
	icon_state = "box10mm-rubber"
	ammo_type = /obj/item/ammo_casing/a10mm/rubber

//obj/item/ammo_magazine/ammobox/a10mm/hv
	//name = "ammunition box (10mm high velocity)"
	//icon_state = "box10mm-hv"
	//ammo_type = /obj/item/ammo_casing/a10mm/hv

/obj/item/ammo_magazine/ammobox/c9mm
	name = "ammunition box (9mm)"
	icon_state = "box9mm"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c9mm/flash
	name = "ammunition box (9mm flash)"
	icon_state = "box9mm-flash"
	ammo_type = /obj/item/ammo_casing/c9mm/flash

/obj/item/ammo_magazine/ammobox/c9mm/practice
	name = "ammunition box (9mm practice)"
	icon_state = "box9mm-practice"
	ammo_type = /obj/item/ammo_casing/c9mm/practice

/obj/item/ammo_magazine/ammobox/c9mm/rubber
	name = "ammunition box (9mm rubber)"
	icon_state = "box9mm-rubber"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_magazine/ammobox/cl32
	name = "ammunition box (.32)"
	icon_state = "box32"
	matter = list(MATERIAL_STEEL = 5)
	caliber = ".32"
	ammo_type = /obj/item/ammo_casing/cl32
	max_ammo = 40

/obj/item/ammo_magazine/ammobox/cl32/rubber
	name = "ammunition box (.32 rubber)"
	icon_state = "box32-rubber"
	ammo_type = /obj/item/ammo_casing/cl32/rubber

/obj/item/ammo_magazine/ammobox/c45
	name = "ammunition box (.45)"
	icon_state = "box45"
	matter = list(MATERIAL_STEEL = 8)
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c45/flash
	name = "ammunition box (.45)"
	icon_state = "box45-flash"
	ammo_type = /obj/item/ammo_casing/c45/flash

/obj/item/ammo_magazine/ammobox/c45/practice
	name = "ammunition box (.45)"
	icon_state = "box45-practice"
	ammo_type = /obj/item/ammo_casing/c45/practice

/obj/item/ammo_magazine/ammobox/c45/rubber
	name = "ammunition box (.45)"
	icon_state = "box45-rubber"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/ammobox/c10x24
	name = "ammunition box (10mm x 24 caseless)"
	icon_state = "box10x24"
	matter = list(MATERIAL_STEEL = 8)
	caliber = "10x24"
	ammo_type = /obj/item/ammo_casing/c10x24
	max_ammo = 200

/obj/item/ammo_magazine/ammobox/a556
	name = "ammunition box (5.56mm)"
	icon_state = "box556mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_LARGE
	caliber = "a556"
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/a556/practice
	name = "ammunition box (5.56mm practice)"
	icon_state = "box556mm-practice"
	ammo_type = /obj/item/ammo_casing/a556/practice

/obj/item/ammo_magazine/ammobox/c65mm
	name = "ammunition box (6.5mm)"
	icon_state = "box65mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_LARGE
	caliber = "6.5mm"
	ammo_type = /obj/item/ammo_casing/c65
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/c65mm/rubber
	name = "ammunition box (6.5mm rubber)"
	icon_state = "box65mm-rubber"
	ammo_type = /obj/item/ammo_casing/c65/rubber

/obj/item/ammo_magazine/ammobox/a762
	name = "ammunition box (7.62mm)"
	icon_state = "box762mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_LARGE
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	mag_type = SPEEDLOADER | MAGAZINE
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/c357
	name = "ammunition box (.357)"
	icon_state = "box357"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c38
	name = "ammunition box (.38)"
	icon_state = "box38"
	matter = list(MATERIAL_STEEL = 5)
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c38/rubber
	name = "ammunition box (.38 rubber)"
	icon_state = "box38-rubber"
	ammo_type = /obj/item/ammo_casing/c38/rubber

/obj/item/ammo_magazine/ammobox/c44
	name = "ammunition box (.44)"
	icon_state = "box44"
	matter = list(MATERIAL_STEEL = 5)
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/cl44
	max_ammo = 20

/obj/item/ammo_magazine/ammobox/c44/rubber
	name = "ammunition box (.44 rubber)"
	icon_state = "box44-rubber"
	ammo_type = /obj/item/ammo_casing/cl44/rubber

/obj/item/ammo_magazine/ammobox/c50
	name = "ammunition box (.50)"
	icon_state = "box50"
	matter = list(MATERIAL_STEEL = 10)
	caliber = ".50"
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 20

/obj/item/ammo_magazine/ammobox/c50/rubber
	name = "ammunition box (.50 rubber)"
	icon_state = "box50-rubber"
	ammo_type = /obj/item/ammo_casing/a50/rubber

/obj/item/ammo_magazine/ammobox/a145
	name = "ammunition box (14.5mm)"
	icon_state = "box145mm"
	matter = list(MATERIAL_STEEL = 8)
	w_class = ITEM_SIZE_LARGE
	caliber = "14.5mm"
	ammo_type = /obj/item/ammo_casing/a145
	max_ammo = 30
