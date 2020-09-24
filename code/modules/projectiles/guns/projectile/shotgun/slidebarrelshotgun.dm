/obj/item/weapon/gun/projectile/shotgun/slidebarrelshotgun
	name = "Slide Barrel Shotgun"
	desc = "Slide Barrel Shotgun, made out of trash, but rather special on its design"
	icon = 'icons/obj/guns/projectile/slideshotgun.dmi'
	icon_state = "slideshotgun"
	item_state = "slideshotgun"
	max_shells = 1
	caliber = CAL_SHOTGUN
	handle_casings = HOLD_CASINGS
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_dual = 1
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	damage_multiplier = 0.8 //same as sawn-off
	recoil_buildup = 16 //makin it a bit more than most shotguns
	one_hand_penalty = 10 //compact shotgun level, so same as sawn off
	price_tag = 250 //cheap as they get

/obj/item/weapon/gun/projectile/shotgun/slidebarrelshotgun/load_ammo(var/obj/item/A, mob/user)
	var/turf/newloc = get_turf(src)
	if(chambered)//We have a shell in the chamber
		chambered.forceMove(newloc) //Eject casing
		chambered = null
		playsound(usr, 'sound/weapons/shotgunpump.ogg', 60, 1)
		icon_state = "slideshotgun_load"   
	if(istype(A, /obj/item/ammo_casing))
		..()
		var/obj/item/ammo_casing/shell = loaded[1]
		loaded -= shell
		chambered = shell
		to_chat(user, SPAN_NOTICE("You chamber a new shell, ejecting [chambered]!"))
		playsound(src.loc, 'sound/weapons/guns/interact/hpistol_cock.ogg', 70, 1)
	update_icon()
	addtimer(CALLBACK(src, .proc/seticon),2 SECONDS)

/obj/item/weapon/gun/projectile/shotgun/slidebarrelshotgun/proc/seticon() //so the animation plays each time you load it and we don't need to keed ticking it process
	icon_state = "slideshotgun"
