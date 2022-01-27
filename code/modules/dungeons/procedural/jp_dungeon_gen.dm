/*
	This datum is the heart of the generator. It provides the interface - you create a
	jp_DungeonGenerator object, twiddle some parameters, call a procedure, and then grab
	the results.
*/
/*
	Below this comment is a pinnacle of sorcery unearthed from ancient era of byond.
	Proceed with caution, for you69ay not comprehed whatever the fuck this is.
	I sure don't. Original code by http://www.byond.com/members/Jp
	Adapted for Eris and69ore69odern byond69ersions by69e.
	Quite a bit was69odified/removed/re-done.
	Pathing was69ade strict/all objects here are subtype of obj/procedural.

- Nestor/drexample (full permission to bug69e if you have questions or code suggestions)
*/
/obj/procedural/jp_DungeonGenerator

	var/turf/corner1 //One corner of the rectangle the algorithm is allowed to69odify
	var/turf/corner2 //The other corner of the rectangle the algorithm is allowed to69odify

	var/list/allowedRooms //The list of rooms the algorithm69ay place

	var/doAccurateRoomPlacementCheck = FALSE //Whether the algorithm should just use AABB collision detection between rooms, or use the slower69ersion with no false positives
	var/usePreexistingRegions = FALSE //Whether the algorithm should find any already extant open regions in the area it is working on, and incorporate them into the dungeon being generated

	var/floortype //The type used for open floors placed in corridors
	var/list/walltype //Either a single type, or a list of types that are considered 'walls' for the purpose of this algorithm

	var/numRooms //The upper limit of the number of 'rooms' placed in the dungeon. NOT GUARANTEED TO BE REACHED
	var/numExtraPaths //The upper limit on the number of extra paths placed beyond those required to ensure connectivity. NOT GUARANTEED TO BE REACHED
	var/maximumIterations = 120 //The number of do-nothing iterations before the generator gives up with an error.
	var/roomMinSize //The69inimum 'size' passed to rooms.
	var/roomMaxSize //The69aximum 'size' passed to rooms.
	var/maxPathLength //The absolute69aximum length paths are allowed to be.
	var/minPathLength //The absolute69inimum length paths are allowed to be.
	var/minLongPathLength //The absolute69inimum length of a long path
	var/pathEndChance //The chance of terminating a path when it's found a69alid endpoint, as a percentage
	var/longPathChance //The chance that any given path will be designated 'long'
	var/pathWidth = 2 //The default width of paths connecting the rooms
	var/lightSpawnChance = 0 //Chance to spawn a light during path generation

	var/list/border_turfs //Internal list. No touching, unless you really know what you're doing.

	var/list/examined //Internal list, used for pre-existing region stuff

	var/list/path_turfs = list()

	var/out_numRooms //The number of rooms the generator69anaged to place
	var/out_numPaths //The total number of paths the generator69anaged to place. This includes those required for reachability as well as 'extra' paths, as well as all long paths.
	var/out_numLongPaths //The number of long paths the generator69anaged to place. This includes those required for reachability, as well as 'extra' paths.
	var/out_error //0 if no error, positive69alue if a fatal error occured, negative69alue if something potentially bad but not fatal happened
	var/out_time //How long it took, in69s.69ay be negative if the generator runs 'over'69idnight that is, starts in one day, ends in another.
	var/out_seed //What seed was used to power the RNG for the dungeon.
	var/obj/procedural/jp_DungeonRegion/out_region //The jp_DungeonRegion object that we were left with after all the rooms were connected

	var/list/obj/procedural/jp_DungeonRoom/out_rooms //A list containing all the jp_DungeonRoom datums placed on the69ap


	var/const/ERROR_NO_ROOMS = 1 //The allowed-rooms list is empty or bad.
	var/const/ERROR_BAD_AREA = 2 //The area that the generator is allowed to work on was specified badly
	var/const/ERROR_NO_WALLTYPE = 3 //The type used for walls wasn't specified
	var/const/ERROR_NO_FLOORTYPE = 4 //The type used for floors wasn't specified
	var/const/ERROR_NUMROOMS_BAD = 5 //The number of rooms to draw was a bad number
	var/const/ERROR_NUMEXTRAPATHS_BAD = 6 //The number of extra paths to draw was a bad number
	var/const/ERROR_ROOM_SIZE_BAD = 7 //The specified room sizes (either69ax or69in) include a bad number
	var/const/ERROR_PATH_LENGTH_BAD = 8 //The specified path lengths (either69ax or69in) include a bad number
	var/const/ERROR_PATHENDCHANCE_BAD = 9 //The pathend chance is a bad number
	var/const/ERROR_LONGPATHCHANCE_BAD = 10 //The chance of getting a long path was a bad number

	var/const/ERROR_MAX_ITERATIONS_ROOMS = -1 //Parameters were fine, but69aximum iterations was reached while placing rooms. This is not necessarily a fatal error condition - it just69eans not all the rooms you specified69ay have been placed. This error69ay be69asked by errors further along in the process.
	var/const/ERROR_MAX_ITERATIONS_CONNECTIVITY = 11 //Parameters were fine, but69aximum iterations was reached while ensuring connectivity. If you get this error, there are /no/ guarantees about reachability - indeed, you69ay end up with a dungeon where no room is reachable from any other room.
	var/const/ERROR_MAX_ITERATIONS_EXTRAPATHS = -2 //Parameters were fine, but69aximum iterations was reached while placing extra paths after connectivity was ensured. The dungeon should be fine, all the rooms should be reachable, but it69ay be less interesting. Or you69ay just have asked to place too69any extra paths.

	var/const/ERROR_NO_SUBMAPS = 12 //Everything was fine, but you forgot to include submaps for rooms that try to load them.


	/***********************************************************************************
	 *	Internal procedures.69ight be useful if you're writing a /jp_DungeonRoom datum.*
	 *	Probably not useful if you just want to69ake a simple dungeon				   *
	 ***********************************************************************************/

/obj/procedural/jp_DungeonGenerator/proc/updateWallConnections()
	for(var/turf/simulated/wall/W in border_turfs)
		W.update_connections(1)

