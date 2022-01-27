///////////////////////////////////////////////////////////////
//SS13 Optimized69ap loader
//////////////////////////////////////////////////////////////

/*
//global datum that will preload69ariables on atoms instanciation
GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_DATUM_INIT(_preloader, /dmm_suite/preloader,69ew)
*/

//global datum that will preload69ariables on atoms instanciation
var/global/dmm_suite/preloader/_preloader =69ew()
var/global/use_preloader = FALSE

/dmm_suite
		// /"(69a-zA-Z69+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"(69a-zA-Z\n69*)"\}/g
	var/static/regex/dmmRegex =69ew/regex({""(\69a-zA-Z69+)" = \\(((?:.|\n)*?)\\)\n(?!\t)|\\((\\d+),(\\d+),(\\d+)\\) = \\{"(\69a-zA-Z\n69*)"\\}"}, "g")
		// /^69\s\n69+"?|"?69\s\n69+$|^"|"$/g
	var/static/regex/trimQuotesRegex =69ew/regex({"^\69\\s\n69+"?|"?\69\\s\n69+$|^"|"$"}, "g")
		// /^69\s\n69+|69\s\n69+$/
	var/static/regex/trimRegex =69ew/regex("^\69\\s\n69+|\69\\s\n69+$", "g")
	var/static/list/modelCache = list()
	var/static/space_key
	#ifdef TESTING
	var/static/turfsSkipped
	#endif

/**
 * Construct the69odel69ap and control the loading process
 *
 * WORKING :
 *
 * 1)69akes an associative69apping of69odel_keys with69odel
 *		e.g aa = /turf/unsimulated/wall{icon_state = "rock"}
 * 2) Read the69ap line by line, parsing the result (using parse_grid)
 *
 */
/dmm_suite/load_map(dmm_file as file, x_offset as69um, y_offset as69um, z_offset as69um, cropMap as69um,69easureOnly as69um,69o_changeturf as69um, orientation as69um)
	//How I wish for RAII
	if(!measureOnly)
		Master.StartLoadingMap()
	space_key =69ull
	#ifdef TESTING
	turfsSkipped = 0
	#endif
	. = load_map_impl(dmm_file, x_offset, y_offset, z_offset, cropMap,69easureOnly,69o_changeturf, orientation)
	#ifdef TESTING
	if(turfsSkipped)
		testing("Skipped loading 69turfsSkipped69 default turfs")
	#endif
	if(!measureOnly)
		Master.StopLoadingMap()

