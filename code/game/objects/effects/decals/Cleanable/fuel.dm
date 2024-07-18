/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or plasma being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = TURF_LAYER+0.2
	anchored = TRUE
	var/amount = 1

/obj/effect/decal/cleanable/liquid_fuel/New(turf/newLoc,_amount=1,nologs=0)
	if(usr && usr.client && !nologs)
		message_admins("Liquid fuel has spilled in [newLoc.loc.name] ([newLoc.x],[newLoc.y],[newLoc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[newLoc.x];Y=[newLoc.y];Z=[newLoc.z]'>JMP</a>)")
		log_game("Liquid fuel has spilled in [newLoc.loc.name] ([newLoc.x],[newLoc.y],[newLoc.z])")
	amount = _amount

	var/has_spread = 0
	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in newLoc)
		if(other != src)
			other.amount += src.amount
			other.Spread()
			has_spread = 1
			break

	. = ..()
	if(!has_spread)
		Spread()
	else
		qdel(src)

/obj/effect/decal/cleanable/liquid_fuel/proc/Spread(exclude=list())
	//Allows liquid fuels to sometimes flow into other tiles.
	if(amount < 15) return //lets suppose welder fuel is fairly thick and sticky. For something like water, 5 or less would be more appropriate.
	var/turf/S = loc
	if(!istype(S)) return
	for(var/d in cardinal)
		var/turf/target = get_step(src,d)
		var/turf/origin = get_turf(src)
		if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
			var/obj/effect/decal/cleanable/liquid_fuel/other_fuel = locate() in target
			if(other_fuel)
				other_fuel.amount += amount*0.25
				if(!(other_fuel in exclude))
					exclude += src
					other_fuel.Spread(exclude)
			else
				new/obj/effect/decal/cleanable/liquid_fuel(target, amount*0.25,1)
			amount *= 0.75


/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = FALSE
	var/turf/origin

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/New(newLoc, _amount = 1, d = 0, var/turf/_origin)
	origin = _origin
	set_dir(d) //Setting this direction means you won't get torched by your own flamethrower.
	. = ..()

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/Spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	var/turf/S = loc
	if(amount < 0.1)
		S.hotspot_expose((T20C*2) + 380,500)
		return

	if(!istype(S)) return

	for(var/d in list(turn(dir,90),turn(dir,-90), dir))
		var/turf/O = get_step(S,d)
		if (O == origin)
			continue //No torching the user
		if(!(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in O))

			if(O.CanPass(null, S, 0, 0) && S.CanPass(null, O, 0, 0))
				new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(O,amount*0.25,d)
		O.hotspot_expose((T20C*2) + 380,500) //Light flamethrower fuel on fire immediately.

	amount *= 0.25