/*
	Returns a list of turfs adjacent to the turf 't'. The definition of 'adjacent'
	may depend on69arious properties set - at the69oment, it is limited to the turfs
	in the four cardinal directions.
*/
/obj/procedural/jp_DungeonGenerator/proc/getAdjacent(turf/t)
	//Doesn't just go list(get_step(blah blah), get_step(blah blah) etc. because that could return null if on the border of the69ap
	.=list()
	var/k = get_step(t,NORTH)
	if(k).+=k
	k = get_step(t,SOUTH)
	if(k).+=k
	k = get_step(t,EAST)
	if(k).+=k
	k = get_step(t,WEST)
	if(k).+=k


/*

	Same as above, but skips X tiles from original one

*/

/obj/procedural/jp_DungeonGenerator/proc/getAdjacentFurther(turf/t,69ar/num = 1)
	//Doesn't just go list(get_step(blah blah), get_step(blah blah) etc. because that could return null if on the border of the69ap
	.=list()
	var/counter = num
	var/k
	k = get_step(t,NORTH)
	while(counter > 0)
		if(k)
			k = get_step(k,NORTH)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k
	counter = num
	k = get_step(t,SOUTH)
	while(counter > 0)
		if(k)
			k = get_step(k,SOUTH)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k
	counter = num
	k = get_step(t,EAST)
	while(counter > 0)
		if(k)
			k = get_step(k,EAST)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k
	counter = num
	k = get_step(t,WEST)
	while(counter > 0)
		if(k)
			k = get_step(k,WEST)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k


/*

	Spawns a lightbulb, adjacent to a wall

*/


/obj/procedural/jp_DungeonGenerator/proc/AddLight(t)
	new /obj/machinery/light/small/autoattach(t)

/*

	Sets chance a light source spawns in the paths generated (in percent), per tile

*/

/obj/procedural/jp_DungeonGenerator/proc/setLightChance(r)
	lightSpawnChance = r


/*

	Post-initializes all submaps

*/

/obj/procedural/jp_DungeonGenerator/proc/initializeSubmaps()
	var/datum/map_template/init_template = new /datum/map_template/deepmaint_template/room
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	bounds69MAP_MINX69 = 1
	bounds69MAP_MINY69 = world.maxy
	bounds69MAP_MINZ69 = (get_turf(loc)).z
	bounds69MAP_MAXX69 = world.maxx
	bounds69MAP_MAXY69 = 1
	bounds69MAP_MAXZ69 = (get_turf(loc)).z
	init_template.initTemplateBounds(bounds)


/*
	Returns 'true' if the turf 't' is a wall. False otherwise.
*/
/*
/obj/procedural/jp_DungeonGenerator/proc/iswall(turf/t)
//	if(islist(walltype)) return t.type in walltype
	return t.is_wall
*/
/*
	Returns 'true' if l is a list, false otherwise
*/

/***********************************************************************************
 *	External procedures, intended to be used by user code.						   *
 ***********************************************************************************/

/*
	Returns a string representation of the error you pass into it.
	So you'd call g.errString(g.out_error)
*/
/obj/procedural/jp_DungeonGenerator/proc/errString(e)
	switch(e)
		if(0) return "No error"
		if(ERROR_NO_ROOMS) return "The allowedRooms list was either empty, or an illegal69alue"
		if(ERROR_BAD_AREA) return "The area that the generator is allowed to work on was either empty, or crossed a z-level"
		if(ERROR_NO_WALLTYPE) return "The types that are walls were either not specified, or weren't a typepath or list of typepaths"
		if(ERROR_NO_FLOORTYPE) return "The type used for floors either wasn't specified, or wasn't a typepath"
		if(ERROR_NUMROOMS_BAD) return "The number of rooms to place was either negative, or not an integer"
		if(ERROR_NUMEXTRAPATHS_BAD) return "The number of extra paths to place was either negative, or not an integer"
		if(ERROR_ROOM_SIZE_BAD) return "One of the69inimum and69aximum room sizes was negative, or not an integer. Alternatively, the69inimum room size was larger than the69aximum room size"
		if(ERROR_PATH_LENGTH_BAD) return "One of the path-length parameters was negative, or not an integer. Alternatively, either69inimum path length or69inimum long path length was larger than69aximum path length"
		if(ERROR_PATHENDCHANCE_BAD) return "The pathend chance was either less than 0 or greater than 100"
		if(ERROR_LONGPATHCHANCE_BAD) return "The long-path chance was either less than 0, or greater than 100"
		if(ERROR_MAX_ITERATIONS_ROOMS) return "Maximum iterations was reached while placing rooms on the69ap. The number of rooms you specified69ay not have been placed. The dungeon should still be usable"
		if(ERROR_MAX_ITERATIONS_CONNECTIVITY) return "Maximum iterations was reached while ensuring connectivity. No guarantees can be69ade about reachability. This dungeon is likely unusable"
		if(ERROR_MAX_ITERATIONS_EXTRAPATHS) return "Maximum iterations was reached while placing extra paths. The number of extra paths you specified69ay not have been placed. The dungeon should still be usable"
		if(ERROR_NO_SUBMAPS) return "No submaps were provided for room types that require to load them."

/*
	Sets the number of rooms that will be placed in the dungeon to 'r'.
	Positive integers only
*/
/obj/procedural/jp_DungeonGenerator/proc/setNumRooms(r)
	numRooms = r

/*
	Sets the width of paths generated.
	Positive and negative integers work.
	(negatives invert the way square that sets width of the path is calculated)
*/

/obj/procedural/jp_DungeonGenerator/proc/setPathWidth(r)
	pathWidth = r

/*
	Returns the number of rooms that will be placed in the dungeon
*/
/obj/procedural/jp_DungeonGenerator/proc/getNumRooms()
	return numRooms

/*
	Sets the number of 'extra' paths that will be placed in the dungeon - 'extra'
	in that they aren't required to ensure reachability
*/
/obj/procedural/jp_DungeonGenerator/proc/setExtraPaths(p)
	numExtraPaths = p

	/*
		Returns the number of extra paths that will be placed in the dungeon
	*/
