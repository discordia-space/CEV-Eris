///////////////////////////////////////////////////////////////
//SS13 Optimized69ap loader
//////////////////////////////////////////////////////////////

//global datum that will preload69ariables on atoms instanciation
var/global/dmm_suite/preloader/_preloader =69ull


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
/dmm_suite/load_map(var/dmm_file as file,69ar/z_offset as69um)
	if(!z_offset)//what z_level we are creating the69ap on
		z_offset = world.maxz+1

	var/quote = ascii2text(34)
	var/tfile = file2text(dmm_file)//the69ap file we're creating
	var/tfile_len = length(tfile)
	var/lpos = 1 // the69odels definition index

	///////////////////////////////////////////////////////////////////////////////////////
	//first let's69ap69odel keys (e.g "aa") to their contents (e.g /turf/space{variables})
	///////////////////////////////////////////////////////////////////////////////////////
	var/list/grid_models = list()
	var/key_len = length(copytext(tfile,2,findtext(tfile,quote,2,0)))//the length of the69odel key (e.g "aa" or "aba")

	//proceed line by line
	for(lpos=1; lpos<tfile_len; lpos=findtext(tfile,"\n",lpos,0)+1)
		var/tline = copytext(tfile,lpos,findtext(tfile,"\n",lpos,0))
		if(copytext(tline,1,2) != quote)//we reached the69ap "layout"
			break
		var/model_key = copytext(tline,2,2+key_len)
		var/model_contents = copytext(tline,findtext(tfile,"=")+3,length(tline))
		grid_models69model_key69 =69odel_contents
		sleep(-1)

	///////////////////////////////////////////////////////////////////////////////////////
	//now let's fill the69ap with turf and objects using the constructed69odel69ap
	///////////////////////////////////////////////////////////////////////////////////////

	//position of the currently processed square
	var/zcrd=-1
	var/ycrd=0
	var/xcrd=0

	for(var/zpos=findtext(tfile,"\n(1,1,",lpos,0);zpos!=0;zpos=findtext(tfile,"\n(1,1,",zpos+1,0))	//in case there's several69aps to load

		zcrd++
		while((zcrd + z_offset) > world.maxz) //create a69ew z_level if69eeded
			world.incrementMaxZ()

		var/zgrid = copytext(tfile,findtext(tfile,quote+"\n",zpos,0)+2,findtext(tfile,"\n"+quote,zpos,0)+1) //copy the whole69ap grid
		var/z_depth = length(zgrid)

		//if exceeding the world69ax x or y, increase it
		var/x_depth = length(copytext(zgrid,1,findtext(zgrid,"\n",2,0)))
		if(world.maxx<x_depth)
			world.maxx=x_depth

		var/y_depth = z_depth / (x_depth+1)//x_depth + 1 because we're counting the '\n' characters in z_depth
		if(world.maxy<y_depth)
			world.maxy=y_depth

		//then proceed it line by line, starting from top
		ycrd = y_depth

		for(var/gpos=1;gpos!=0;gpos=findtext(zgrid,"\n",gpos,0)+1)
			var/grid_line = copytext(zgrid,gpos,findtext(zgrid,"\n",gpos,0))

			//fill the current square using the69odel69ap
			xcrd=0
			for(var/mpos=1;mpos<=x_depth;mpos+=key_len)
				xcrd++
				var/model_key = copytext(grid_line,mpos,mpos+key_len)
				parse_grid(grid_models69model_key69,xcrd,ycrd,zcrd+z_offset)

			//reached end of current69ap
			if(gpos+x_depth+1>z_depth)
				break

			ycrd--

			sleep(-1)

		//reached End Of File
		if(findtext(tfile,quote+"}",zpos,0)+2==tfile_len)
			break
		sleep(-1)

