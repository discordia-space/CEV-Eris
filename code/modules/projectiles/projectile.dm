/*
#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"
*/
/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = TRUE
	unacidable = TRUE
	anchored = TRUE //There's a reason this is here,69port. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASSTABLE
	mouse_opacity = 0
	spawn_blacklisted = TRUE
	spawn_fre69uency = 0
	spawn_tags =69ull
	style_damage = 13 // stylish people can dodge lots of projectiles
	var/bumped = FALSE		//Prevents it from hitting69ore than one guy at once
	var/hitsound_wall = "ricochet"
	var/list/mob_hit_sound = list('sound/effects/gore/bullethit2.ogg', 'sound/effects/gore/bullethit3.ogg') //Sound it69akes when it hits a69ob. It's a list so you can put69ultiple hit sounds there.
	var/def_zone = ""	//Aiming at
	var/mob/firer =69ull//Who shot it
	var/silenced = FALSE	//Attack69essage
	var/yo =69ull
	var/xo =69ull
	var/current =69ull
	var/shot_from = "" //69ame of the object which shot us
	var/atom/original =69ull // the target clicked (not69ecessarily where the projectile is headed). Should probably be renamed to 'target' or something.
	var/turf/starting =69ull // the projectile's starting turf
	var/turf/last_interact =69ull // the last turf where def_zone calculation took place
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/nocap_structures = FALSE // wether or69ot this projectile can circumvent the damage cap you can do to walls and doors in one hit. Also increases the structure damage done to walls by 300%
	var/can_ricochet = FALSE // defines if projectile can or cannot ricochet.
	var/ricochet_id = 0 // if the projectile ricochets, it gets its uni69ue id in order to process iteractions with adjacent walls correctly.
	var/ricochet_ability = 1 //69ultiplier for how69uch it can ricochet,69odified by the bullet blender weapon69od

	var/list/damage_types = list(BRUTE = 10) //BRUTE, BURN, TOX, OXY, CLONE, HALLOSS -> int are the only things that should be in here
	var/nodamage = FALSE //Determines if the projectile will skip any damage inflictions
	var/taser_effect = FALSE //If set then the projectile will apply it's agony damage using stun_effect_act() to69obs it hits, and other damage will be ignored
	var/check_armour = ARMOR_BULLET //Defines what armor to use when it hits things. Full list could be found at defines\damage_organs.dm
	var/projectile_type = /obj/item/projectile
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/kill_count = 50 //This will de-increment every process(). When 0, it will delete the projectile.
	var/base_spreading = 90 // higher69alue69eans better chance to hit here. derp.
	var/spreading_step = 15
	var/projectile_accuracy = 1

	//Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/embed = 0 // whether or69ot the projectile can embed itself in the69ob
	var/knockback = 0

	var/hitscan = FALSE		// whether the projectile should be hitscan

	var/step_delay = 0.8	// the delay between iterations if69ot a hitscan projectile
							// This thing right here goes to sleep(). We should69ot send69on decimal things to sleep(),
							// but it was doing it for a while, it works, and this whole shit should be rewriten or ported from another codebase.

	// effect types to be used
	var/muzzle_type
	var/tracer_type
	var/impact_type
	var/luminosity_range
	var/luminosity_power
	var/luminosity_color
	var/luminosity_ttl
	var/obj/effect/attached_effect
	var/proj_sound

	var/proj_color //If defined, is used to change the69uzzle, tracer, and impact icon colors through Blend()

	var/datum/plot_vector/trajectory	// used to plot the path of the projectile
	var/datum/vector_loc/location		// current location of the projectile in pixel space
	var/matrix/effect_transform			//69atrix to rotate and scale projectile effects - putting it here so it doesn't
										//  have to be recreated69ultiple times


/obj/item/projectile/is_hot()
	if (damage_types69BURN69)
		return damage_types69BURN69 * heat

/obj/item/projectile/proc/get_total_damage()
	var/val = 0
	for(var/i in damage_types)
		val += damage_types69i69
	return69al

/obj/item/projectile/proc/is_halloss()
	for(var/i in damage_types)
		if(i != HALLOSS)
			return FALSE
	return TRUE

/obj/item/projectile/multiply_projectile_damage(newmult)
	for(var/i in damage_types)
		damage_types69i69 *=69ewmult

