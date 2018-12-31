/obj
	var/can_buckle = 0
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null

/obj/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		user_unbuckle_mob(user)

/obj/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		user_buckle_mob(M, user)

/obj/Destroy()
	unbuckle_mob()
	return ..()


/obj/proc/buckle_mob(mob/living/M)
	if(!can_buckle || !istype(M) || (M.loc != loc) || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
		return 0

	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.update_canmove()
	buckled_mob = M
	post_buckle_mob(M)
	return 1

/obj/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob = null

		post_buckle_mob(.)

/obj/proc/post_buckle_mob(mob/living/M)
	return

/obj/proc/user_buckle_mob(mob/living/M, mob/user)
	if(!user.Adjacent(M) || !src.Adjacent(M) || user.restrained() || user.lying || user.stat || istype(user, /mob/living/silicon/pai))
		return
	if(M == buckled_mob)
		return
	if(isslime(M))
		user << SPAN_WARNING("The [M] is too squishy to buckle in.")
		return

	add_fingerprint(user)
	unbuckle_mob()

	
	
	var/buckleTime = 25
	if (M == user)
		user.set_dir(src.dir)
		buckleTime = 8
		user.visible_message(\
		SPAN_NOTICE("[user] attempts to buckle themselves into \the [src]!</span>"),\
		SPAN_NOTICE("You attempt to buckle yourself into \the [src]!</span>"),\
		SPAN_NOTICE("You hear metal clanking."))
	else
		user.face_atom(src)
		//can't buckle unless you share locs so try to move M to the obj.
		spawn()
			if(M.loc != src.loc && do_after(user, buckleTime*0.66, src, progress = FALSE))
				step_towards(M, src)
				if(user.loc != M.loc)
					user.do_attack_animation(M)
		user.visible_message(\
		SPAN_NOTICE("[user] attempts to buckle [M] into \the [src]!</span>"),\
		SPAN_NOTICE("You attempt to buckle [M] into \the [src]!</span>"),\
		SPAN_NOTICE("You hear metal clanking."))
	
	if(do_after(user, buckleTime, src))
		if(buckle_mob(M))
			playsound(src.loc, 'sound/machines/Custom_closetopen.ogg', 15, 1, -3)
			if(M == user)
				M.visible_message(\
					SPAN_NOTICE("[M.name] buckles themselves to [src]."),\
					SPAN_NOTICE("You buckle yourself to [src]."),\
					SPAN_NOTICE("You hear metal clanking."))
			else
				M.visible_message(\
					SPAN_DANGER("[M.name] is buckled to [src] by [user.name]!"),\
					SPAN_DANGER("You are buckled to [src] by [user.name]!"),\
					SPAN_NOTICE("You hear metal clanking."))

/obj/proc/user_unbuckle_mob(mob/user)
	var/unbuckleTime = 18
	if (buckled_mob == user)
		unbuckleTime = 6
	else
		user.visible_message(\
		SPAN_NOTICE("[user] attempts to unbuckle [buckled_mob] out of \the [src]!</span>"),\
		SPAN_NOTICE("You attempt to unbuckle [buckled_mob] out of \the [src]!</span>"),\
		SPAN_NOTICE("You hear metal clanking."))
	if(do_after(user, unbuckleTime, src))
		var/mob/living/M = unbuckle_mob()
		if(M)
			if(user.loc != M.loc)
				user.do_attack_animation(src)
			if(M != user)
				M.visible_message(\
					SPAN_NOTICE("[M.name] was unbuckled by [user.name]!"),\
					SPAN_NOTICE("You were unbuckled from [src] by [user.name]."),\
					SPAN_NOTICE("You hear metal clanking."))
			else
				M.visible_message(\
					SPAN_NOTICE("[M.name] unbuckled themselves!"),\
					SPAN_NOTICE("You unbuckle yourself from [src]."),\
					SPAN_NOTICE("You hear metal clanking."))
			add_fingerprint(user)
		return M