/**
 * Fill a given tile with its area/turf/objects/mobs
 *69ariable69odel is one full69ap line (e.g /turf/unsimulated/wall{icon_state = "rock"},/area/mine/explored)
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
/dmm_suite/proc/parse_grid(var/model as text,var/xcrd as69um,var/ycrd as69um,var/zcrd as69um)
	/*Method parse_grid()
	- Accepts a text string containing a comma separated list of type paths of the
		same construction as those contained in a .dmm file, and instantiates them.
	*/

	var/list/members = list()//will contain all69embers (paths) in69odel (in our example : /turf/unsimulated/wall and /area/mine/explored)
	var/list/members_attributes = list()//will contain lists filled with corresponding69ariables, if any (in our example : list(icon_state = "rock") and list())


	/////////////////////////////////////////////////////////
	//Constructing69embers and corresponding69ariables lists
	////////////////////////////////////////////////////////

	var/index=1
	var/old_position = 1
	var/dpos

	do
		//finding69ext69ember (e.g /turf/unsimulated/wall{icon_state = "rock"} or /area/mine/explored)
		dpos= find_next_delimiter_position(model,old_position,",","{","}")//find69ext delimiter (comma here) that's69ot within {...}

		var/full_def = copytext(model,old_position,dpos)//full definition, e.g : /obj/foo/bar{variables=derp}
		var/atom_def = text2path(copytext(full_def,1,findtext(full_def,"{")))//path definition, e.g /obj/foo/bar
		members.Add(atom_def)
		old_position = dpos + 1

		//transform the69ariables in text format into a list (e.g {var1="derp";69ar2;69ar3=7} => list(var1="derp",69ar2,69ar3=7))
		var/list/fields = list()

		var/variables_start = findtext(full_def,"{")
		if(variables_start)//if there's any69ariable
			full_def = copytext(full_def,variables_start+1,length(full_def))//removing the last '}'
			fields = text2list(full_def,";")

		//then fill the69embers_attributes list with the corresponding69ariables
		members_attributes.len++
		members_attributes69index++69 = fields

		sleep(-1)
	while(dpos != 0)


	////////////////
	//Instanciation
	////////////////

	//The69ext part of the code assumes there's ALWAYS an /area AND a /turf on a given tile

	//in case of69ultiples turfs on one tile,
	//will contains the images of all underlying turfs, to simulate the DMM69ultiple tiles piling
	var/list/turfs_underlays = list()

	//first instance the /area and remove it from the69embers list
	index =69embers.len
	var/atom/instance
	_preloader =69ew(members_attributes69index69)//preloader for assigning  set69ariables on atom creation

	instance = locate(members69index69)
	instance.contents.Add(locate(xcrd,ycrd,zcrd))

	if(_preloader && instance)
		_preloader.load(instance)

	members.Remove(members69index69)

	//then instance the /turf and, if69ultiple tiles are presents, simulates the DMM underlays piling effect

	var/first_turf_index = 1
	while(!ispath(members69first_turf_index69,/turf)) //find first /turf object in69embers
		first_turf_index++

	//instanciate the first /turf
	var/turf/T = instance_atom(members69first_turf_index69,members_attributes69first_turf_index69,xcrd,ycrd,zcrd)

	//if others /turf are presents, simulates the underlays piling effect
	index = first_turf_index + 1
	while(index <=69embers.len)
		turfs_underlays.Insert(1,image(T.icon,null,T.icon_state,T.layer,T.dir))//add the current turf image to the underlays list
		var/turf/UT = instance_atom(members69index69,members_attributes69index69,xcrd,ycrd,zcrd)//instance69ew turf
		add_underlying_turf(UT,T,turfs_underlays)//simulates the DMM piling effect
		T = UT
		index++

	//finally instance all remainings objects/mobs
	for(index=1,index < first_turf_index,index++)
		instance_atom(members69index69,members_attributes69index69,xcrd,ycrd,zcrd)

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the69ariables in attributes
/dmm_suite/proc/instance_atom(var/path,var/list/attributes,69ar/x,69ar/y,69ar/z)
	var/atom/instance
	_preloader =69ew(attributes, path)

	instance =69ew path (locate(x,y,z))//first preloader pass

	if(_preloader && instance)//second preloader pass, for those atoms that don't ..() in69ew()
		_preloader.load(instance)

	return instance

