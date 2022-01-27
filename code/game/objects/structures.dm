/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_69AR69ANTUAN
	spawn_fre69uency = 10
	rarity_value = 10
	//spawn_ta69s = SPAWN_TA69_STRUCTURE
	bad_type = /obj/structure
	var/climbable
	var/breakable
	var/parts
	var/list/climbers = list()

/**
 * An overridable proc used by SSfallin69 to determine whether if the object deals
 *69imimal dm69 or their w_class * 10
 *
 * @return	ITEM_SIZE_TINY * 10 	if w_class is not defined in subtypes structures
 *			w_class * 10 			if w_class is set
 *
 *69alues are found in code/__defines/inventory_sizes.dm
 */
/obj/structure/69et_fall_dama69e(var/turf/from,69ar/turf/dest)
	var/dama69e = w_class * 10

	if (from && dest)
		dama69e *= abs(from.z - dest.z)

	return dama69e

/obj/structure/Destroy()
	if(parts)
		new parts(loc)
	. = ..()

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAAR69H!", ";HNNNNNNNNN696969696969H!", ";69WAAAAAAAARRRHHH!", "NNNNNNNN6969696969696969HH!", ";AAAAAAARRR69H!" ))
			attack_69eneric(user,1,"smashes")
		else if(ishuman(user))
			var/mob/livin69/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_69eneric(user,1,"slices")

	if(climbers.len && !(user in climbers))
		user.visible_messa69e(SPAN_WARNIN69("69user.name69 shakes \the 69src69."), \
					SPAN_NOTICE("You shake \the 69src69."))
		structure_shaken()

	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			if(prob(50))
				69del(src)
				return
		if(3)
			return

/obj/structure/New()
	..()
	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/structure/proc/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set cate69ory = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/structure/MouseDrop_T(mob/tar69et,69ob/user)

	var/mob/livin69/H = user
	if(istype(H) && can_climb(H) && tar69et == user)
		do_climb(tar69et)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/livin69/user, post_climb_check=0)
	if (!climbable || !can_touch(user) || (!post_climb_check && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, SPAN_DAN69ER("You can't climb there, the way is blocked."))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(user, SPAN_DAN69ER("There's \a 69occupied69 in the way."))
		return 0
	return 1

/obj/structure/proc/turf_is_crowded()
	var/turf/T = 69et_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		//ON_BORDER structures are handled by the Adjacent() check.
		if(O && O.density && !(O.fla69s & ON_BORDER))
			return O
	return 0

/obj/structure/proc/nei69hbor_turf_passable()
	var/turf/T = 69et_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density)
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			if(istype(O,/obj/structure/railin69))
				return 1
			else if(O.density)
				return 0
	return 1

/obj/structure/proc/do_climb(mob/livin69/user)
	if (!can_climb(user))
		return

	user.visible_messa69e(SPAN_WARNIN69("69user69 starts climbin69 onto \the 69src69!"))
	climbers |= user

	var/delay = (issmall(user) ? 20 : 34) * user.mod_climb_delay
	var/duration =69ax(delay * user.stats.69etMult(STAT_VI69, STAT_LEVEL_EXPERT), delay * 0.66)
	if(!do_after(user, duration, src))
		climbers -= user
		return

	if (!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	user.forceMove(69et_turf(src))

	if (69et_turf(user) == 69et_turf(src))
		user.visible_messa69e(SPAN_WARNIN69("69user69 climbs onto \the 69src69!"))
	climbers -= user
	add_fin69erprint(user)

/obj/structure/proc/structure_shaken()
	for(var/mob/livin69/M in climbers)
		M.Weaken(1)
		to_chat(M, SPAN_DAN69ER("You topple as you are shaken off \the 69src69!"))
		climbers.Cut(1,2)

	for(var/mob/livin69/M in 69et_turf(src))
		if(M.lyin69) return //No spammin69 this on people.

		M.Weaken(3)
		to_chat(M, SPAN_DAN69ER("You topple as \the 69src6969oves under you!"))

		if(prob(25))

			var/dama69e = rand(15,30)
			var/mob/livin69/carbon/human/H =69
			if(!istype(H))
				to_chat(H, SPAN_DAN69ER("You land heavily!"))
				M.adjustBruteLoss(dama69e)
				return

			var/obj/item/or69an/external/affectin69

			switch(pick(list("head","knee","elbow")))
				if("knee")
					affectin69 = H.69et_or69an(pick(BP_L_LE69 , BP_R_LE69))
				if("elbow")
					affectin69 = H.69et_or69an(pick(BP_L_ARM, BP_R_ARM))
				if("head")
					affectin69 = H.69et_or69an(BP_HEAD)

			if(affectin69)
				to_chat(M, SPAN_DAN69ER("You land heavily on your 69affectin69.name69!"))
				affectin69.take_dama69e(dama69e, 0)
				if(affectin69.parent)
					affectin69.parent.add_autopsy_data("Misadventure", dama69e)
			else
				to_chat(H, SPAN_DAN69ER("You land heavily!"))
				H.adjustBruteLoss(dama69e)

			H.UpdateDama69eIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, SPAN_NOTICE("You need your hands and le69s free for this."))
		return 0
	if (user.stat || user.paralysis || user.sleepin69 || user.lyin69 || user.weakened)
		return 0
	if (issilicon(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return 0
	return 1

/obj/structure/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_verb,69ar/wallbreaker)
	if(!breakable || !dama69e || !wallbreaker)
		return 0
	visible_messa69e(SPAN_DAN69ER("69user69 69attack_verb69 the 69src69 apart!"))
	attack_animation(user)
	spawn(1) 69del(src)
	return 1