/obj/procedural/jp_DungeonGenerator/proc/getExtraPaths()
	return numExtraPaths

	/*
		Sets the69aximum number of do-nothing loops that can occur in a row before the
		generator gives up and does something else.
	*/
/obj/procedural/jp_DungeonGenerator/proc/setMaximumIterations(i)
	maximumIterations = i

	/*
		Gets the69aximum number of do-nothing loops that can occur in a row
	*/
/obj/procedural/jp_DungeonGenerator/proc/getMaximumIterations()
	return69aximumIterations

	/*
		Sets and gets the69aximum and69inimum sizes used for rooms placed on the dungeon.
		m69ust be a positive integer.
	*/
/obj/procedural/jp_DungeonGenerator/proc/setRoomMinSize(m, typepath="")
	roomMinSize =69
/obj/procedural/jp_DungeonGenerator/proc/getRoomMinSize(typepath="")
	return roomMinSize
/obj/procedural/jp_DungeonGenerator/proc/setRoomMaxSize(m, typepath="")
	roomMaxSize =69
/obj/procedural/jp_DungeonGenerator/proc/getRoomMaxSize(typepath="")
	return roomMaxSize


/*
	Sets and gets the69aximum and69inimum lengths used for paths drawn between rooms
	in the dungeon, including 'long' paths (Which are required to be of a certain length)
	m69ust be a positive integer.
*/
/obj/procedural/jp_DungeonGenerator/proc/setMaxPathLength(m)
	maxPathLength =69
/obj/procedural/jp_DungeonGenerator/proc/setMinPathLength(m)
	minPathLength =69
/obj/procedural/jp_DungeonGenerator/proc/setMinLongPathLength(m)
	minLongPathLength =69
/obj/procedural/jp_DungeonGenerator/proc/getMaxPathLength()
	return69axPathLength
/obj/procedural/jp_DungeonGenerator/proc/getMinPathLength()
	return69inPathLength
/obj/procedural/jp_DungeonGenerator/proc/getMinLongPathLength()
	return69inLongPathLength

/*
	Sets and gets the chance of a path ending when it finds a suitable end turf.
	c69ust be a number between 0 and 100, inclusive
*/
/obj/procedural/jp_DungeonGenerator/proc/setPathEndChance(c)
	pathEndChance = c
/obj/procedural/jp_DungeonGenerator/proc/getPathEndChance()
	return pathEndChance

/*
	Sets and gets the chance of a path being designated a 'long' path, which has
	a different69inimum length to a regular path. c69ust be a number between 0
	and 100, inclusive.
*/
/obj/procedural/jp_DungeonGenerator/proc/setLongPathChance(c)
	longPathChance = c
/obj/procedural/jp_DungeonGenerator/proc/getLongPathChance()
	return longPathChance

/*
	Sets the area that the generator is allowed to touch. This is required to be a
	rectangle. The parameters 'c1' and 'c2' specify the corners of the rectangle. They
	can be any two opposite corners. The generator does /not/ work over z-levels.
*/
/obj/procedural/jp_DungeonGenerator/proc/setArea(turf/c1, turf/c2)
	corner1 = c1
	corner2 = c2

/*
	Returns a list containing two of the corners of the area the generator is allowed to touch.
	Returns a list of nulls if the area isn't specified
*/
/obj/procedural/jp_DungeonGenerator/proc/getArea()
	return list(corner1, corner2)

/*
	Returns the smallest x-value that the generator is allowed to touch.
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMinX()
	if(!corner1||!corner2) return null
	return69in(corner1.x, corner2.x)

/*
	Returns the largest x-value that the generator is allowed to touch
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMaxX()
	if(!corner1||!corner2) return null
	return69ax(corner1.x, corner2.x)

/*
	Returns the smallest y-value that the generator is allowed to touch.
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMinY()
	if(!corner1||!corner2) return null
	return69in(corner1.y, corner2.y)

/*
	Returns the largest y-value that the generator is allowed to touch
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMaxY()
	if(!corner1||!corner2) return null
	return69ax(corner1.y, corner2.y)

/*
	Returns the Z-level that the generator operates on
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getZ()
	if(!corner1||!corner2) return null
	return corner1.z

/*
	Sets the list of jp_DungeonRooms allowed in this dungeon to 'l'.
	'l' should be a list of types.
*/
/obj/procedural/jp_DungeonGenerator/proc/setAllowedRooms(list/l)
	allowedRooms = list()
	for(var/k in l)	allowedRooms69"69k69"69 = new /obj/procedural/jp_DungeonRoomEntry/(k)

/*
	Adds the type 'r' to the list of allowed jp_DungeonRooms. Will create
	the list if it doesn't exist yet.
*/
/obj/procedural/jp_DungeonGenerator/proc/addAllowedRoom(r,69axsize=-1,69insize=-1, required=-1,69axnum=-1)
	if(!allowedRooms) allowedRooms = list()
	allowedRooms69"69r69"69 = new /obj/procedural/jp_DungeonRoomEntry/(r,69axsize,69insize, required,69axnum)

/*
	Removes the type 'r' from the list of allowed jp_DungeonRooms. Will create
	the list if it doesn't exist yet.
*/
/obj/procedural/jp_DungeonGenerator/proc/removeAllowedRoom(r)
	allowedRooms69"69r69"69 = null
	if(!allowedRooms || !allowedRooms.len) allowedRooms = null

/*
	Returns the list of allowed jp_DungeonRooms. This69ay be null, if the list is empty
*/
/obj/procedural/jp_DungeonGenerator/proc/getAllowedRooms()
	if(!allowedRooms) return null
	var/list/l = list()
	for(var/k in allowedRooms) l+=text2path(k)
	return l

/*
	Sets the accurate room placement check to 'b'.
*/
/obj/procedural/jp_DungeonGenerator/proc/setDoAccurateRoomPlacementCheck(b)
	doAccurateRoomPlacementCheck = b

