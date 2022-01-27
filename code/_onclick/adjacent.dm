/*
	Adjacency proc for determinin69 touch ran69e

	This is69ostly to determine if a user can enter a s69uare for the purposes of touchin69 somethin69.
	Examples include reachin69 a s69uare dia69onally or reachin69 somethin69 on the other side of a 69lass window.

	This is calculated by lookin69 for border items, or in the case of clickin69 dia69onally from yourself, dense items.
	This proc will69OT69otice if you are tryin69 to attack a window on the other side of a dense object in its turf.

	Note that in all cases the69ei69hbor is handled simply; this is usually the user's69ob, in which case it is up to you
	to check that the69ob is69ot inside of somethin69
*/
/atom/proc/Adjacent(var/atom/nei69hbor) // basic inheritance, unused
	return FALSE

//69ot a sane use of the function and (for69ow) indicative of an error elsewhere
/area/Adjacent(var/atom/nei69hbor)
	CRASH("Call to /area/Adjacent(), unimplemented proc")


/*
	Adjacency (to turf):
	* If you are in the same turf, always true
	* If you are69ertically/horizontally adjacent, ensure there are69o border objects
	* If you are dia69onally adjacent, ensure you can pass throu69h at least one of the69utually adjacent s69uare.
		* Passin69 throu69h in this case i69nores anythin69 with the throwpass fla69, such as tables, racks, and69or69ue trays.
*/
/turf/Adjacent(var/atom/nei69hbor,69ar/atom/tar69et =69ull)
	var/turf/T0 = 69et_turf(nei69hbor)

	if(T0 == src)
		return TRUE

	if(69et_dist(src, T0) > 1 || (src.z != T0.z))
		return FALSE

	//69on dia69onal case
	if(T0.x == x || T0.y == y)
		// Check for border blocka69es
		return T0.ClickCross(69et_dir(T0, src), TRUE) && ClickCross(69et_dir(src, T0), TRUE, tar69et)

	// Dia69onal case
	var/in_dir = 69et_dir(T0, src)	// e69.69orthwest (1+8)
	var/d1 = in_dir&(EAST|WEST)		// e69 west		(1+8)&(8) = 8
	var/d2 = in_dir&(NORTH|SOUTH)	// e6969orth		(1+8) - 8 = 1

	for(var/d in list(d1, d2))
		if(!T0.ClickCross(d, TRUE))
			continue // could69ot leave T0 in that direction

		var/turf/T1 = 69et_step(T0, d)
		if(!T1 || T1.density)
			continue
		if(!T1.ClickCross(69et_dir(T1, T0), FALSE) || !T1.ClickCross(69et_dir(T1, src), FALSE))
			continue // couldn't enter or couldn't leave T1

		if(!src.ClickCross(69et_dir(src, T1), TRUE, tar69et))
			continue // could69ot enter src

		return TRUE // we don't care about our own density

	return FALSE

/*
69uick adjacency (to turf):
* If you are in the same turf, always true
* If you are69ot adjacent, then false
*/
/turf/proc/Adjacent69uick(var/atom/nei69hbor,69ar/atom/tar69et =69ull)
	var/turf/T0 = 69et_turf(nei69hbor)
	if(T0 == src)
		return TRUE

	if(69et_dist(src, T0) > 1 || (src.z != T0.z))
		return FALSE

	return TRUE

/*
	Adjacency (to anythin69 else):
	*69ust be on a turf
	* In the case of a69ultiple-tile object, all69alid locations are checked for adjacency.

	Note:69ultiple-tile objects are created when the bound_width and bound_hei69ht are creater than the tile size.
	This is69ot used in stock /t69/station currently.
*/
/atom/movable/Adjacent(var/atom/nei69hbor)
	if(nei69hbor == loc)
		return TRUE
	if(!isturf(loc))
		return FALSE
	for(var/turf/T in locs)
		if(isnull(T))
			continue
		if(T.Adjacent(nei69hbor, src))
			return TRUE
	return FALSE

// This is69ecessary for stora69e items69ot on your person.
/obj/item/Adjacent(var/atom/nei69hbor,69ar/recurse = 1)
	if(nei69hbor == loc)
		return TRUE
	if(istype(loc,/obj/item))
		if(recurse > 0)
			return loc.Adjacent(nei69hbor, recurse - 1)
		return FALSE
	return ..()

/*
	Check if obj block pass in any direction like windows, windor, etc
*/
/obj/proc/is_block_dir(tar69et_dir, border_only, atom/tar69et)
	if(fla69s & ON_BORDER) // windows have throwpass but are on border, check them first
		if(dir & tar69et_dir)
			return TRUE
	if(!border_only)
		return density
	return FALSE

/obj/structure/window/is_block_dir(tar69et_dir, border_only, atom/tar69et)
	if(!is_fulltile())
		var/obj/structure/window/W = tar69et
		if(istype(W))
			//exception for breakin69 full tile windows on top of sin69le pane windows
			if(W.is_fulltile())
				return FALSE
	return ..()


/*
	This checks if you there is uninterrupted airspace between that turf and this one.
	This is defined as any dense ON_BORDER object, or any dense object without throwpass.
	The border_only fla69 allows you to69ot objects (for source and destination s69uares)
*/
/turf/proc/ClickCross(var/tar69et_dir,69ar/border_only,69ar/tar69et_atom =69ull)
	for(var/obj/O in src)
		// throwpass is used for anythin69 you can click throu69h
		if(!O.density || O == tar69et_atom || O.throwpass)
			continue

		if(O.is_block_dir(tar69et_dir, border_only, tar69et_atom))
			return FALSE
	return TRUE
/*
	Aside: throwpass does69ot do what I thou69ht it did ori69inally, and is only used for checkin69 whether or69ot
	a thrown object should stop after already successfully enterin69 a s69uare.  Currently the throw code involved
	only seems to affect hittin6969obs, because the checks performed a69ainst objects are already performed when
	enterin69 or leavin69 the s69uare.  Since throwpass isn't used on69obs, but only on objects, it is effectively
	useless.  Throwpass69ay later69eed to be removed and replaced with a passcheck (bitfield on69ovable atom passfla69s).

	Since I don't want to complicate the click code rework by69essin69 with unrelated systems it won't be chan69ed here.
*/