/obj/item/projectile/multiply_projectile_penetration(newmult)
	armor_penetration = initial(armor_penetration) *69ewmult

/obj/item/projectile/multiply_pierce_penetration(newmult)
	penetrating = initial(penetrating) +69ewmult

/obj/item/projectile/multiply_ricochet(newmult)
	ricochet_ability = initial(ricochet_ability) +69ewmult

/obj/item/projectile/multiply_projectile_step_delay(newmult)
	if(!hitscan)
		step_delay = initial(step_delay) *69ewmult

/obj/item/projectile/multiply_projectile_agony(newmult)
	agony = initial(agony) *69ewmult

/obj/item/projectile/proc/multiply_projectile_accuracy(newmult)
	projectile_accuracy = initial(projectile_accuracy) *69ewmult

/obj/item/projectile/proc/adjust_damages(var/list/newdamages)
	if(!newdamages.len)
		return
	for(var/damage_type in69ewdamages)
		if(damage_type == IRRADIATE)
			irradiate +=69ewdamages69IRRADIATE69
			continue
		damage_types69damage_type69 +=69ewdamages69damage_type69

/obj/item/projectile/proc/adjust_ricochet(noricochet)
	if(noricochet)
		can_ricochet = FALSE
		return

/obj/item/projectile/proc/on_hit(atom/target, def_zone =69ull)
	if(!isliving(target))	return 0
	if(isanimal(target))	return 0
	var/mob/living/L = target
	L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy)
	return TRUE

// generate impact effect
/obj/item/projectile/proc/on_impact(atom/A)
    impact_effect(effect_transform)
    if(luminosity_ttl && attached_effect)
        spawn(luminosity_ttl)
        69del(attached_effect)

    if(!ismob(A))
        playsound(src, hitsound_wall, 50, 1, -2)
    return

//Checks if the projectile is eligible for embedding.69ot that it69ecessarily will.
/obj/item/projectile/proc/can_embed()
	//embed69ust be enabled and damage type69ust be brute
	if(!embed || damage_types69BRUTE69 <= 0)
		return FALSE
	return TRUE

/obj/item/projectile/proc/get_structure_damage()
	return damage_types69BRUTE69 + damage_types69BURN69

//return 1 if the projectile should be allowed to pass through after all, 0 if69ot.
/obj/item/projectile/proc/check_penetrate(atom/A)
	return TRUE

/obj/item/projectile/proc/check_fire(atom/target as69ob,69ob/living/user as69ob)  //Checks if you can hit them or69ot.
	check_trajectory(target, user, pass_flags, flags)

//sets the click point of the projectile using69ouse input params
/obj/item/projectile/proc/set_clickpoint(params)
	var/list/mouse_control = params2list(params)
	if(mouse_control69"icon-x"69)
		p_x = text2num(mouse_control69"icon-x"69)
	if(mouse_control69"icon-y"69)
		p_y = text2num(mouse_control69"icon-y"69)

//called to launch a projectile
/obj/item/projectile/proc/launch(atom/target, target_zone, x_offset=0, y_offset=0, angle_offset=0, proj_sound)
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return TRUE

	if(targloc == curloc) //Shooting something in the same turf
		target.bullet_act(src, target_zone)
		on_impact(target)
		69del(src)
		return FALSE

	if(proj_sound)
		playsound(proj_sound)

	original = target
	def_zone = target_zone

	spawn()
		setup_trajectory(curloc, targloc, x_offset, y_offset, angle_offset) //plot the initial trajectory
		Process()

	return FALSE

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target,69ob/user, obj/item/gun/launcher, target_zone, x_offset=0, y_offset=0, angle_offset)
	if(user == target) //Shooting yourself
		user.bullet_act(src, target_zone)
		69del(src)
		return FALSE

	loc = get_turf(user)

	if(iscarbon(user))
		var/mob/living/carbon/human/blanker = user
		if(blanker.can_multiz_pb && (!isturf(target)))
			loc = get_turf(blanker.client.eye)
			if(!(loc.Adjacent(target)))
				loc = get_turf(blanker)

	firer = user
	shot_from = launcher.name
	silenced = launcher.item_flags & SILENT

	return launch(target, target_zone, x_offset, y_offset, angle_offset)