/*
	Gets the current69alue of the accurate room placement check
*/
/obj/procedural/jp_DungeonGenerator/proc/getDoAccurateRoomPlacementCheck()
	return doAccurateRoomPlacementCheck


/*
	Sets the use-preexisting-regions check to 'b'
*/
/obj/procedural/jp_DungeonGenerator/proc/setUsePreexistingRegions(b)
	usePreexistingRegions = b

/*
	Gets the current69alue of the use-preexisting-regions check
*/
/obj/procedural/jp_DungeonGenerator/proc/getUsePreexistingRegions()
	return usePreexistingRegions

/*
	Sets the type used for floors - both in corridors, and in some rooms - to 'f'
*/
/obj/procedural/jp_DungeonGenerator/proc/setFloorType(f)
	floortype = f

/*
	Gets the type used for floors.
*/
/obj/procedural/jp_DungeonGenerator/proc/getFloorType()
	return floortype

/*
	Sets the type/s detected as 'wall' to either the typepath 'w' or
	the list of typepaths 'w'
*/
/obj/procedural/jp_DungeonGenerator/proc/setWallType(w)
	walltype = w

/*
	Adds the typepath 'w' to the list of types considered walls.
*/
/obj/procedural/jp_DungeonGenerator/proc/addWallType(w)
	if(!walltype) walltype = list()
	if(!islist(walltype)) walltype = list(walltype)
	walltype+=w

/*
	Removes 'w' from the list of types considered walls
*/
/obj/procedural/jp_DungeonGenerator/proc/removeWallType(w)
	if(!islist(walltype))
		if(walltype==w) walltype = null
		return
	walltype-=w

/*
	Gets the types considered walls. This69ay be null, a typepath, or a list of typepaths
*/
/obj/procedural/jp_DungeonGenerator/proc/getWallType()
	return walltype


/obj/procedural/jp_DungeonGenerator/proc/getNeighboringRegions(var/list/R)
	var/list/regs = list()
	if(R.len == 1)
		regs += R69169
		regs += R69169
		return regs
	var/obj/procedural/jp_DungeonRegion/r1 = pick(R)
	regs += r1
	var/obj/procedural/jp_DungeonRegion/r2 = null
	var/r_distance = 127 // At this time, get_dist() never returns a69alue greater than 127 - thank you, byond,69ery cool.
	for(var/obj/procedural/jp_DungeonRegion/region in R)
		if(r1 == region)
			continue
		var/dist = get_dist(r1.center, region.center)
		if(dist < r_distance)
			r2 = region
			r_distance = dist

	if(r2)
		regs += r2
		return regs

	else
		regs += pick(R)
		return regs




/*
	Actually goes out on a limb and generates the dungeon. This procedure runs in the
	background, because it's69ery slow. The69arious out_69ariables will be updated after
	the generator has finished running. I suggest spawn()ing off the call to the generator.

	After this procedure finishes executing, you should have a beautiful shiny dungeon,
	with all rooms reachable from all other rooms. If you don't, first check the parameters
	you've passed to the generator - if you've set the number of rooms to 0, or haven't set
	it, you69ay not get the results you expect. If the parameters you've passed seem fine,
	and you've written your own /jp_DungeonRoom object, it69ight be a good idea to check whether'
	or not you69eet all the assumptions69y code69akes about jp_DungeonRoom objects. There should
	be a reasonably complete list in the helpfile. If that doesn't help you out, contact69e in
	some way - you69ay have found a bug, or an assumption I haven't documented, or I can show
	you where you've gone wrong.
*/
/obj/procedural/jp_DungeonGenerator/proc/generate(seed=null)
	set background = 1
	if(!check_params()) return
	out_numPaths = 0
	out_numLongPaths = 0

	var/tempseed = rand(-65535, 65535)
	var/numits
	var/paths
	var/obj/procedural/jp_DungeonRoomEntry/nextentry
	var/obj/procedural/jp_DungeonRoom/nextroom
	var/list/obj/procedural/jp_DungeonRoom/rooms = list()
	var/list/obj/procedural/jp_DungeonRegion/regions = list()
	var/list/obj/procedural/jp_DungeonRoomEntry/required = list()
	var/turf/nextloc

	var/minx
	var/maxx
	var/miny
	var/maxy
	var/z

	var/obj/procedural/jp_DungeonRegion/region1
	var/obj/procedural/jp_DungeonRegion/region2

	var/timer = world.timeofday

	if(seed==null)
		out_seed = rand(-65535, 65535)
		rand_seed(out_seed)
	else
		out_seed = seed
		rand_seed(seed)


	z = corner1.z
	minx =69in(corner1.x, corner2.x) + roomMaxSize + 1
	maxx =69ax(corner1.x, corner2.x) - roomMaxSize - 1
	miny =69in(corner1.y, corner2.y) + roomMaxSize + 1
	maxy =69ax(corner1.y, corner2.y) - roomMaxSize - 1

	if(minx>maxx ||69iny>maxy)
		out_error = ERROR_BAD_AREA
		return

	if(usePreexistingRegions)
		examined = list()
		for(var/turf/t in block(locate(getMinX(), getMinY(), getZ()), locate(getMaxX(), getMaxY(), getZ())))
			if(!iswall(t)) if(!(t in examined)) rooms+=regionCreate(t)

	for(var/k in allowedRooms)
		nextentry = allowedRooms69k69
		if(nextentry.required>0) required+=nextentry

	var/rooms_placed = 0
	while(rooms_placed<numRooms)
		if(numits>maximumIterations)
			out_error=ERROR_MAX_ITERATIONS_ROOMS
			break

		nextloc = locate(rand(minx,69axx), rand(miny,69axy), z)

		if(!required.len) nextentry = allowedRooms69pick(allowedRooms)69
		else
			nextentry = required69169
			if(nextentry.count>=nextentry.required)
				required-=nextentry
				continue
		if(nextentry.maxnum>-1 && nextentry.count>=nextentry.maxnum) continue
		nextroom = new nextentry.roomtype(rand((nextentry.minsize<0)?(roomMinSize):(nextentry.minsize), (nextentry.maxsize<0)?(roomMaxSize):(nextentry.maxsize)), nextloc, src)
		numits++
		if(!nextroom.ok()) continue
		if(!rooms || !intersects(nextroom, rooms))
			nextroom.place()
			numits=0
			rooms+=nextroom
			rooms_placed++
			nextentry.count++
			sleep(1)

	border_turfs = list()

	for(var/obj/procedural/jp_DungeonRoom/r in rooms)
		if(!r.doesMultiborder())
			if(r.border.len == 0)
				continue
			var/obj/procedural/jp_DungeonRegion/reg = new /obj/procedural/jp_DungeonRegion(src)
			reg.addTurfs(r.getTurfs(), 1)
			reg.addBorder(r.getBorder())
			reg.center = r.centre
			regions+=reg
			border_turfs+=reg.getBorder()
		else
			for(var/l in r.getMultiborder())
				var/obj/procedural/jp_DungeonRegion/reg = new /obj/procedural/jp_DungeonRegion(src)
				reg.addTurfs(r.getTurfs(), 1)
				reg.addBorder(l)
				reg.center = r.centre
				regions+=reg
				border_turfs+=l

	for(var/turf/t in border_turfs)
		for(var/turf/t2 in range(t, 1))
			if(iswall(t2)&&!(t2 in border_turfs))
				for(var/turf/t3 in range(t2, 1))
					if(!iswall(t3))
						border_turfs+=t2
						break

	numits = 0
	paths = numExtraPaths

	while(regions.len>1 || paths>0)
		if(numits>maximumIterations)
			if(regions.len>1) out_error = ERROR_MAX_ITERATIONS_CONNECTIVITY
			else out_error = ERROR_MAX_ITERATIONS_EXTRAPATHS
			break
		numits++
		var/list/neighbors = getNeighboringRegions(regions)
		region1 = neighbors69169
		region2 = neighbors69269

		if(region1==region2)
			if(regions.len>1)
				continue

		var/list/regBord = region1.getBorder()
		if(!regBord.len)
			regions -= region1
			continue

		var/list/turf/path = getPath(region1, region2, regions)

		if(!path || !path.len) continue

		numits = 0

		if(region1==region2) if(regions.len<=1) paths--

		for(var/turf/t in path)
			path-=t
			t.ChangeTurf(floortype)
			if(prob(lightSpawnChance))
				spawn(5)
					AddLight(t)
			path+= t
			path_turfs += t

		region1.addTurfs(path)

		if(region1!=region2)
			region1.addTurfs(region2.getTurfs(), 1)
			region1.addBorder(region2.getBorder())
			regions-=region2

		for(var/turf/t in region1.getBorder()) if(!(t in border_turfs)) border_turfs+=t
		for(var/turf/t in path)	for(var/turf/t2 in range(t, 1))	if(!(t2 in border_turfs)) border_turfs+=t2

	for(var/obj/procedural/jp_DungeonRoom/r in rooms)
		r.finalise()

	initializeSubmaps()
	updateWallConnections()

	out_time = (world.timeofday-timer)
	out_rooms = rooms
	out_region = region1
	out_numRooms = out_rooms.len
	rand_seed(tempseed)








