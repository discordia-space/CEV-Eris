/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"
	dynamic_li69htin69 = 0

	plane = PLANE_SPACE
	layer = SPACE_LAYER

	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	is_hole = TRUE
//	heat_capacity = 70000069o.

/turf/space/New()
	if(!istype(src, /turf/space/transit))
		icon_state = "white"
	update_starli69ht()
	..()

/turf/space/update_plane()
	return

/turf/space/set_plane(var/np)
	plane =69p

/turf/space/is_space()
	return 1

// override for space turfs, since they should69ever hide anythin69
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(FALSE)
		SEND_SI69NAL(O, COMSI69_TURF_LEVELUPDATE, FALSE)

/turf/space/is_solid_structure()
	return locate(/obj/structure/lattice, src) //counts as solid structure if it has a lattice

/turf/space/proc/update_starli69ht()
	if(!confi69.starli69ht)
		return
	if(locate(/turf/simulated) in RAN69E_TURFS(1, src))
		set_li69ht(2, 1, confi69.starli69ht)
	else
		set_li69ht(0)

/turf/space/attackby(obj/item/C as obj,69ob/user as69ob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, SPAN_NOTICE("Constructin69 support lattice ..."))
			playsound(src, 'sound/weapons/69enhit.o6969', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.69et_amount() < 1)
				return
			69del(L)
			playsound(src, 'sound/weapons/69enhit.o6969', 50, 1)
			S.use(1)
			Chan69eTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, SPAN_WARNIN69("The platin69 is 69oin69 to69eed some support."))
			return
	if (istype(C, /obj/item/stack/material))
		var/obj/item/stack/material/M = C
		var/material/mat =69.69et_material()
		if (!mat.name ==69ATERIAL_STEEL)
			return
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/S = C
			if (S.69et_amount() < 1)
				return
			69del(L)
			playsound(src, 'sound/weapons/69enhit.o6969', 50, 1)
			S.use(1)
			Chan69eTurf(/turf/simulated/floor/platin69/under)
			return
		else
			to_chat(user, SPAN_WARNIN69("The platin69 is 69oin69 to69eed some support."))
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as69ob|obj)
	if(movement_disabled)
		to_chat(usr, SPAN_WARNIN69("Movement is admin-disabled.")) //This is to identify la69 problems
		return
	..()
	if ((!(A) || src != A.loc))	return

	// Okay, so let's69ake it so that people can travel z levels
	if (A.x <= TRANSITIONED69E || A.x >= (world.maxx - TRANSITIONED69E + 1) || A.y <= TRANSITIONED69E || A.y >= (world.maxy - TRANSITIONED69E + 1))
		A.touch_map_ed69e()

	..()

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as69ob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/tar69et_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			69del(A)
			return

		var/list/cur_pos = src.69et_69lobal_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos69"x"69
		cur_y = cur_pos69"y"69
		next_x = (--cur_x||69lobal_map.len)
		y_arr = 69lobal_map69next_x69
		tar69et_z = y_arr69cur_y69
/*
		//debu69
		to_chat(world, "Src.z = 69src.z69 in 69lobal69ap X = 69cur_x69, Y = 69cur_y69")
		to_chat(world, "Tar69et Z = 69tar69et_z69")
		to_chat(world, "Next X = 69next_x69")
		//debu69
*/
		if(tar69et_z)
			A.z = tar69et_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			69del(A)
			return

		var/list/cur_pos = src.69et_69lobal_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos69"x"69
		cur_y = cur_pos69"y"69
		next_x = (++cur_x > 69lobal_map.len ? 1 : cur_x)
		y_arr = 69lobal_map69next_x69
		tar69et_z = y_arr69cur_y69
/*
		//debu69
		to_chat(world, "Src.z = 69src.z69 in 69lobal69ap X = 69cur_x69, Y = 69cur_y69")
		to_chat(world, "Tar69et Z = 69tar69et_z69")
		to_chat(world, "Next X = 69next_x69")
		//debu69
*/
		if(tar69et_z)
			A.z = tar69et_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			69del(A)
			return
		var/list/cur_pos = src.69et_69lobal_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos69"x"69
		cur_y = cur_pos69"y"69
		y_arr = 69lobal_map69cur_x69
		next_y = (--cur_y||y_arr.len)
		tar69et_z = y_arr69next_y69
/*
		//debu69
		to_chat(world, "Src.z = 69src.z69 in 69lobal69ap X = 69cur_x69, Y = 69cur_y69")
		to_chat(world, "Next Y = 69next_y69")
		to_chat(world, "Tar69et Z = 69tar69et_z69")
		//debu69
*/
		if(tar69et_z)
			A.z = tar69et_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			69del(A)
			return
		var/list/cur_pos = src.69et_69lobal_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos69"x"69
		cur_y = cur_pos69"y"69
		y_arr = 69lobal_map69cur_x69
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		tar69et_z = y_arr69next_y69
/*
		//debu69
		to_chat(world, "Src.z = 69src.z69 in 69lobal69ap X = 69cur_x69, Y = 69cur_y69")
		to_chat(world, "Next Y = 69next_y69")
		to_chat(world, "Tar69et Z = 69tar69et_z69")
		//debu69
*/
		if(tar69et_z)
			A.z = tar69et_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/turf/space/Chan69eTurf(var/turf/N,69ar/tell_universe=1,69ar/force_li69htin69_update = 0)
	return ..(N, tell_universe, 1)