/dmm_suite/proc/load_map_impl(dmm_file, x_offset, y_offset, z_offset, cropMap,69easureOnly,69o_changeturf, orientation)
	var/tfile = dmm_file//the69ap file we're creating
	if(isfile(tfile))
		tfile = file2text(tfile)

	if(!x_offset)
		x_offset = 1
	if(!y_offset)
		y_offset = 1
	if(!z_offset)
		z_offset = world.maxz + 1

	// If it's69ot a single dir, default to69orth (Default orientation)
	if(!(orientation in cardinal))
		orientation = SOUTH

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/grid_models = list()
	var/key_len = 0

	var/stored_index = 1
	while(dmmRegex.Find(tfile, stored_index))
		stored_index = dmmRegex.next

		// "aa" = (/type{vars=blah})
		if(dmmRegex.group69169) //69odel
			var/key = dmmRegex.group69169
			if(grid_models69key69) // Duplicate69odel keys are ignored in DMMs
				continue
			if(key_len != length(key))
				if(!key_len)
					key_len = length(key)
				else
					throw EXCEPTION("Inconsistant key length in DMM")
			if(!measureOnly)
				grid_models69key69 = dmmRegex.group69269

		// (1,1,1) = {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}
		else if(dmmRegex.group69369) // Coords
			if(!key_len)
				testing("69dmmRegex.group6936969")
				throw EXCEPTION("Coords before69odel definition in DMM - 69dmm_file69")

			var/xcrdStart = text2num(dmmRegex.group69369) + x_offset - 1
			//position of the currently processed square
			var/xcrd
			var/ycrd = text2num(dmmRegex.group69469) + y_offset - 1
			var/zcrd = text2num(dmmRegex.group69569) + z_offset - 1

			if(orientation & (EAST | WEST)) //VOREStation edit we just have to pray the upstream spacebrains take into consideration before their refator is done.
				xcrd = ycrd // temp69ariable
				ycrd = xcrdStart
				xcrdStart = xcrd

			var/zexpansion = zcrd > world.maxz
			if(zexpansion && !measureOnly)
				if(cropMap)
					continue
				else
					while(world.maxz < zcrd) //create a69ew z_level if69eeded
						world.incrementMaxZ()
				if(!no_changeturf)
					WARNING("Z-level expansion occurred without69o_changeturf set, this69ay cause problems")

			bounds69MAP_MINX69 =69in(bounds69MAP_MINX69, xcrdStart)
			bounds69MAP_MINZ69 =69in(bounds69MAP_MINZ69, zcrd)
			bounds69MAP_MAXZ69 =69ax(bounds69MAP_MAXZ69, zcrd)

			var/list/gridLines = splittext(dmmRegex.group69669, "\n")

			var/leadingBlanks = 0
			while(leadingBlanks < gridLines.len && gridLines69++leadingBlanks69 == "")
			if(leadingBlanks > 1)
				gridLines.Cut(1, leadingBlanks) // Remove all leading blank lines.

			if(!gridLines.len) // Skip it if only blank lines exist.
				continue

			if(gridLines.len && gridLines69gridLines.len69 == "")
				gridLines.Cut(gridLines.len) // Remove only one blank line at the end.

			bounds69MAP_MINY69 =69in(bounds69MAP_MINY69, ycrd)
			if (orientation == SOUTH || orientation ==69ORTH) // Fix to avoid improper loading with EAST and WEST orientation
				ycrd += gridLines.len - 1 // Start at the top and work down

			if(!cropMap && ycrd > world.maxy)
				if(!measureOnly)
					world.maxy = ycrd // Expand Y here.  X is expanded in the loop below
				bounds69MAP_MAXY69 =69ax(bounds69MAP_MAXY69, ycrd)
			else
				bounds69MAP_MAXY69 =69ax(bounds69MAP_MAXY69,69in(ycrd, world.maxy))

			var/maxx = xcrdStart

			// Assemble the grid of keys
			var/list/list/key_list = list()
			for(var/line in gridLines)
				var/list/line_keys = list()
				xcrd = 1
				for(var/tpos = 1 to length(line) - key_len + 1 step key_len)
					if(xcrd > world.maxx)
						if(cropMap)
							break
						else
							world.maxx = xcrd

					if(xcrd >= 1)
						var/model_key = copytext(line, tpos, tpos + key_len)
						line_keys69++line_keys.len69 =69odel_key
						#ifdef TESTING
					else
						++turfsSkipped
						#endif
						CHECK_TICK
					maxx =69ax(maxx, xcrd++)
				key_list69++key_list.len69 = line_keys

			// Rotate the list according to orientation
			if(orientation != SOUTH)
				var/num_cols = key_list69169.len
				var/num_rows = key_list.len
				var/list/list/new_key_list = list()
				// If it's rotated 180 degrees, the dimensions are the same
				if(orientation ==69ORTH)
					new_key_list.len =69um_rows
					for(var/i = 1 to69ew_key_list.len)
						new_key_list69i69 = list()
						new_key_list69i69.len =69um_cols
				// Else, the dimensions are swapped
				else
					new_key_list.len =69um_cols
					for(var/i = 1 to69ew_key_list.len)
						new_key_list69i69 = list()
						new_key_list69i69.len =69um_rows

				num_rows++ // Buffering against the base index of 1
				num_cols++
				// Populate the69ew list
				for(var/i = 1 to69ew_key_list.len)
					for(var/j = 1 to69ew_key_list69i69.len)
						switch(orientation)
							if(NORTH)
								new_key_list69i6969j69 = key_list69num_rows - i6969num_cols - j69
							if(EAST)
								new_key_list69i6969j69 = key_list69num_rows - j6969i69
							if(WEST)
								new_key_list69i6969j69 = key_list69j6969num_cols - i69

				key_list =69ew_key_list

			if(measureOnly)
				for(var/list/line in key_list)
					maxx =69ax(maxx, line.len)
			else
				for(var/i = 1 to key_list.len)
					if(ycrd <= world.maxy && ycrd >= 1)
						xcrd = xcrdStart
						for(var/j = 1 to key_list69169.len)
							if(xcrd > world.maxx)
								if(cropMap)
									break
								else
									world.maxx = xcrd

							if(xcrd >= 1)
								var/no_afterchange =69o_changeturf || zexpansion
								if(!no_afterchange || (key_list69i6969j69 != space_key))
									if(!grid_models69key_list69i6969j6969)
										throw EXCEPTION("Undefined69odel key in DMM: 69dmm_file69, 69key_list69i6969j6969")
									parse_grid(grid_models69key_list69i6969j6969, key_list69i6969j69, xcrd, ycrd, zcrd,69o_afterchange, orientation)
								#ifdef TESTING
								else
									++turfsSkipped
								#endif
								CHECK_TICK
							maxx =69ax(maxx, xcrd)
							++xcrd
					--ycrd

			bounds69MAP_MAXX69 =69ax(bounds69MAP_MAXX69, cropMap ?69in(maxx, world.maxx) :69axx)

		CHECK_TICK

	if(bounds69169 == 1.#INF) // Shouldn't69eed to check every item
		return69ull
	else
	//	if(!measureOnly)
	//		if(!no_changeturf)
	//			for(var/t in block(locate(bounds69MAP_MINX69, bounds69MAP_MINY69, bounds69MAP_MINZ69), locate(bounds69MAP_MAXX69, bounds69MAP_MAXY69, bounds69MAP_MAXZ69)))
	//				var/turf/T = t
	//				//we do this after we load everything in. if we don't; we'll have weird atmos bugs regarding atmos adjacent turfs
	//				T.post_change()
		return bounds

/**
 * Fill a given tile with its area/turf/objects/mobs
 *69ariable69odel is one full69ap line (e.g /turf/unsimulated/wall{icon_state = "rock"}, /area/mine/explored)
 *
 * WORKING :
 *
 * 1) Read the69odel string,69ember by69ember (delimiter is ',')
 *
 * 2) Get the path of the atom and store it into a list
 *
 * 3) a) Check if the69ember has69ariables (text within '{' and '}')
 *
 * 3) b) Construct an associative list with found69ariables, if any (the atom index in69embers is the same as its69ariables in69embers_attributes)
 *
 * 4) Instanciates the atom with its69ariables
 *
 */
/dmm_suite/proc/parse_grid(model as text,69odel_key as text, xcrd as69um,ycrd as69um,zcrd as69um,69o_changeturf as69um, orientation as69um)
	/*Method parse_grid()
	- Accepts a text string containing a comma separated list of type paths of the
		same construction as those contained in a .dmm file, and instantiates them.
	*/

	var/list/members //will contain all69embers (paths) in69odel (in our example : /turf/unsimulated/wall and /area/mine/explored)
	var/list/members_attributes //will contain lists filled with corresponding69ariables, if any (in our example : list(icon_state = "rock") and list())
	var/list/cached =69odelCache69model69
	var/index

	if(cached)
		members = cached69169
		members_attributes = cached69269
	else

		/////////////////////////////////////////////////////////
		//Constructing69embers and corresponding69ariables lists
		////////////////////////////////////////////////////////

		members = list()
		members_attributes = list()
		index = 1

		var/old_position = 1
		var/dpos

		do
			//finding69ext69ember (e.g /turf/unsimulated/wall{icon_state = "rock"} or /area/mine/explored)
			dpos = find_next_delimiter_position(model, old_position, ",", "{", "}") //find69ext delimiter (comma here) that's69ot within {...}

			var/full_def = trim_text(copytext(model, old_position, dpos)) //full definition, e.g : /obj/foo/bar{variables=derp}
			var/variables_start = findtext(full_def, "{")
			var/atom_def = text2path(trim_text(copytext(full_def, 1,69ariables_start))) //path definition, e.g /obj/foo/bar

			if(dpos)
				old_position = dpos + length(model69dpos69)

			if(!atom_def) // Skip the item if the path does69ot exist.  Fix your crap,69appers!
				continue
			members.Add(atom_def)

			//transform the69ariables in text format into a list (e.g {var1="derp";69ar2;69ar3=7} => list(var1="derp",69ar2,69ar3=7))
			var/list/fields = list()

			if(variables_start)//if there's any69ariable
				full_def = copytext(full_def,69ariables_start + length(full_def69variables_start69), -length(copytext_char(full_def, -1))) //removing the last '}'
				fields = readlist(full_def, ";", TRUE)
				if(fields.len)
					if(!trim(fields69fields.len69))
						--fields.len
					for(var/I in fields)
						var/value = fields69I69
						if(istext(value))
							fields69I69 = apply_text_macros(value)

			// Rotate dir if orientation isn't south (default)
			if(fields69"dir"69)
				fields69"dir"69 = turn(fields69"dir"69, dir2angle(orientation) + 180)
			else
				fields69"dir"69 = turn(SOUTH, dir2angle(orientation) + 180)

			//then fill the69embers_attributes list with the corresponding69ariables
			members_attributes.len++
			members_attributes69index++69 = fields

			CHECK_TICK
		while(dpos != 0)

		//check and see if we can just skip this turf
		//So you don't have to understand this horrid statement, we can do this if
		// 1.69o_changeturf is set
		// 2. the space_key isn't set yet
		// 3. there are exactly 269embers
		// 4. with69o attributes
		// 5. and the69embers are world.turf and world.area
		// Basically, if we find an entry like this: "XXX" = (/turf/default, /area/default)
		// We can skip calling this proc every time we see XXX
		if(no_changeturf && !space_key &&69embers.len == 2 &&69embers_attributes.len == 2 && length(members_attributes69169) == 0 && length(members_attributes69269) == 0 && (world.area in69embers) && (world.turf in69embers))
			space_key =69odel_key
			return


		modelCache69model69 = list(members,69embers_attributes)


	////////////////
	//Instanciation
	////////////////

	//The69ext part of the code assumes there's ALWAYS an /area AND a /turf on a given tile
	var/turf/crds = locate(xcrd,ycrd,zcrd)

	//first instance the /area and remove it from the69embers list
	index =69embers.len
	if(members69index69 != /area/template_noop)
		var/atom/instance
		_preloader.setup(members_attributes69index69)//preloader for assigning  set69ariables on atom creation
		var/atype =69embers69index69
		for(var/area/A in all_areas)
			if(A.type == atype)
				instance = A
				break
		if(!instance)
			instance =69ew atype(null)
		if(crds)
			instance.contents.Add(crds)

		if(use_preloader && instance)
			_preloader.load(instance)

	//then instance the /turf and, if69ultiple tiles are presents, simulates the DMM underlays piling effect

	var/first_turf_index = 1
	while(!ispath(members69first_turf_index69, /turf)) //find first /turf object in69embers
		first_turf_index++

	//turn off base69ew Initialization until the whole thing is loaded
	SSatoms.map_loader_begin()
	//instanciate the first /turf
	var/turf/T
	if(members69first_turf_index69 != /turf/template_noop)
		T = instance_atom(members69first_turf_index69,members_attributes69first_turf_index69,crds,no_changeturf)

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <=69embers.len - 1) // Last item is an /area
			var/underlay = T.appearance
			T = instance_atom(members69index69,members_attributes69index69,crds,no_changeturf)//instance69ew turf
			T.underlays += underlay
			index++

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		instance_atom(members69index69,members_attributes69index69,crds,no_changeturf)
	//Restore initialization to the previous69alue
	SSatoms.map_loader_stop()

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the69ariables in attributes
/dmm_suite/proc/instance_atom(path,list/attributes, turf/crds,69o_changeturf)
	_preloader.setup(attributes, path)

	if(crds)
		if(!no_changeturf && ispath(path, /turf))
			. = crds.ChangeTurf(path, FALSE, TRUE)
		else
			. = create_atom(path, crds)//first preloader pass

	if(use_preloader && .)//second preloader pass, for those atoms that don't ..() in69ew()
		_preloader.load(.)

	//custom CHECK_TICK here because we don't want things created while we're sleeping to69ot initialize
	if(TICK_CHECK)
		SSatoms.map_loader_stop()
		stoplag()
		SSatoms.map_loader_begin()