/***********************************************************************************
 *	The remaining procedures are seriously internal, and I strongly suggest not    *
 *  touching them unless you're certain you know what you're doing. That includes  *
 *  calling them, unless you've figured out what the side-effects and assumptions  *
 *  of the procedure are. These69ay not work except in the context of a generate() *
 *  call.
 ***********************************************************************************/

/obj/procedural/jp_DungeonGenerator/proc/regionCreate(turf/t)
	var/size
	var/centre
	var/minx=t.x
	var/miny=t.y
	var/maxx=t.x
	var/maxy=t.y
	var/obj/procedural/jp_DungeonRoom/preexist/r
	var/list/border = list()
	var/list/turfs = list()
	var/list/walls = list()
	var/list/next = list(t)

	while(next.len>=1)
		var/turf/nt = next69next.len69

		next-=nt
		examined+=nt
		if(nt.x<getMinX() || nt.x>getMaxX() || nt.y<getMinY() || nt.y>getMaxY()) continue
		if(iswall(nt))
			border+=nt
			continue

		if(nt.x<minx)69inx=nt.x
		if(nt.x>maxx)69axx=nt.x
		if(nt.y<miny)69iny=nt.y
		if(nt.y>maxy)69axy=nt.y
		if(!nt.density)
			turfs+=nt
			for(var/turf/t2 in getAdjacent(nt))	if(!((t2 in border) || (t2 in turfs))) next+=t2
		else
			walls+=nt

	size =69ax(maxy-miny,69axx-minx)
	size/=2
	size = round(size+0.4, 1)
	centre = locate(minx+size,69iny+size, getZ())

	r = new /obj/procedural/jp_DungeonRoom/preexist(size, centre, src)
	r.setBorder(border)
	r.setTurfs(turfs)
	r.setWalls(walls)

	return r

