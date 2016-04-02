/obj/item/weapon/bluespace_harpoon
	name = "bluespace harpoon"
	desc = "For climbing on bluespace mountains!"
	icon_state = "harpoon-2"
	icon = 'icons/obj/items.dmi'
	w_class = 3.0
	throw_speed = 4
	throw_range = 20
	origin_tech = "bluespace=5"
	//m_amt = 15
	var/mode = 1  // 1 mode - teleport you to turf  0 mode teleport turf to you
	var/last_fire = 0
	var/transforming = 0


/obj/item/weapon/bluespace_harpoon/afterattack(atom/A, mob/user as mob)
	var/current_fire = world.time
	if(!user || !A || user.machine)
		return
	if(transforming)
		user << "<span class = 'warning'>You can't fire while [src] transforming!</span>"
		return
	if(!(current_fire - last_fire >= 200))
		user << "<span class = 'warning'>[src] is recharging</span>"
		return

	last_fire = current_fire


	playsound(user, 'sound/weapons/wave.ogg', 60, 1)

	for(var/mob/O in oviewers(src))
		if ((O.client && !( O.blinded )))
			O << "<span class = 'warning'>[user] fire from [src]</span>"
	user << "<span class = 'warning'>You fire from [src]</span>"

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, A)
	s.start()
	//var/datum/effect/effect/system/spark_spread/S = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, user)
	s.start()

	var/turf/AtomTurf = get_turf(A)
	var/turf/UserTurf = get_turf(user)
	if(mode)
		for(var/obj/O in UserTurf)
			if(!O.anchored)
				if(prob(10))
					O.loc = pick(orange(24,user))
				else
					//O.Move(A.x, A.y)//A.loc
					//world << O
					O.loc = AtomTurf
					//O.Move(TA)

		for(var/mob/M in UserTurf)
			if(prob(10))
				M.loc = pick(orange(24,user))
			else
				//M.Move(A.x, A.y)
				//world << M
				M.loc = AtomTurf
				//M.Move(TA)

	else
		for(var/obj/O in AtomTurf)
			if(!O.anchored)
				if(prob(10))
					O.loc = pick(orange(24,user))
				else
					//O.Move(user.x, user.y)
					//world << O
					O.loc = UserTurf
					//O.Move(TU)

		for(var/mob/M in AtomTurf)
			if(prob(10))
				M.loc = pick(orange(24,user))
			else
				//M.Move(user.x, user.y)
				//world << M
				M.loc = UserTurf
				//M.Move(TU)

/obj/item/weapon/bluespace_harpoon/attack_self(mob/living/user as mob)
	return chande_fire_mode(user)

/obj/item/weapon/bluespace_harpoon/verb/chande_fire_mode(mob/user as mob)
	set name = "Change fire mode"
	set category = "Object"
	set src in oview(1)
	if(transforming) return
	mode = !mode
	transforming = 1
	user << "<span class = 'info'>You change [src] mode to [mode ? "transmiting" : "receiving"]</span>"
	update_icon()

/obj/item/weapon/bluespace_harpoon/update_icon()
	if(transforming)
		switch(mode)
			if(0)
				flick("harpoon-2-change", src)
				icon_state = "harpoon-1"
			if(1)
				flick("harpoon-1-change",src)
				icon_state = "harpoon-2"
		transforming = 0