//Used to change the direction of the projectile in flight.
/obj/item/projectile/proc/redirect(new_x,69ew_y, atom/starting_loc,69ob/new_firer)
	var/turf/new_target = locate(new_x,69ew_y, src.z)

	original =69ew_target
	if(new_firer)
		firer = src

	setup_trajectory(starting_loc,69ew_target)

/obj/item/projectile/proc/istargetloc(mob/living/target_mob)
	if(target_mob && original)
		var/turf/originalloc
		if(!istype(original, /turf))
			originalloc = original.loc
		else
			originalloc = original
		if(originalloc == target_mob.loc)
			return 1
		else
			return 0
	else
		return 0

/obj/item/projectile/proc/check_hit_zone(turf/target_turf, distance)
	var/hit_zone = check_zone(def_zone)
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later, it is69ore likely to hit the same part
		if(def_zone)
			var/spread =69ax(base_spreading - (spreading_step * distance), 0)
			var/aim_hit_chance =69ax(0, projectile_accuracy)

			if(!prob(aim_hit_chance))
				def_zone = ran_zone(def_zone,spread)
			last_interact = target_turf
		return TRUE
	return FALSE

//Called when the projectile intercepts a69ob. Returns 1 if the projectile hit the69ob, 0 if it69issed and should keep flying.
/obj/item/projectile/proc/attack_mob(mob/living/target_mob, distance,69iss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = 0

	var/result = PROJECTILE_FORCE_MISS

	if(check_hit_zone(get_turf(target_mob), distance))
		if(iscarbon(target_mob))
			var/mob/living/carbon/C = target_mob
			var/obj/item/shield/S
			for(S in get_both_hands(C))
				if(S && S.block_bullet(C, src, def_zone))
					on_hit(S,def_zone)
					69del(src)
					return TRUE
				break //Prevents shield dual-wielding
	//		S = C.get_e69uipped_item(slot_back)
	//		if(S && S.block_bullet(C, src, def_zone))
	//			on_hit(S,def_zone)
	//			69del(src)
	//			return TRUE

		result = target_mob.bullet_act(src, def_zone)
		var/aim_hit_chance =69ax(0, projectile_accuracy)
		if(prob(base_miss_chance69def_zone69 * ((100 - (aim_hit_chance * 2)) / 100)))	//For example: the head has a base 45% chance to69ot get hit, if the shooter has 5069ig the chance to69iss will be reduced by 50% to 22.5%
			result = PROJECTILE_FORCE_MISS

	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			visible_message(SPAN_NOTICE("\The 69src6969isses 69target_mob6969arrowly!"))
		return FALSE

	//hit69essages
	if(silenced)
		to_chat(target_mob, SPAN_DANGER("You've been hit in the 69parse_zone(def_zone)69 by \the 69src69!"))
	else
		visible_message(SPAN_DANGER("\The 69target_mob69 is hit by \the 69src69 in the 69parse_zone(def_zone)69!"))//X has fired Y is69ow given by the guns so you cant tell who shot you if you could69ot see the shooter

	playsound(target_mob, pick(mob_hit_sound), 40, 1)

	//admin logs
	if(!no_attack_log)
		if(ismob(firer))

			var/attacker_message = "shot with \a 69src.type69"
			var/victim_message = "shot with \a 69src.type69"
			var/admin_message = "shot (\a 69src.type69)"

			admin_attack_log(firer, target_mob, attacker_message,69ictim_message, admin_message)
		else
			target_mob.attack_log += "\6969time_stamp()69\69 <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>69target_mob69/69target_mob.ckey69</b> with <b>\a 69src69</b>"
			msg_admin_attack("UNKNOWN shot 69target_mob69 (69target_mob.ckey69) with \a 69src69 (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69target_mob.x69;Y=69target_mob.y69;Z=69target_mob.z69'>JMP</a>)")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return FALSE

	if(target_mob.mob_classification & CLASSIFICATION_ORGANIC)
		var/turf/target_loca = get_turf(target_mob)
		var/mob/living/L = target_mob
		if(damage_types69BRUTE69 > 10)
			var/splatter_dir = dir
			if(starting)
				splatter_dir = get_dir(starting, target_loca)
				target_loca = get_step(target_loca, splatter_dir)
			var/blood_color = "#C80000"
			if(ishuman(target_mob))
				var/mob/living/carbon/human/H = target_mob
				blood_color = H.species.blood_color
			new /obj/effect/overlay/temp/dir_setting/bloodsplatter(target_mob.loc, splatter_dir, blood_color)
			if(target_loca && prob(50))
				target_loca.add_blood(L)

	if(istype(src, /obj/item/projectile/beam/psychic) && istype(target_mob, /mob/living/carbon/human))
		var/obj/item/projectile/beam/psychic/psy = src
		var/mob/living/carbon/human/H = target_mob
		if(psy.contractor && result && (H.sanity.level <= 0))
			psy.holder.reg_break(H)

	return TRUE

/obj/item/projectile/Bump(atom/A as69ob|obj|turf|area, forced = FALSE)
	if(A == src)
		return FALSE
	if(A == firer)
		loc = A.loc
		return FALSE //go fuck yourself in another place pls

	if((bumped && !forced) || (A in permutated))
		return FALSE

	var/passthrough = FALSE //if the projectile should continue flying
	var/distance = get_dist(last_interact,loc)

	var/tempLoc = get_turf(A)

	bumped = TRUE
	if(istype(A, /obj/structure/multiz/stairs/active))
		var/obj/structure/multiz/stairs/active/S = A
		if(S.target)
			forceMove(get_turf(S.target))
			trajectory.loc_z = loc.z
			bumped = FALSE
			return FALSE
	if(ismob(A))
		var/mob/M = A
		if(isliving(A))
			//if they have a69eck grab on someone, that person gets hit instead
			var/obj/item/grab/G = locate() in69
			if(G && G.state >= GRAB_NECK)
				visible_message(SPAN_DANGER("\The 69M69 uses 69G.affecting69 as a shield!"))
				if(Bump(G.affecting, TRUE))
					return //If Bump() returns 0 (keep going) then we continue on to attack69.
			passthrough = !attack_mob(M, distance)
		else
			passthrough = FALSE //so ghosts don't stop bullets
	else
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/living/M in A)
				attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would69ot let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = TRUE
		penetrating--

	//the bullet passes through a dense object!
	if(passthrough)
		//move ourselves onto A so we can continue on our way
		if (!tempLoc)
			69del(src)
			return TRUE

		loc = tempLoc
		if (A)
			permutated.Add(A)
		bumped = FALSE //reset bumped69ariable!
		return FALSE

	//stop flying
	on_impact(A)

	density = FALSE
	invisibility = 101


	69del(src)
	return TRUE