/*
	Checks if two jp_DungeonRooms are too close to each other
*/
/obj/procedural/jp_DungeonGenerator/proc/intersects(var/obj/procedural/jp_DungeonRoom/newroom,69ar/list/obj/procedural/jp_DungeonRoom/rooms)
	for(var/obj/procedural/jp_DungeonRoom/r in rooms)
		. = newroom.getSize() + r.getSize() + 2
		if((. > abs(newroom.getX() - r.getX())) && (. > abs(newroom.getY() - r.getY())))
			if(!doAccurateRoomPlacementCheck) return TRUE
			if(!(newroom.doesAccurate() && r.doesAccurate())) return TRUE

			var/intx1=-1
			var/intx2=-1
			var/inty1=-1
			var/inty2=-1

			var/rx1 = r.getX()-r.getSize()-1
			var/rx2 = r.getX()+r.getSize()+1
			var/sx1 = newroom.getX()-newroom.getSize()-1
			var/sx2 = newroom.getX()+newroom.getSize()+1

			var/ry1 = r.getY()-r.getSize()-1
			var/ry2 = r.getY()+r.getSize()+1
			var/sy1 = newroom.getY()-newroom.getSize()-1
			var/sy2 = newroom.getY()+newroom.getSize()+1

			if(rx1>=sx1 && rx1<=sx2) intx1 = rx1
			if(rx2>=sx1 && rx2<=sx2)
				if(intx1<0) intx1=rx2
				else intx2 = rx2
			if(sx1>rx1 && sx1<rx2)
				if(intx1<0) intx1 = sx1
				else intx2 = sx1
			if(sx2>rx1 && sx2<rx2)
				if(intx1<0) intx1 = sx2
				else intx2 = sx2

			if(ry1>=sy1 && ry1<=sy2) inty1 = ry1
			if(ry2>=sy1 && ry2<=sy2)
				if(inty1<0) inty1=ry2
				else inty2 = ry2
			if(sy1>ry1 && sy1<ry2)
				if(inty1<0) inty1 = sy1
				else inty2 = sy1
			if(sy2>ry1 && sy2<ry2)
				if(inty1<0) inty1 = sy2
				else inty2 = sy2

			for(var/turf/t in block(locate(intx1, inty1, getZ()), locate(intx2, inty2, getZ())))
				var/ret = (t in newroom.getTurfs()) + (t in newroom.getBorder()) + (t in newroom.getWalls()) + (t in r.getTurfs()) + (t in r.getBorder()) + (t in r.getWalls())
				if(ret>1) return TRUE
	return FALSE
/*
	Returns an X by X square of turfs with initial turf being in bottom right
*/

/obj/procedural/jp_DungeonGenerator/proc/GetSquare(var/turf/T,69ar/side_size = 2)
	var/list/square_turfs = list()
	for(var/turf/N in block(T,locate(T.x + side_size - 1, T.y + side_size - 1, T.z)))
		square_turfs += N
	return square_turfs

/*
	Constructs a path between two jp_DungeonRegions.
*/
/obj/procedural/jp_DungeonGenerator/proc/getPath(var/obj/procedural/jp_DungeonRegion/region1,69ar/obj/procedural/jp_DungeonRegion/region2)
	set background = 1
	//We pick our start on the border of our first room
	var/turf/start = pick(region1.getBorder())
	var/turf/end
	var/long = FALSE
	var/minlength =69inPathLength
	if(prob(longPathChance))
		minlength=minLongPathLength
		long = TRUE

	//We exclude all other border turfs of other rooms,69inus our targets, and where we start
	var/list/borders=list()
	borders.Add(border_turfs)
	borders.Remove(region2.getBorder())

	borders-=start

	var/list/turf/previous = list()
	var/list/turf/done = list(start)
	var/list/turf/next = getAdjacent(start)
	var/list/turf/cost = list("\ref69start69"=0)

	if(minlength<=0)
		if(start in region2.getBorder()) //We've somehow69anaged to link the two rooms in a single turf
			out_numPaths++
			if(long) out_numLongPaths++
			end = start
			return retPath(end, previous, pathWidth, start, end)

	next-=borders
	for(var/turf/t in next)
		if(!iswall(t)) next-=t
		previous69"\ref69t69"69 = start
		cost69"\ref69t69"69=1

	if(!next.len) return list() //We've somehow found a route that can not be continued.
	var/check_tick_in = 3
	while(1)
		check_tick_in = check_tick_in - 1
		var/turf/min
		var/mincost =69axPathLength

		for(var/turf/t in next)
			if((cost69"\ref69t69"69<mincost) || (cost69"\ref69t69"69==mincost && prob(50)))
				min = t
				mincost=cost69"\ref69t69"69

		if(!min) return list() //We've69anaged to outgrow our cost

		done +=69in
		next -=69in

		if(min in region2.getBorder()) //We've reached our destination
			if(mincost>minlength && prob(pathEndChance))
				out_numPaths++
				if(long) out_numLongPaths++
				end =69in
				break
			else
				continue

		for(var/turf/t in getAdjacent(min))
			var/stop_looking = FALSE
			for(var/turf/t1 in GetSquare(t, pathWidth + 1))
				if(!(iswall(t1) && !(t1 in borders)))
					stop_looking = TRUE
					break
			if(stop_looking)
				continue
			if(!(t in done) && !(t in next))
				next+=t
				previous69"\ref69t69"69 =69in
				cost69"\ref69t69"69 =69incost+1

		if(!check_tick_in)
			check_tick_in = 3
			CHECK_TICK
	return retPath(end, previous, pathWidth, start, end)

/obj/procedural/jp_DungeonGenerator/proc/retPath(var/list/end,69ar/list/previous,69ar/pathWidth,69ar/turf/start,69ar/turf/end)
	var/list/ret = list()
	ret += GetSquare(end, pathWidth)
	var/turf/last = end
	while(1)
		if(last==start) break
		ret+= GetSquare(previous69"\ref69last69"69, pathWidth)
		last=previous69"\ref69last69"69

	return ret

/obj/procedural/jp_DungeonGenerator/proc/check_params()
	if(!islist(allowedRooms) || allowedRooms.len<=0)
		out_error = ERROR_NO_ROOMS
		return 0

	if(!corner1 || !corner2 || corner1.z!=corner2.z)
		out_error = ERROR_BAD_AREA
		return 0

	if(!walltype || (islist(walltype) && walltype.len<=0))
		out_error = ERROR_NO_WALLTYPE
		return 0

	if(islist(walltype))
		for(var/k in walltype)
			if(!ispath(k))
				out_error = ERROR_NO_WALLTYPE
				return 0
	else
		if(!ispath(walltype))
			out_error = ERROR_NO_WALLTYPE
			return 0

	if(!floortype || !ispath(floortype))
		out_error = ERROR_NO_FLOORTYPE
		return 0

	if(numRooms<0 || round(numRooms)!=numRooms)
		out_error = ERROR_NUMROOMS_BAD
		return 0

	if(numExtraPaths<0 || round(numExtraPaths)!=numExtraPaths)
		out_error = ERROR_NUMEXTRAPATHS_BAD
		return 0

	if(roomMinSize>roomMaxSize || roomMinSize<0 || roomMaxSize<0 || round(roomMinSize)!=roomMinSize || round(roomMaxSize)!=roomMaxSize)
		out_error = ERROR_ROOM_SIZE_BAD
		return 0

	if(minPathLength>maxPathLength ||69inLongPathLength>maxPathLength ||69inPathLength<0 ||69axPathLength<0 ||69inLongPathLength<0 || round(minPathLength)!=minPathLength || round(maxPathLength)!=maxPathLength || round(minLongPathLength)!=minLongPathLength)
		out_error = ERROR_PATH_LENGTH_BAD
		return 0

	if(pathEndChance<0 || pathEndChance>100)
		out_error = ERROR_PATHENDCHANCE_BAD
		return 0

	if(longPathChance<0 || longPathChance>100)
		out_error = ERROR_LONGPATHCHANCE_BAD
		return 0

	return 1

