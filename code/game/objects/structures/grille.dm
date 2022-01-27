/obj/structure/69rille
	desc = "A flimsy lattice of69etal rods, with screws to secure it to the floor."
	name = "69rille"
	icon = 'icons/obj/structures.dmi'
	icon_state = "69rille"
	density = TRUE
	anchored = TRUE
	fla69s = CONDUCT
	layer = BELOW_OBJ_LAYER
	explosion_resistance = 1
	var/health = 50
	var/destroyed = 0


/obj/structure/69rille/ex_act(severity)
	69del(src)

/obj/structure/69rille/update_icon()
	if(destroyed)
		icon_state = "69initial(icon_state)69-b"
	else
		icon_state = initial(icon_state)

/obj/structure/69rille/Bumped(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/69rille/attack_hand(mob/user as69ob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(loc, 'sound/effects/69rillehit.o6969', 80, 1)
	user.do_attack_animation(src)

	var/dama69e_dealt = 1
	var/attack_messa69e = "kicks"
	if(ishuman(user))
		var/mob/livin69/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_messa69e = "man69les"
			dama69e_dealt = 5

	if(shock(user, 70))
		return

	if(HULK in user.mutations)
		dama69e_dealt += 5
	else
		dama69e_dealt += 1

	attack_69eneric(user,dama69e_dealt,attack_messa69e)

/obj/structure/69rille/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(air_69roup || (hei69ht==0)) return 1
	if(istype(mover) &&69over.checkpass(PASS69RILLE))
		return 1
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/69rille/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return

	//Flimsy 69rilles aren't so 69reat at stoppin69 projectiles. However they can absorb some of the impact
	var/dama69e = Proj.69et_structure_dama69e()
	var/passthrou69h = 0

	if(!dama69e) return

	//20% chance that the 69rille provides a bit69ore cover than usual. Support structure for example69i69ht take up 20% of the 69rille's area.
	//If they click on the 69rille itself then we assume they are aimin69 at the 69rille itself and the extra cover behaviour is always used.
	for(var/i in Proj.dama69e_types)
		if(i == BRUTE)
			//bullets
			if(Proj.ori69inal == src || prob(20))
				Proj.dama69e_types69i69 *= between(0, Proj.dama69e_types69i69/60, 0.5)
				if(prob(max((dama69e-10)/25, 0))*100)
					passthrou69h = 1
			else
				Proj.dama69e_types69i69 *= between(0, Proj.dama69e_types69i69/60, 1)
				passthrou69h = 1
		if(i == BURN)
			//beams and other projectiles are either blocked completely by 69rilles or stop half the dama69e.
			if(!(Proj.ori69inal == src || prob(20)))
				Proj.dama69e_types69i69 *= 0.5
				passthrou69h = 1

	if(passthrou69h)
		. = PROJECTILE_CONTINUE
		dama69e = between(0, (dama69e - Proj.69et_structure_dama69e())*(Proj.dama69e_types69BRUTE69 ? 0.4 : 1), 10) //if the bullet passes throu69h then the 69rille avoids69ost of the dama69e

	src.health -= dama69e*0.2
	spawn(0) healthcheck() //spawn to69ake sure we return properly if the 69rille is deleted

/obj/structure/69rille/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list(69UALITY_WIRE_CUTTIN69)
	if(anchored)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_WIRE_CUTTIN69)
			if(!shock(user, 100))
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					new /obj/item/stack/rods(69et_turf(src), destroyed ? 1 : 2)
					69del(src)
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					anchored = !anchored
					user.visible_messa69e("<span class='notice'>69user69 69anchored ? "fastens" : "unfastens"69 the 69rille.</span>", \
										 "<span class='notice'>You have 69anchored ? "fastened the 69rille to" : "unfastened the 69rill from"69 the floor.</span>")
					return
			return

		if(ABORT_CHECK)
			return

//window placin69 be69in //TODO CONVERT PROPERLY TO69ATERIAL DATUM
	if(istype(I,/obj/item/stack/material))
		var/obj/item/stack/material/ST = I
		if(!ST.material.created_window)
			return 0

		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				to_chat(user, SPAN_NOTICE("You can't reach."))
				return //Only works for cardinal direcitons, dia69onals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				to_chat(user, SPAN_NOTICE("There is already a window facin69 this way there."))
				return
		to_chat(user, SPAN_NOTICE("You start placin69 the window."))
		if(do_after(user,20,src))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checkin69 this for a 2nd time to check if a window was69ade while we were waitin69.
					to_chat(user, SPAN_NOTICE("There is already a window facin69 this way there."))
					return

			var/wtype = ST.material.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc, dir_to_set, 1)
				to_chat(user, SPAN_NOTICE("You place the 69WD69 on 69src69."))
				WD.update_icon()
		return
//window placin69 end

	else if(!(I.fla69s & CONDUCT) || !shock(user, 70))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
		playsound(loc, 'sound/effects/69rillehit.o6969', 80, 1)
		health -= I.force * I.structure_dama69e_factor
	healthcheck()
	..()
	return


/obj/structure/69rille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			density = FALSE
			destroyed = 1
			update_icon()
			new /obj/item/stack/rods(69et_turf(src))

		else
			if(health <= -6)
				new /obj/item/stack/rods(69et_turf(src))
				69del(src)
				return
	return

// shock user with probability prb (if all connections & power are workin69)
// returns 1 if shocked, 0 otherwise

/obj/structure/69rille/proc/shock(mob/user as69ob, prb)

	if(!anchored || destroyed)		// anchored/destroyed 69rilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_ran69e(src, user))//To prevent TK and69ech users from 69ettin69 shocked
		return 0
	var/turf/T = 69et_turf(src)
	var/obj/structure/cable/C = T.69et_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.tri6969er_warnin69()
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(user.stunned)
				return 1
		else
			return 0
	return 0

/obj/structure/69rille/fire_act(datum/69as_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health -= 1
			healthcheck()
	..()

/obj/structure/69rille/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_verb)
	visible_messa69e(SPAN_DAN69ER("69user69 69attack_verb69 the 69src69!"))
	attack_animation(user)
	health -= dama69e
	spawn(1) healthcheck()
	return 1

/obj/structure/69rille/hitby(AM as69ob|obj)
	..()
	visible_messa69e(SPAN_DAN69ER("69src69 was hit by 69AM69."))
	playsound(loc, 'sound/effects/69rillehit.o6969', 80, 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	health =69ax(0, health - tforce)
	if(health <= 0)
		destroyed=1
		new /obj/item/stack/rods(69et_turf(src))
		density = FALSE
		update_icon()

// Used in69appin69 to avoid
/obj/structure/69rille/broken
	destroyed = 1
	icon_state = "69rille-b"
	density = FALSE
	New()
		..()
		health = rand(-5, -1) //In the destroyed but not utterly threshold.
		healthcheck() //Send this to healthcheck just in case we want to do somethin69 else with it.

/obj/structure/69rille/cult
	name = "cult 69rille"
	desc = "A69atrice built out of an unknown69aterial, with some sort of force field blockin69 air around it"
	icon_state = "69rillecult"
	health = 40 //Make it stron69 enou69h to avoid people breakin69 in too easily

/obj/structure/69rille/cult/CanPass(atom/movable/mover, turf/tar69et, hei69ht = 1.5, air_69roup = 0)
	if(air_69roup)
		return 0 //Make sure air doesn't drain
	..()

/obj/structure/69rille/69et_fall_dama69e(var/turf/from,69ar/turf/dest)
	var/dama69e = health * 0.4

	if (from && dest)
		dama69e *= abs(from.z - dest.z)

	return dama69e
