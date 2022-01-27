/turf
	icon = 'icons/turf/floors.dmi'
	level = BELOW_PLATIN69_LEVEL
	var/holy = 0
	var/diffused = 0 //If above zero, shields can't be on this turf. Set by floor diffusers only
	//This is69ot a boolean.69ultiple diffusers can stack and set it to 2, 3, etc

	// Initial air contents (in69oles)
	var/oxy69en = 0
	var/carbon_dioxide = 0
	var/nitro69en = 0
	var/plasma = 0

	var/list/initial_69as

	var/footstep_type

	//Properties for airti69ht tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air throu69h?

	// 69eneral properties.
	var/icon_old
	var/pathwei69ht = 1          // How69uch does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	var/movement_delay

	var/is_hole = FALSE			// If true, turf is open to69ertical transitions throu69h it.
								// This is a69ore 69eneric way of handlin69 open space turfs
	var/is_wall = FALSE 	//True for wall turfs, but also true if they contain a low wall object

/turf/New()
	..()
	for(var/atom/movable/AM as69ob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return

/turf/Initialize()
	turfs += src
	var/area/A = loc
	if (!A.ship_area)
		if (z in 69LOB.maps_data.station_levels)
			A.set_ship_area()

	. = ..()

/turf/Destroy()
	turfs -= src
	..()
	return 69DEL_HINT_IWILL69C

/turf/ex_act(severity)
	return 0

/turf/proc/is_solid_structure()
	return 1

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

/turf/attack_hand(mob/user)
	//69OL feature, clickin69 on turf can too69le doors
	var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
	if(AL)
		AL.attack_hand(user)
		return TRUE
	var/obj/machinery/door/holy/HD = locate(/obj/machinery/door/holy) in src.contents
	if(HD)
		HD.attack_hand(user)
		return TRUE
	var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
	if(FD)
		FD.attack_hand(user)
		return TRUE
	if(!(user.canmove) || user.restrained() || !(user.pullin69))
		return FALSE
	if(user.pullin69.anchored || !isturf(user.pullin69.loc))
		return FALSE
	if(user.pullin69.loc != user.loc && 69et_dist(user, user.pullin69) > 1)
		return FALSE
	if(ismob(user.pullin69))
		var/mob/M = user.pullin69
		var/atom/movable/t =69.pullin69
		M.stop_pullin69()
		step(user.pullin69, 69et_dir(user.pullin69.loc, src))
		M.start_pullin69(t)
	else
		step(user.pullin69, 69et_dir(user.pullin69.loc, src))
	return TRUE

/turf/Enter(atom/movable/mover as69ob|obj, atom/for69et as69ob|obj|turf|area)
	if(movement_disabled && usr.ckey !=69ovement_disabled_exception)
		to_chat(usr, SPAN_WARNIN69("Movement is admin-disabled.")) //This is to identify la69 problems
		return

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return 1

	//First, check objects to block exit that are69ot on the border
	for(var/obj/obstacle in69over.loc)
		if(!(obstacle.fla69s & ON_BORDER) && (mover != obstacle) && (for69et != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in69over.loc)
		if((border_obstacle.fla69s & ON_BORDER) && (mover != border_obstacle) && (for69et != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.fla69s & ON_BORDER)
			if(!border_obstacle.CanPass(mover,69over.loc, 1, 0) && (for69et != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are69ot on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.fla69s & ON_BORDER))
			if(!obstacle.CanPass(mover,69over.loc, 1, 0) && (for69et != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothin69 found to block so return success!

var/const/enterloopsanity = 100
/turf/Entered(atom/atom as69ob|obj)

	if(movement_disabled)
		to_chat(usr, SPAN_WARNIN69("Movement is admin-disabled.")) //This is to identify la69 problems
		return
	..()

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	if(ismob(A))
		var/mob/M = A

		M.update_floatin69()
		if(M.check_69ravity() ||69.incorporeal_move)
			M.inertia_dir = 0
		else
			if(!M.allow_spacemove())
				inertial_drift(M)
			else
				if(M.allow_spacemove() == TRUE)
					M.update_floatin69(FALSE)
					M.inertia_dir = 0
				else if(M.check_dense_object())
					M.inertia_dir = 0

		if(islivin69(M))
			var/mob/livin69/L =69
			L.handle_footstep(src)

	var/objects = 0
	if(A && (A.fla69s & PROXMOVE))
		for(var/atom/movable/thin69 in ran69e(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A)
					A.HasProximity(thin69, 1)
					if ((thin69 && A) && (thin69.fla69s & PROXMOVE))
						thin69.HasProximity(A, 1)
	return

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature,69olume)
	return

/turf/proc/is_platin69()
	return FALSE

/turf/proc/inertial_drift(atom/movable/A as69ob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.allow_spacemove() == TRUE)
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step_69lide(M,69.inertia_dir, DELAY269LIDESIZE(5))
					return
				M.inertia_dir =69.last_move
				step(M,69.inertia_dir, DELAY269LIDESIZE(5))
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_floorin69() && !is_platin69())
		SEND_SI69NAL(O, COMSI69_TURF_LEVELUPDATE, !is_platin69())

/turf/proc/AdjacentTurfs()
	var/L6969 =69ew()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L6969 =69ew()
	for(var/turf/simulated/T in AdjacentTurfs())
		if(T.x == src.x || T.y == src.y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t)
	if(69et_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathwei69ht+t.pathwei69ht)/2
		return cost
	else
		return 69et_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L6969 =69ew()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects(unincludehumans)
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.fla69s & ON_BORDER) && (unincludehumans && !ishuman(A)))
			return 1
	return 0

/turf/69et_footstep_sound(var/mobtype)

	var/sound

	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in src
	if(catwalk)
		sound = footstep_sound("catwalk")
	else
		sound =  footstep_sound("floor")

	return sound

/turf/simulated/floor/69et_footstep_sound(var/mobtype)

	var/sound

	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk) in src
	sound =  footstep_sound("floor")
	if(catwalk)
		sound = footstep_sound("catwalk")
	else if(floorin69)
		sound = footstep_sound(floorin69.footstep_sound)
	else if(initial_floorin69)
		var/decl/floorin69/floor = decls_repository.69et_decl(initial_floorin69)
		sound = footstep_sound(floor.footstep_sound)

	return sound

/turf/AllowDrop()
	return TRUE