/obj/item/projectile/ex_act()
	return //explosions probably shouldn't delete projectiles

/obj/item/projectile/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE

/obj/item/projectile/Process()
	var/first_step = TRUE

	spawn while(src && src.loc)
		if(kill_count-- < 1)
			on_impact(src.loc) //for any final impact behaviours
			69del(src)
			return
		if((!( current ) || loc == current))
			current = locate(min(max(x + xo, 1), world.maxx),69in(max(y + yo, 1), world.maxy), z)
		if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
			69del(src)
			return

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		if(!location)
			69del(src)	// if it's left the world... kill it
			return

		before_move()
		Move(location.return_turf())
		pixel_x = location.pixel_x
		pixel_y = location.pixel_y

		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					if(Bump(original))
						return

		if(first_step)
			muzzle_effect(effect_transform)
			first_step = FALSE
		else if(!bumped)
			tracer_effect(effect_transform)
			luminosity_effect()

		if(!hitscan)
			sleep(step_delay)	//add delay between69ovement iterations if it's69ot a hitscan weapon

/obj/item/projectile/proc/before_move()
	return FALSE

/obj/item/projectile/proc/setup_trajectory(turf/startloc, turf/targloc, x_offset = 0, y_offset = 0, angle_offset)
	// setup projectile state
	starting = startloc
	current = startloc
	last_interact = startloc
	yo = targloc.y - startloc.y + y_offset
	xo = targloc.x - startloc.x + x_offset

	// plot the initial trajectory
	trajectory =69ew()
	trajectory.setup(starting, original, pixel_x, pixel_y, angle_offset)

	// generate this69ow since all69isual effects the projectile69akes can use it
	effect_transform =69ew()
	effect_transform.Scale(trajectory.return_hypotenuse(), 1)
	effect_transform.Turn(-trajectory.return_angle())		//no idea why this has to be inverted, but it works

	transform = turn(transform, -(trajectory.return_angle() + 90)) //no idea why 9069eeds to be added, but it works

