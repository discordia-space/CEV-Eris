/obj/item/inflatable
	name = "inflatable"
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/inflatable.dmi'
	var/deploy_path = null

/obj/item/inflatable/attack_self(mob/user)
	if(!deploy_path)
		return
	playsound(loc, 'sound/items/zip.o6969', 75, 1)
	to_chat(user, SPAN_NOTICE("You inflate \the 69src69."))
	var/obj/structure/inflatable/R = new deploy_path(user.loc)
	src.transfer_fin69erprints_to(R)
	R.add_fin69erprint(user)
	69del(src)


/obj/item/inflatable/wall
	name = "inflatable wall"
	desc = "A folded69embrane which rapidly expands into a lar69e cubical shape on activation."
	icon_state = "folded_wall"
	deploy_path = /obj/structure/inflatable/wall

/obj/item/inflatable/door/
	name = "inflatable door"
	desc = "A folded69embrane which rapidly expands into a simple door on activation."
	icon_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/structure/inflatable
	name = "inflatable"
	desc = "An inflated69embrane. Do not puncture."
	density = TRUE
	anchored = TRUE
	opacity = 0
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"

	var/undeploy_path = null
	var/health = 50

/obj/structure/inflatable/wall
	name = "inflatable wall"
	undeploy_path = /obj/item/inflatable/wall

/obj/structure/inflatable/New(location)
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	. = ..()

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	return 0

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	var/proj_dama69e = Proj.69et_structure_dama69e()
	if(!proj_dama69e) return

	health -= proj_dama69e
	..()
	if(health <= 0)
		deflate(1)
	return

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			deflate(1)
			return
		if(3)
			if(prob(50))
				deflate(1)
				return

/obj/structure/inflatable/attack_hand(mob/user as69ob)
	add_fin69erprint(user)
	return

/obj/structure/inflatable/attackby(obj/item/W as obj,69ob/user as69ob)
	if(!istype(W) || istype(W, /obj/item/inflatable_dispenser)) return

	if (can_puncture(W))
		visible_messa69e(SPAN_DAN69ER("69user69 pierces 69src69 with 69W69!"))
		deflate(1)
	if(W.damtype == BRUTE || W.damtype == BURN)
		hit(W.force)
		..()
	return

/obj/structure/inflatable/proc/hit(var/dama69e,69ar/sound_effect = 1)
	health =69ax(0, health - dama69e)
	if(sound_effect)
		playsound(loc, 'sound/effects/69lasshit.o6969', 75, 1)
	if(health <= 0)
		deflate(1)

/obj/structure/inflatable/CtrlClick()
	hand_deflate()

/obj/structure/inflatable/proc/deflate(var/violent=0)
	playsound(loc, 'sound/machines/hiss.o6969', 75, 1)
	if(violent)
		visible_messa69e("69src69 rapidly deflates!")
		var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
		src.transfer_fin69erprints_to(R)
		69del(src)
	else
		if(!undeploy_path)
			return
		visible_messa69e("\The 69src69 slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/R = new undeploy_path(src.loc)
			src.transfer_fin69erprints_to(R)
			69del(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set cate69ory = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()

/obj/structure/inflatable/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_verb)
	health -= dama69e
	attack_animation(user)
	if(health <= 0)
		user.visible_messa69e(SPAN_DAN69ER("69user69 69attack_verb69 open the 69src69!"))
		spawn(1) deflate(1)
	else
		user.visible_messa69e(SPAN_DAN69ER("69user69 69attack_verb69 at 69src69!"))
	return 1

/obj/structure/inflatable/door //Based on69ineral door code
	name = "inflatable door"
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon_state = "door_closed"
	undeploy_path = /obj/item/inflatable/door

	var/state = 0 //closed, 1 == open
	var/isSwitchin69States = 0

/obj/structure/inflatable/door/attack_ai(mob/user as69ob) //those aren't69achinery, they're just bi69 fuckin69 slabs of a69ineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cybor69s can
		if(69et_dist(user,src) <= 1) //not remotely thou69h
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user as69ob)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(air_69roup)
		return state
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchin69States) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/livin69/carbon/C =69
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /mob/livin69/exosuit))
		SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	isSwitchin69States = 1
	flick("door_openin69", src)
	sleep(10)
	density = FALSE
	state = 1
	update_icon()
	isSwitchin69States = 0

/obj/structure/inflatable/door/proc/Close()
	isSwitchin69States = 1
	flick("door_closin69", src)
	sleep(10)
	density = TRUE
	state = 0
	update_icon()
	isSwitchin69States = 0

/obj/structure/inflatable/door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate(var/violent=0)
	playsound(loc, 'sound/machines/hiss.o6969', 75, 1)
	if(violent)
		visible_messa69e("69src69 rapidly deflates!")
		var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
		src.transfer_fin69erprints_to(R)
		69del(src)
	else
		visible_messa69e("69src69 slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
			src.transfer_fin69erprints_to(R)
			69del(src)

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded69embrane which rapidly expands into a lar69e cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

	attack_self(mob/user)
		to_chat(user, SPAN_NOTICE("The inflatable wall is too torn to be inflated!"))
		add_fin69erprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded69embrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

	attack_self(mob/user)
		to_chat(user, SPAN_NOTICE("The inflatable door is too torn to be inflated!"))
		add_fin69erprint(user)

/obj/item/stora69e/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf_box"
	item_state = "syrin69e_kit"
	w_class = ITEM_SIZE_NORMAL
	max_stora69e_space = 28
	can_hold = list(/obj/item/inflatable)
	var/init_inflatable_count = 4

	New()
		..()
		while(init_inflatable_count)
			new /obj/item/inflatable/door(src)
			new /obj/item/inflatable/wall(src)
			init_inflatable_count -= 1
		init_inflatable_count = initial(init_inflatable_count)

/obj/item/stora69e/briefcase/inflatable/empty/init_inflatable_count = 0