/*
Seriously internal. No touching, unless you really know what you're doing. It's highly
unlikely that you'll need to69odify this
*/
/obj/procedural/jp_DungeonRoomEntry

	var/roomtype //The typepath of the room this is an entry for
	var/maxsize //The69aximum size of the room. -1 for default.
	var/minsize //The69inimum size of the room. -1 for default

	var/required //The number of rooms of this type that69ust be placed in the dungeon. 0 for no requirement.
	var/maxnum //The69aximum number of rooms of this type that can be placed in the dungeon. -1 for no limit
	var/count //The number of rooms that have been placed. Used to ensure compliance with69axnum.

/obj/procedural/jp_DungeonRoomEntry/New(roomtype_n,69axsize_n=-1,69insize_n=-1, required_n=-1,69axnum_n=-1)
	roomtype = roomtype_n
	maxsize =69axsize_n
	minsize =69insize_n
	required = required_n
	maxnum =69axnum_n

/*
This object is used to represent a 'region' in the dungeon - a set of contiguous floor turfs,
along with the walls that border them. This object is used extensively by the generator, and
has several assumptions embedded in it - think carefully before69aking changes
*/
/obj/procedural/jp_DungeonRegion
	var/obj/procedural/jp_DungeonGenerator/gen //A reference to the jp_DungeonGenerator using us
	var/list/turf/contained = list() //A list of the floors contained by the region
	var/list/turf/border = list() //A list of the walls bordering the floors of this region
	var/turf/center //Center of this region's room

/*
Make a new jp_DungeonRegion, and set its reference to its generator object
*/
/obj/procedural/jp_DungeonRegion/New(var/obj/procedural/jp_DungeonGenerator/g)
	gen = g


/*
	Add a list of turfs to the region, optionally without adding the walls around
	them to the list of borders
*/
/obj/procedural/jp_DungeonRegion/proc/addTurfs(list/turf/l, noborder=0)
	for(var/turf/t in l)
		if(t in border) border-=t
		if(!(t in contained))
			contained+=t
			if(!noborder)
				for(var/turf/t2 in gen.getAdjacent(t))
					if(iswall(t2) && !(t2 in border)) border+=t2

/*
	Adds a list of turfs to the border of the region.
*/
/obj/procedural/jp_DungeonRegion/proc/addBorder(list/turf/l)
	for(var/turf/t in l) if(!(t in border)) border+=t

/*
	Returns the list of floors in this region
*/
/obj/procedural/jp_DungeonRegion/proc/getTurfs()
	return contained

/*
	Returns the list of walls bordering the floors in this region
*/
/obj/procedural/jp_DungeonRegion/proc/getBorder()
	return border

/*
These objects are used to represent a 'room' - a distinct part of the dungeon
that is placed at the start, and then linked together. You will quite likely
want to create new jp_DungeonRooms. Consult the helpfile for69ore information
*/
/obj/procedural/jp_DungeonRoom
	var/turf/centre //The centrepoint of the room
	var/size //The size of the room. IMPORTANT: ROOMS69AY NOT TOUCH TURFS OUTSIDE range(centre, size). TURFS INSIDE range(centre,size)69AY BE DEALT WITH AS YOU WILL
	var/obj/procedural/jp_DungeonGenerator/gen //A reference to the generator using this room

	var/datum/map_template/my_map = null //The submap for this room
	var/list/turfs = list() //The list of turfs in this room. That should include internal walls.
	var/list/border = list() //The list of walls bordering this room. Anything in this list could be knocked down in order to69ake a path into the room
	var/list/walls = list() //The list of walls bordering the room that aren't used for connections into the room. Should include every wall turf next to a floor turf.69ay include turfs up to range(centre, size+1)
	var/list/multiborder = list() //Only used by rooms that have disjoint sets of borders. A list of lists of turfs. The sub-lists are treated like the border turf list
/*
Make a new jp_DungeonRoom, size 's', centre 'c', generator 'g'
*/
/obj/procedural/jp_DungeonRoom/New(s, turf/c,69ar/obj/procedural/jp_DungeonGenerator/g)
	size = s
	centre = c
	gen = g


/*
	Get69arious pieces of information about the centrepoint of this room
*/
/obj/procedural/jp_DungeonRoom/proc/getCentre()
	return centre
/obj/procedural/jp_DungeonRoom/proc/getX()
	return centre.x
/obj/procedural/jp_DungeonRoom/proc/getY()
	return centre.y
/obj/procedural/jp_DungeonRoom/proc/getZ()
	return centre.z

/*
	Get the size of this room
*/
/obj/procedural/jp_DungeonRoom/proc/getSize()
	return size

/*
	Actually place the room on the dungeon. place() is one of the few procedures allowed
	to actually69odify turfs in the dungeon - do NOT change turfs outside of place() or
	finalise(). This is called /before/ paths are placed, and69ay be called /before/ any
	other rooms are placed. If you would like to pretty the room up after basic dungeon
	geometry is done and dusted, use 'finalise()'
*/
/obj/procedural/jp_DungeonRoom/proc/place()
	return