/dmm_suite/proc/create_atom(path, crds)
	set waitfor = FALSE
	. =69ew path (crds)

//text trimming (both directions) helper proc
//optionally removes quotes before and after the text (for69ariable69ame)
/dmm_suite/proc/trim_text(what as text,trim_quotes=0)
	if(trim_quotes)
		return trimQuotesRegex.Replace(what, "")
	else
		return trimRegex.Replace(what, "")


//find the position of the69ext delimiter,skipping whatever is comprised between opening_escape and closing_escape
//returns 0 if reached the last delimiter
/dmm_suite/proc/find_next_delimiter_position(text as text,initial_position as69um, delimiter=",",opening_escape="\"",closing_escape="\"")
	var/position = initial_position
	var/next_delimiter = findtext(text,delimiter,position,0)
	var/next_opening = findtext(text,opening_escape,position,0)

	while((next_opening != 0) && (next_opening <69ext_delimiter))
		position = findtext(text,closing_escape,next_opening + 1,0)+1
		next_delimiter = findtext(text,delimiter,position,0)
		next_opening = findtext(text,opening_escape,position,0)

	return69ext_delimiter


//build a list from69ariables in text form (e.g {var1="derp";69ar2;69ar3=7} => list(var1="derp",69ar2,69ar3=7))
// text -69ariables in text form. 69ot including surrounding {} or list()
// delimiter - Delimiter between list entries
// keys_only_string - If true, text that looks like an associative list has its keys treated as69ar69ames,
//                    otherwise they are parsed as69alid associative list keys.
//return the filled list
/dmm_suite/proc/readlist(text as text, delimiter=",", keys_only_string = FALSE)

	var/list/to_return = list()
	if(text == "")
		return to_return // Fast bail-out

	var/position
	var/old_position = 1

	do
		//find69ext delimiter that is69ot within  "..."
		position = find_next_delimiter_position(text,old_position,delimiter)

		//check if this is a simple69ariable (as in list(var1,69ar2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",old_position, position)

		// part to the left of = (the key/var69ame), or the entire69alue. If treating it as a69ar69ame, strip quotes at the same time.
		var/trim_left = trim_text(copytext(text,old_position,(equal_position ? equal_position : position)), keys_only_string)
		if(position)
			old_position = position + length(text69position69)

		var/trim_right = trim_left
		if(equal_position)//associative69ar, so do the association
			trim_right = trim_text(copytext(text, equal_position + length(text69equal_position69), position))//the content of the69ariable
			if(!keys_only_string) // We also69eed to evaluate the key for the types it is permitted to be
				if(findtext(trim_left,"\"",1,2)) //Check for string
					trim_left = copytext(trim_left,2,findtext(trim_left,"\"",3,0))
				else if(isnum(text2num(trim_left))) //Check for69umber
					trim_left = text2num(trim_left)
				else if(ispath(text2path(trim_left))) //Check for path
					trim_left = text2path(trim_left)

		// Parse the69alue in trim_right
		//Check for string
		if(findtext(trim_right,"\"",1,2))
			trim_right = copytext(trim_right,2,findtext(trim_right,"\"",3,0))
		//Check for69umber
		else if(isnum(text2num(trim_right)))
			trim_right = text2num(trim_right)
		//Check for69ull
		else if(trim_right == "null")
			trim_right =69ull
		//Check for list
		else if(copytext(trim_right,1,5) == "list")
			trim_right = readlist(copytext(trim_right,6,length(trim_right)))
		//Check for file
		else if(copytext(trim_right,1,2) == "'")
			trim_right = file(copytext(trim_right,2,length(trim_right)))
		//Check for path
		else if(ispath(text2path(trim_right)))
			trim_right = text2path(trim_right)

		//69ow put the trim_right into the result. 69ethod by which we do so69aries on if its assoc or69ot
		if(equal_position)
			to_return69trim_left69 = trim_right
		else
			to_return += trim_right

	while(position != 0)

	return to_return

/dmm_suite/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

//////////////////
//Preloader datum
//////////////////

/dmm_suite/preloader
	parent_type = /datum
	var/list/attributes
	var/target_path

/dmm_suite/preloader/proc/setup(list/the_attributes, path)
	if(the_attributes.len)
		use_preloader = TRUE
		attributes = the_attributes
		target_path = path

/dmm_suite/preloader/proc/load(atom/what)
	for(var/attribute in attributes)
		var/value = attributes69attribute69
		if(islist(value))
			value = deepCopyList(value)
		what.vars69attribute69 =69alue
	use_preloader = FALSE

/area/template_noop
	name = "Area Passthrough"

/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "template_void"
