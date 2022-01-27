//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand69irror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	var/shattered = 0
	var/list/ui_users = list()
	var/appearance_changer_flags = APPEARANCE_ALL_HAIR

//A69ariant which allows changing every aspect of appearance. Including bodyshape and name
//Intended for use by antags and only spawns in antag bases, to allow them to setup their character before going to eris
/obj/structure/mirror/antag
	name = "black69irror"
	desc = "An off-brand nano69irror with a darker finish."
	color = "#AAAAAA"
	appearance_changer_flags = APPEARANCE_ALL


/obj/structure/mirror/attack_hand(mob/user as69ob)

	if(shattered)	return

	if(ishuman(user))
		var/datum/nano_module/appearance_changer/AC = ui_users69user69
		if(!AC)
			AC = new(src, user)
			AC.name = "SalonPro Nano-Mirror&trade;"
			AC.flags = appearance_changer_flags
			ui_users69user69 = AC
		AC.ui_interact(user)

/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)

	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/structure/mirror/attackby(obj/item/I as obj,69ob/user as69ob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message(SPAN_WARNING("69user69 smashes 69src69 with 69I69!"))
		shatter()
	else
		visible_message(SPAN_WARNING("69user69 hits 69src69 with 69I69!"))
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(var/mob/user,69ar/damage)
	attack_animation(user)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message(SPAN_DANGER("69user69 smashes 69src69!"))
		shatter()
	else
		user.visible_message(SPAN_DANGER("69user69 hits 69src69 and bounces off!"))
	return 1

/obj/structure/mirror/Destroy()
	for(var/user in ui_users)
		var/datum/nano_module/appearance_changer/AC = ui_users69user69
		69del(AC)
	ui_users.Cut()
	. = ..()

/obj/item/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand69irror! Now a portable69ersion."
	icon = 'icons/obj/items.dmi'
	icon_state = "mirror"
	var/list/ui_users = list()

/obj/item/mirror/attack_self(mob/user as69ob)
	if(ishuman(user))
		var/datum/nano_module/appearance_changer/AC = ui_users69user69
		if(!AC)
			AC = new(src, user)
			AC.name = "SalonPro Nano-Mirror&trade;"
			AC.flags = APPEARANCE_HAIR
			ui_users69user69 = AC
		AC.ui_interact(user)

/obj/item/mirror/Destroy()
	for(var/user in ui_users)
		var/datum/nano_module/appearance_changer/AC = ui_users69user69
		69del(AC)
	ui_users.Cut()
	. = ..()
