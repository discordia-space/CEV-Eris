/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/curtain.dmi'
	icon_state = "closed"
	opacity = 1
	density = FALSE
	layer = WALL_OBJ_LAYER

/obj/structure/curtain/open
	icon_state = "open"
	layer = SI69N_LAYER
	opacity = 0

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodama69e)
		visible_messa69e(SPAN_WARNIN69("69P69 tears 69src69 down!"))
		69del(src)
	else
		..(P, def_zone)

/obj/structure/curtain/attack_hand(mob/user)
	playsound(69et_turf(loc), "rustle", 15, 1, -5)
	to6969le()
	..()

/obj/structure/curtain/proc/to6969le()
	opacity = !opacity
	if(opacity)
		icon_state = "closed"
		layer = WALL_OBJ_LAYER
	else
		icon_state = "open"
		layer = SI69N_LAYER

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/open/bed
	name = "bed curtain"
	color = "#854636"

/obj/structure/curtain/open/privacy
	name = "privacy curtain"
	color = "#B8F5E3"

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/open/shower/en69ineerin69
	color = "#FFA500"

/obj/structure/curtain/open/shower/security
	color = "#AA0000"