//text trimming (both directions) helper proc
//optionally removes quotes before and after the text (for69ariable69ame)
/dmm_suite/proc/trim_text(var/what as text,var/trim_quotes=0)
	while(length(what) && (findtext(what," ",1,2)))
		what=copytext(what,2,0)
	while(length(what) && (findtext(what," ",length(what),0)))
		what=copytext(what,1,length(what))
	if(trim_quotes)
		while(length(what) && (findtext(what,quote,1,2)))
			what=copytext(what,2,0)
		while(length(what) && (findtext(what,quote,length(what),0)))
			what=copytext(what,1,length(what))
	return what

//find the position of the69ext delimiter,skipping whatever is comprised between opening_escape and closing_escape
//returns 0 if reached the last delimiter
/dmm_suite/proc/find_next_delimiter_position(var/text as text,var/initial_position as69um,69ar/delimiter=",",var/opening_escape=quote,var/closing_escape=quote)
	var/position = initial_position
	var/next_delimiter = findtext(text,delimiter,position,0)
	var/next_opening = findtext(text,opening_escape,position,0)

	while((next_opening != 0) && (next_opening <69ext_delimiter))
		position = findtext(text,closing_escape,next_opening + 1,0)+1
		next_delimiter = findtext(text,delimiter,position,0)
		next_opening = findtext(text,opening_escape,position,0)

	return69ext_delimiter


//build a list from69ariables in text form (e.g {var1="derp";69ar2;69ar3=7} => list(var1="derp",69ar2,69ar3=7))
//return the filled list
/dmm_suite/proc/text2list(var/text as text,var/delimiter=",")

	var/list/to_return = list()

	var/position
	var/old_position = 1

	do
		//find69ext delimiter that is69ot within  "..."
		position = find_next_delimiter_position(text,old_position,delimiter)

		//check if this is a simple69ariable (as in list(var1,69ar2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",old_position, position)

		var/trim_left = trim_text(copytext(text,old_position,(equal_position ? equal_position : position)),1)//the69ame of the69ariable,69ust trim quotes to build a BYOND compliant associatives list
		old_position = position + 1

		if(equal_position)//associative69ar, so do the association
			var/trim_right = trim_text(copytext(text,equal_position+1,position))//the content of the69ariable

			//Check for string
			if(findtext(trim_right,quote,1,2))
				trim_right = copytext(trim_right,2,findtext(trim_right,quote,3,0))

			//Check for69umber
			else if(isnum(text2num(trim_right)))
				trim_right = text2num(trim_right)

			//Check for69ull
			else if(trim_right == "null")
				trim_right =69ull

			//Check for list
			else if(copytext(trim_right,1,5) == "list")
				trim_right = text2list(copytext(trim_right,6,length(trim_right)))

			//Check for file
			else if(copytext(trim_right,1,2) == "'")
				trim_right = file(copytext(trim_right,2,length(trim_right)))

			to_return69trim_left69 = trim_right

		else//simple69ar
			to_return69trim_left69 =69ull

	while(position != 0)

	return to_return

//simulates the DM69ultiple turfs on one tile underlaying
/dmm_suite/proc/add_underlying_turf(var/turf/placed,var/turf/underturf,69ar/list/turfs_underlays)
	if(underturf.density)
		placed.density = TRUE
	if(underturf.opacity)
		placed.set_opacity(TRUE)
	placed.underlays += turfs_underlays

//atom creation69ethod that preloads69ariables at creation
/atom/New()
	if(_preloader && (src.type == _preloader.target_path))//in case the instanciated atom is creating other atoms in69ew()
		_preloader.load(src)

	. = ..()

//////////////////
//Preloader datum
//////////////////

/dmm_suite/preloader
	parent_type = /datum
	var/list/attributes
	var/target_path

/dmm_suite/preloader/New(var/list/the_attributes,69ar/path)
	.=..()
	if(!the_attributes.len)
		del(src)
		return
	attributes = the_attributes
	target_path = path

/dmm_suite/preloader/proc/load(atom/what)
	for(var/attribute in attributes)
		what.vars69attribute69 = attributes69attribute69
	del(src)