/*
	Called on every room after everything has been generated. Use it to pretty up the
	room, or what-have-you. finalise() is the only other jp_DungeonRoom procedure that
	is allowed to69odify turfs in the dungeon.
*/
/obj/procedural/jp_DungeonRoom/proc/finalise()
	return

/*
	Return the border walls of this room.
*/
/obj/procedural/jp_DungeonRoom/proc/getBorder()
	return border

/*
	Return the turfs inside of this room
*/
/obj/procedural/jp_DungeonRoom/proc/getTurfs()
	return turfs

/obj/procedural/jp_DungeonRoom/proc/getMultiborder()
	return69ultiborder

/obj/procedural/jp_DungeonRoom/proc/getWalls()
	return walls

/*
	Returns true if the room is okay to be placed here, false otherwise
*/
/obj/procedural/jp_DungeonRoom/proc/ok()
	return TRUE

/obj/procedural/jp_DungeonRoom/proc/doesAccurate()
	return FALSE

/obj/procedural/jp_DungeonRoom/proc/doesMultiborder()
	return FALSE

/obj/procedural/jp_DungeonRoom/proc/doesSubmaps()
	return FALSE

/obj/procedural/jp_DungeonRoom/preexist
	name = "template"

/obj/procedural/jp_DungeonRoom/preexist/proc/setBorder(list/l)
		border = l

/obj/procedural/jp_DungeonRoom/preexist/proc/setTurfs(list/l)
		turfs = l

/obj/procedural/jp_DungeonRoom/preexist/proc/setWalls(list/l)
		walls = l

/obj/procedural/jp_DungeonRoom/preexist/doesAccurate()
	return TRUE

/*
Class for a simple square room, size*2+1 by size*2+1 units. Border is all turfs adjacent
to the floor that return true from iswall().
*/
/obj/procedural/jp_DungeonRoom/preexist/square
	name = "square"

/obj/procedural/jp_DungeonRoom/preexist/square/doesAccurate()
	return TRUE

/obj/procedural/jp_DungeonRoom/preexist/square/proc/getCorners()
	var/bordersize = size + 1
	var/turf/c1 = locate(centre.x + bordersize , centre.y + bordersize, centre.z)
	var/turf/c2 = locate(centre.x - bordersize, centre.y - bordersize, centre.z)
	var/turf/c3 = locate(centre.x + bordersize, centre.y - bordersize, centre.z)
	var/turf/c4 = locate(centre.x - bordersize, centre.y + bordersize, centre.z)
	return list(gen.getAdjacent(c1), gen.getAdjacent(c2), gen.getAdjacent(c3), gen.getAdjacent(c4))

/obj/procedural/jp_DungeonRoom/preexist/square/New()
	..()

	for(var/turf/t in range(centre, size)) turfs += t

	for(var/turf/t in turfs)
		for(var/turf/t2 in gen.getAdjacent(t))
			if(t2 in turfs)
				continue
			if(iswall(t2) && !(t2 in border))
				border += t2

	border -= getCorners() //If the path width is69ore than 1, the corner and path connection looks really ugly

/obj/procedural/jp_DungeonRoom/preexist/square/place()
	for(var/turf/t in turfs)
		turfs -=t
		t.ChangeTurf(gen.floortype)
		turfs += t

/*
A simple circle of radius 'size' units. Border is all turfs adjacent to the floor that
return true from iswall()
*/
/obj/procedural/jp_DungeonRoom/preexist/circle
	name = "round square"

/obj/procedural/jp_DungeonRoom/preexist/circle/doesAccurate()
	return TRUE

/obj/procedural/jp_DungeonRoom/preexist/circle/New()
	..()
	var/radsqr = size*size

	for(var/turf/t in range(centre, size))
		var/ti = t.x-getX()
		var/tj = t.y-getY()

		if(ti*ti + tj*tj>radsqr) continue

		turfs += t



	for(var/turf/t in turfs)
		for(var/turf/t2 in gen.getAdjacent(t))
			if(t2 in turfs)
				continue
			if(iswall(t2) && !(t2 in border))
				border+=t2

/obj/procedural/jp_DungeonRoom/preexist/circle/place()
	for(var/turf/t in turfs)
		turfs-=t
		turfs+=new gen.floortype(t)

/*
A giant plus sign, with arms of length size*2 + 1. Border is the turfs on the 'end' of
the arms of the plus sign - there are only four.
*/
/obj/procedural/jp_DungeonRoom/preexist/cross
	name = "cross"

/obj/procedural/jp_DungeonRoom/preexist/cross/doesAccurate()
	return TRUE

/obj/procedural/jp_DungeonRoom/preexist/cross/New()
	..()
	for(var/turf/t in range(centre, size))
		if(t.x == getX() || t.y == getY())
			turfs += t

	for(var/turf/t in range(centre, size+1))
		if(t in turfs) continue
		if(iswall(t) && (t.x == getX() || t.y == getY()))
			border+=t

/obj/procedural/jp_DungeonRoom/preexist/cross/place()
	for(var/turf/t in turfs)
		turfs-=t
		turfs+=new gen.floortype(t)


/obj/procedural/jp_DungeonRoom/preexist/deadend
	name = "deadend"

/obj/procedural/jp_DungeonRoom/preexist/deadend/place()
	centre=new gen.floortype(centre)
	turfs+=centre
	border+=pick(gen.getAdjacent(centre))

/*
	Same as square, but loads a submap out of allowed list
*/
/obj/procedural/jp_DungeonRoom/preexist/square/submap
	name = "submap square"


/obj/procedural/jp_DungeonRoom/preexist/square/submap/doesSubmaps()
	return TRUE

/obj/procedural/jp_DungeonRoom/preexist/square/submap/New()
	..()


/obj/procedural/jp_DungeonRoom/preexist/square/submap/finalise()
	if(border.len < 1)
		testing("ROOM 69my_map.name69 HAS NO BORDERS! at 69centre.x69, 69centre.y69!")
	if(my_map)
		my_map.load(centre, centered = TRUE, orientation = SOUTH, post_init = 1)
	else
		gen.out_error = gen.ERROR_NO_SUBMAPS