/obj/item/projectile/proc/muzzle_effect(var/matrix/T)
	//This can happen when firing inside a wall, safety check
	if (!location)
		return

	if(silenced)
		return

	if(ispath(muzzle_type))
		var/obj/effect/projectile/M =69ew69uzzle_type(get_turf(src))

		if(istype(M))
			if(proj_color)
				var/icon/I =69ew(M.icon,69.icon_state)
				I.Blend(proj_color)
				M.icon = I
			M.set_transform(T)
			M.pixel_x = location.pixel_x
			M.pixel_y = location.pixel_y
			M.activate()

/obj/item/projectile/proc/tracer_effect(var/matrix/M)

	//This can happen when firing inside a wall, safety check
	if (!location)
		return

	if(ispath(tracer_type))
		var/obj/effect/projectile/P =69ew tracer_type(location.loc)

		if(istype(P))
			if(proj_color)
				var/icon/I =69ew(P.icon, P.icon_state)
				I.Blend(proj_color)
				P.icon = I
			P.set_transform(M)
			P.pixel_x = location.pixel_x
			P.pixel_y = location.pixel_y
			if(!hitscan)
				P.activate(step_delay)	//if69ot a hitscan projectile, remove after a single delay
			else
				P.activate()

/obj/item/projectile/proc/luminosity_effect()
    if (!location)
        return

    if(attached_effect)
        attached_effect.Move(src.loc)

    else if(luminosity_range && luminosity_power && luminosity_color)
        attached_effect =69ew /obj/effect/effect/light(src.loc, luminosity_range, luminosity_power, luminosity_color)

/obj/item/projectile/proc/impact_effect(var/matrix/M)
	//This can happen when firing inside a wall, safety check
	if (!location)
		return

	if(ispath(impact_type))
		var/obj/effect/projectile/P =69ew impact_type(location.loc)

		if(istype(P))
			if(proj_color)
				var/icon/I =69ew(P.icon, P.icon_state)
				I.Blend(proj_color)
				P.icon = I
			P.set_transform(M)
			P.pixel_x = location.pixel_x
			P.pixel_y = location.pixel_y
			P.activate(P.lifetime)

//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see69e!
	yo =69ull
	xo =69ull
	var/result = 0 //To pass the69essage back to the gun.

/obj/item/projectile/test/Bump(atom/A as69ob|obj|turf|area, forced)
	if(A == firer)
		loc = A.loc
		return //cannot shoot yourself
	if(istype(A, /obj/item/projectile))
		return
	if(isliving(A) || istype(A, /mob/living/exosuit) || istype(A, /obj/vehicle))
		result = 2 //We hit someone, return 1!
		return
	result = 1
	return

/obj/item/projectile/test/launch(atom/target)
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return 0

	original = target

	//plot the initial trajectory
	setup_trajectory(curloc, targloc)
	return Process(targloc)

/obj/item/projectile/test/Process(turf/targloc)
	while(src) //Loop on through!
		if(result)
			return (result - 1)
		if((!( targloc ) || loc == targloc))
			targloc = locate(min(max(x + xo, 1), world.maxx),69in(max(y + yo, 1), world.maxy), z) //Finding the target turf at69ap edge

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		Move(location.return_turf())

		var/mob/living/M = locate() in get_turf(src)
		if(istype(M)) //If there is someting living...
			return 1 //Return 1
		else
			M = locate() in get_step(src,targloc)
			if(istype(M))
				return 1

//Helper proc to check if you can hit them or69ot.
/proc/check_trajectory(atom/target as69ob|obj, atom/firer as69ob|obj,69ar/pass_flags=PASSTABLE|PASSGLASS|PASSGRILLE, flags=null)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/item/projectile/test/trace =69ew /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(flags))
		trace.flags = flags
	trace.pass_flags = pass_flags

	var/output = trace.launch(target) //Test it!
	69del(trace) //No69eed for it anymore
	return output //Send it back to the gun!

/proc/get_proj_icon_by_color(var/obj/item/projectile/P,69ar/color)
	var/icon/I =69ew(P.icon, P.icon_state)
	I.Blend(color)
	return I

