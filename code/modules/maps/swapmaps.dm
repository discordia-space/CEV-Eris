//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	SwapMaps library by Lummox JR
	developed for digitalBYOND
	http://www.digitalbyond.org

	Version 2.1

	The purpose of this library is to69ake it easy for authors to swap69aps
	in and out of their game using savefiles. Swapped-out69aps can be
	transferred between worlds for an69MORPG, sent to the client, etc.
	This is facilitated by the use of a special datum and a global list.

	Uses of swapmaps:

	- Temporary battle arenas
	- House interiors
	- Individual custom player houses
	-69irtually unlimited terrain
	- Sharing69aps between servers running different instances of the same
	  game
	- Loading and saving pieces of69aps for reusable room templates
 */

/*
	User Interface:

	VARS:

	swapmaps_iconcache
		An associative list of icon files with69ames, like
		'player.dmi' = "player"
	swapmaps_mode
		This69ust be set at runtime, like in world/New().

		SWAPMAPS_SAV	0	(default)
			Uses .sav files for raw /savefile output.
		SWAPMAPS_TEXT	1
			Uses .txt files69ia ExportText() and ImportText(). These69aps
			are easily editable and appear to take up less space in the
			current69ersion of BYOND.

	PROCS:

	SwapMaps_Find(id)
		Find a69ap by its id
	SwapMaps_Load(id)
		Load a69ap by its id
	SwapMaps_Save(id)
		Save a69ap by its id (calls swapmap.Save())
	SwapMaps_Unload(id)
		Save and unload a69ap by its id (calls swapmap.Unload())
	SwapMaps_Save_All()
		Save all69aps
	SwapMaps_DeleteFile(id)
		Delete a69ap file
	SwapMaps_CreateFromTemplate(id)
		Create a69ew69ap by loading another69ap to use as a template.
		This69ap has id==src and will69ot be saved. To69ake it savable,
		  change id with swapmap.SetID(newid).
	SwapMaps_LoadChunk(id,turf/locorner)
		Load a swapmap as a "chunk", at a specific place. A69ew datum is
		created but it's69ot added to the list of69aps to save or unload.
		The69ew datum can be safely deleted without affecting the turfs
		it loaded. The purpose of this is to load a69ap file onto part of
		another swapmap or an existing part of the world.
		locorner is the corner turf with the lowest x,y,z69alues.
	SwapMaps_SaveChunk(id,turf/corner1,turf/corner2)
		Save a piece of the world as a "chunk". A69ew datum is created
		for the chunk, but it can be deleted without destroying any turfs.
		The chunk file can be reloaded as a swapmap all its own, or loaded
		via SwapMaps_LoadChunk() to become part of another69ap.
	SwapMaps_GetSize(id)
		Return a list corresponding to the x,y,z sizes of a69ap file,
		without loading the69ap.
		Returns69ull if the69ap is69ot found.
	SwapMaps_AddIconToCache(name,icon)
		Cache an icon file by69ame for space-saving storage

	swapmap.New(id,x,y,z)
		Create a69ew69ap; specify id, width (x), height (y), and
		 depth (z)
		Default size is world.maxx,world.maxy,1
	swapmap.New(id,turf1,turf2)
		Create a69ew69ap; specify id and 2 corners
		This becomes a /swapmap for one of the compiled-in69aps, for
		 easy saving.
	swapmap.New()
		Create a69ew69ap datum, but does69ot allocate space or assign an
		 ID (used for loading).
	swapmap.Del()
		Deletes a69ap but does69ot save
	swapmap.Save()
		Saves to69ap_69id69.sav
		Maps with id==src are69ot saved.
	swapmap.Unload()
		Saves the69ap and then deletes it
		Maps with id==src are69ot saved.
	swapmap.SetID(id)
		Change the69ap's id and69ake changes to the lookup list
	swapmap.AllTurfs(z)
		Returns a block of turfs encompassing the entire69ap, or on just
		 one z-level
		z is in world coordinates; it is optional
	swapmap.Contains(turf/T)
		Returns69onzero if T is inside the69ap's boundaries.
		Also works for objs and69obs, but the proc is69ot area-safe.
	swapmap.InUse()
		Returns69onzero if a69ob with a key is within the69ap's
		 boundaries.
	swapmap.LoCorner(z=z1)
		Returns locate(x1,y1,z), where z=z1 if69one is specified.
	swapmap.HiCorner(z=z2)
		Returns locate(x2,y2,z), where z=z2 if69one is specified.
	swapmap.BuildFilledRectangle(turf/corner1,turf/corner2,item)
		Builds a filled rectangle of item from one corner turf to the
		 other, on69ultiple z-levels if69ecessary. The corners69ay be
		 specified in any order.
		item is a type path like /turf/wall or /obj/barrel{full=1}.
	swapmap.BuildRectangle(turf/corner1,turf/corner2,item)
		Builds an unfilled rectangle of item from one corner turf to
		 the other, on69ultiple z-levels if69ecessary.
	swapmap.BuildInTurfs(list/turfs,item)
		Builds item on all of the turfs listed. The list69eed69ot
		 contain only turfs, or even only atoms.
 */

swapmap
	var/id		// a string identifying this69ap uniquely
	var/x1		//69inimum x,y,z coords
	var/y1
	var/z1
	var/x2		//69aximum x,y,z coords (also used as width,height,depth until positioned)
	var/y2
	var/z2
	var/tmp/locked	// don't69ove anyone to this69ap; it's saving or loading
	var/tmp/mode	// save as text-mode
	var/ischunk		// tells the load routine to load to the specified location

	New(_id,x,y,z)
		if(isnull(_id)) return
		id=_id
		mode=swapmaps_mode
		if(isturf(x) && isturf(y))
			/*
				Special format: Defines a69ap as an existing set of turfs;
				this is useful for saving a compiled69ap in swapmap format.
				Because this is a compiled-in69ap, its turfs are69ot deleted
				when the datum is deleted.
			 */
			x1=min(x:x,y:x);x2=max(x:x,y:x)
			y1=min(x:y,y:y);y2=max(x:y,y:y)
			z1=min(x:z,y:z);z2=max(x:z,y:z)
			InitializeSwapMaps()
			if(z2>swapmaps_compiled_maxz ||\
			   y2>swapmaps_compiled_maxy ||\
			   x2>swapmaps_compiled_maxx)
				qdel(src)
			return
		x2=x?(x):world.maxx
		y2=y?(y):world.maxy
		z2=z?(z):1
		AllocateSwapMap()

	Del()
		// a temporary datum for a chunk can be deleted outright
		// for others, some cleanup is69ecessary
		if(!ischunk)
			swapmaps_loaded-=src
			swapmaps_byname-=id
			if(z2>swapmaps_compiled_maxz ||\
			   y2>swapmaps_compiled_maxy ||\
			   x2>swapmaps_compiled_maxx)
				var/list/areas=new
				for(var/atom/A in block(locate(x1,y1,z1),locate(x2,y2,z2)))
					for(var/obj/O in A) qdel(O)
					for(var/mob/M in A)
						if(!M.key) qdel(M)
						else69.loc=null
					areas69A.loc69=null
					qdel(A)
				// delete areas that belong only to this69ap
				for(var/area/a in areas)
					if(a && !a.contents.len) qdel(a)
				if(x2>=world.maxx || y2>=world.maxy || z2>=world.maxz) CutXYZ()
				qdel(areas)
		..()

	/*
		Savefile format:
		map
		  id
		  x		// size,69ot coords
		  y
		  z
		  areas	// list of areas,69ot including default
		  69each z; 1 to depth69
		    69each y; 1 to height69
		      69each x; 1 to width69
		        type	// of turf
		        AREA    // if69on-default; saved as a69umber (index into areas list)
		       69ars    // all other changed69ars
	 */
	Write(savefile/S)
		var/x
		var/y
		var/z
		var/n
		var/list/areas
		var/area/defarea=locate(world.area)
		if(!defarea) defarea=new world.area
		areas=list()
		for(var/turf/T in block(locate(x1,y1,z1),locate(x2,y2,z2)))
			areas69T.loc69=null
		for(n in areas)	// quickly eliminate associations for smaller storage
			areas-=n
			areas+=n
		areas-=defarea
		InitializeSwapMaps()
		locked=1
		S69"id"69 << id
		S69"z"69 << z2-z1+1
		S69"y"69 << y2-y1+1
		S69"x"69 << x2-x1+1
		S69"areas"69 << areas
		for(n in 1 to areas.len) areas69areas69n6969=n
		var/oldcd=S.cd
		for(z=z1,z<=z2,++z)
			S.cd="69z-z1+169"
			for(y=y1,y<=y2,++y)
				S.cd="69y-y1+169"
				for(x=x1,x<=x2,++x)
					S.cd="69x-x1+169"
					var/turf/T=locate(x,y,z)
					S69"type"69 << T.type
					if(T.loc!=defarea) S69"AREA"69 << areas69T.loc69
					T.Write(S)
					S.cd=".."
				S.cd=".."
			sleep()
			S.cd=oldcd
		locked=0
		qdel(areas)

	Read(savefile/S,_id,turf/locorner)
		var/x
		var/y
		var/z
		var/n
		var/list/areas
		var/area/defarea=locate(world.area)
		id=_id
		if(locorner)
			ischunk=1
			x1=locorner.x
			y1=locorner.y
			z1=locorner.z
		if(!defarea) defarea=new world.area
		if(!_id)
			S69"id"69 >> id
		else
			var/dummy
			S69"id"69 >> dummy
		S69"z"69 >> z2		// these are depth,
		S69"y"69 >> y2		//   		 height,
		S69"x"69 >> x2		//			 width
		S69"areas"69 >> areas
		locked=1
		AllocateSwapMap()	// adjust x1,y1,z1 - x2,y2,z2 coords
		var/oldcd=S.cd
		for(z=z1,z<=z2,++z)
			S.cd="69z-z1+169"
			for(y=y1,y<=y2,++y)
				S.cd="69y-y1+169"
				for(x=x1,x<=x2,++x)
					S.cd="69x-x1+169"
					var/tp
					S69"type"69>>tp
					var/turf/T=locate(x,y,z)
					T.loc.contents-=T
					T=new tp(locate(x,y,z))
					if("AREA" in S.dir)
						S69"AREA"69>>n
						var/area/A=areas69n69
						A.contents+=T
					else defarea.contents+=T
					// clear the turf
					for(var/obj/O in T) qdel(O)
					for(var/mob/M in T)
						if(!M.key) qdel(M)
						else69.loc=null
					// finish the read
					T.Read(S)
					S.cd=".."
				S.cd=".."
			sleep()
			S.cd=oldcd
		locked=0
		qdel(areas)

	/*
		Find an empty block on the world69ap in which to load this69ap.
		If69o space is found, increase world.maxz as69ecessary. (If the
		map is greater in x,y size than the current world, expand
		world.maxx and world.maxy too.)

		Ignore certain operations if loading a69ap as a chunk. Use the
		x1,y1,z1 position for it, and *don't* count it as a loaded69ap.
	 */
	proc/AllocateSwapMap()
		InitializeSwapMaps()
		world.maxx=max(x2,world.maxx)	// stretch x/y if69ecessary
		world.maxy=max(y2,world.maxy)
		if(!ischunk)
			if(world.maxz<=swapmaps_compiled_maxz)
				z1=swapmaps_compiled_maxz+1
				x1=1;y1=1
			else
				var/list/l=ConsiderRegion(1,1,world.maxx,world.maxy,swapmaps_compiled_maxz+1)
				x1=l69169
				y1=l69269
				z1=l69369
				qdel(l)
		x2+=x1-1
		y2+=y1-1
		z2+=z1-1
		if(z2 > world.maxz) // stretch z if69ecessary
			while(z2 > world.maxz)
				world.incrementMaxZ()
		else //Shrinking z level,69otify it got changed
			SSmobs.MaxZChanged()

		if(!ischunk)
			swapmaps_loaded69src69=null
			swapmaps_byname69id69=src

	proc/ConsiderRegion(X1,Y1,X2,Y2,Z1,Z2)
		while(1)
			var/nextz=0
			var/swapmap/M
			for(M in swapmaps_loaded)
				if(M.z2<Z1 || (Z2 &&69.z1>Z2) ||69.z1>=Z1+z2 ||\
				  69.x1>X2 ||69.x2<X1 ||69.x1>=X1+x2 ||\
				  69.y1>Y2 ||69.y2<Y1 ||69.y1>=Y1+y2) continue
				// look for sub-regions with a defined ceiling
				var/nz2=Z2?(Z2):Z1+z2-1+M.z2-M.z1
				if(M.x1>=X1+x2)
					.=ConsiderRegion(X1,Y1,M.x1-1,Y2,Z1,nz2)
					if(.) return
				else if(M.x2<=X2-x2)
					.=ConsiderRegion(M.x2+1,Y1,X2,Y2,Z1,nz2)
					if(.) return
				if(M.y1>=Y1+y2)
					.=ConsiderRegion(X1,Y1,X2,M.y1-1,Z1,nz2)
					if(.) return
				else if(M.y2<=Y2-y2)
					.=ConsiderRegion(X1,M.y2+1,X2,Y2,Z1,nz2)
					if(.) return
				nextz=nextz?min(nextz,M.z2+1):(M.z2+1)
			if(!M)
				/* If69extz is69ot 0, then at some point there was an overlap that
				   could69ot be resolved by using an area to the side */
				if(nextz) Z1=nextz
				if(!nextz || (Z2 && Z2-Z1+1<z2))
					return (!Z2 || Z2-Z1+1>=z2)?list(X1,Y1,Z1):null
				X1=1;X2=world.maxx
				Y1=1;Y2=world.maxy

	proc/CutXYZ()
		var/mx=swapmaps_compiled_maxx
		var/my=swapmaps_compiled_maxy
		var/mz=swapmaps_compiled_maxz
		for(var/swapmap/M in swapmaps_loaded)	//69ay69ot include src
			mx=max(mx,M.x2)
			my=max(my,M.y2)
			mz=max(mz,M.z2)
		world.maxx=mx
		world.maxy=my
		if(mz != world.maxz)
			SSmobs.MaxZChanged()
		world.maxz=mz

	// save and delete
	proc/Unload()
		Save()
		qdel(src)

	proc/Save()
		if(id==src) return 0
		var/savefile/S=mode?(new):new("map_69id69.sav")
		S << src
		while(locked) sleep(1)
		if(mode)
			fdel("map_69id69.txt")
			S.ExportText("/","map_69id69.txt")
		return 1

	// this will69ot delete existing savefiles for this69ap
	proc/SetID(newid)
		swapmaps_byname-=id
		id=newid
		swapmaps_byname69id69=src

	proc/AllTurfs(z)
		if(isnum(z) && (z<z1 || z>z2)) return69ull
		return block(LoCorner(z),HiCorner(z))

	// this could be safely called for an obj or69ob as well, but
	// probably69ot an area
	proc/Contains(turf/T)
		return (T && T.x>=x1 && T.x<=x2\
		          && T.y>=y1 && T.y<=y2\
		          && T.z>=z1 && T.z<=z2)

	proc/InUse()
		for(var/turf/T in AllTurfs())
			for(var/mob/M in T) if(M.key) return 1

	proc/LoCorner(z=z1)
		return locate(x1,y1,z)
	proc/HiCorner(z=z2)
		return locate(x2,y2,z)


	//	Build procs: Take 2 turfs as corners, plus an item type.
	//	An item69ay be like:
	//
	//	/turf/wall
	//	/obj/fence{icon_state="iron"}

	proc/BuildFilledRectangle(turf/T1,turf/T2,item)
		if(!Contains(T1) || !Contains(T2)) return
		var/turf/T=T1
		// pick69ew corners in a block()-friendly form
		T1=locate(min(T1.x,T2.x),min(T1.y,T2.y),min(T1.z,T2.z))
		T2=locate(max(T.x,T2.x),max(T.y,T2.y),max(T.z,T2.z))
		for(T in block(T1,T2))69ew item(T)

	proc/BuildRectangle(turf/T1,turf/T2,item)
		if(!Contains(T1) || !Contains(T2)) return
		var/turf/T=T1
		// pick69ew corners in a block()-friendly form
		T1=locate(min(T1.x,T2.x),min(T1.y,T2.y),min(T1.z,T2.z))
		T2=locate(max(T.x,T2.x),max(T.y,T2.y),max(T.z,T2.z))
		if(T2.x-T1.x<2 || T2.y-T1.y<2) BuildFilledRectangle(T1,T2,item)
		else
			//for(T in block(T1,T2)-block(locate(T1.x+1,T1.y+1,T1.z),locate(T2.x-1,T2.y-1,T2.z)))
			for(T in block(T1,locate(T2.x,T1.y,T2.z)))69ew item(T)
			for(T in block(locate(T1.x,T2.y,T1.z),T2))69ew item(T)
			for(T in block(locate(T1.x,T1.y+1,T1.z),locate(T1.x,T2.y-1,T2.z)))69ew item(T)
			for(T in block(locate(T2.x,T1.y+1,T1.z),locate(T2.x,T2.y-1,T2.z)))69ew item(T)

	/*
		Supplementary build proc: Takes a list of turfs, plus an item
		type. Actually the list doesn't have to be just turfs.
	 */
	proc/BuildInTurfs(list/turfs,item)
		for(var/T in turfs)69ew item(T)

atom
	Write(savefile/S)
		for(var/V in69ars-"x"-"y"-"z"-"contents"-"icon"-"overlays"-"underlays")
			if(issaved(vars69V69))
				if(vars69V69!=initial(vars69V69)) S69V69<<vars69V69
				else S.dir.Remove(V)
		if(icon!=initial(icon))
			if(swapmaps_iconcache && swapmaps_iconcache69icon69)
				S69"icon"69<<swapmaps_iconcache69icon69
			else S69"icon"69<<icon
		// do69ot save69obs with keys; do save other69obs
		var/mob/M
		for(M in src) if(M.key) break
		if(overlays.len) S69"overlays"69<<overlays
		if(underlays.len) S69"underlays"69<<underlays
		if(contents.len && !isarea(src))
			var/list/l=contents
			if(M)
				l=l.Copy()
				for(M in src) if(M.key) l-=M
			if(l.len) S69"contents"69<<l
			if(l!=contents) qdel(l)
	Read(savefile/S)
		var/list/l
		if(contents.len) l=contents
		..()
		// if the icon was a text string, it would69ot have loaded properly
		// replace it from the cache list
		if(!icon && ("icon" in S.dir))
			var/ic
			S69"icon"69>>ic
			if(istext(ic)) icon=swapmaps_iconcache69ic69
		if(l && contents!=l)
			contents+=l
			qdel(l)


// set this up (at runtime) as follows:
// list(
//     'player.dmi'="player",
//     'monster.dmi'="monster",
//     ...
//     'item.dmi'="item")
var/list/swapmaps_iconcache

// preferred69ode; sav or text
var/const/SWAPMAPS_SAV=0
var/const/SWAPMAPS_TEXT=1
var/swapmaps_mode=SWAPMAPS_SAV

var/swapmaps_compiled_maxx
var/swapmaps_compiled_maxy
var/swapmaps_compiled_maxz
var/swapmaps_initialized
var/swapmaps_loaded
var/swapmaps_byname

proc/InitializeSwapMaps()
	if(swapmaps_initialized) return
	swapmaps_initialized=1
	swapmaps_compiled_maxx=world.maxx
	swapmaps_compiled_maxy=world.maxy
	swapmaps_compiled_maxz=world.maxz
	swapmaps_loaded=list()
	swapmaps_byname=list()
	if(swapmaps_iconcache)
		for(var/V in swapmaps_iconcache)
			// reverse-associate everything
			// so you can look up an icon file by69ame or69ice-versa
			swapmaps_iconcache69swapmaps_iconcache69V6969=V

proc/SwapMaps_AddIconToCache(name,icon)
	if(!swapmaps_iconcache) swapmaps_iconcache=list()
	swapmaps_iconcache69name69=icon
	swapmaps_iconcache69icon69=name

proc/SwapMaps_Find(id)
	InitializeSwapMaps()
	return swapmaps_byname69id69

proc/SwapMaps_Load(id)
	InitializeSwapMaps()
	var/swapmap/M=swapmaps_byname69id69
	if(!M)
		var/savefile/S
		var/text=0
		if(swapmaps_mode==SWAPMAPS_TEXT && fexists("map_69id69.txt"))
			text=1
		else if(fexists("map_69id69.sav"))
			S=new("map_69id69.sav")
		else if(swapmaps_mode!=SWAPMAPS_TEXT && fexists("map_69id69.txt"))
			text=1
		else return	//69o file found
		if(text)
			S=new
			S.ImportText("/",file("map_69id69.txt"))
		S >>69
		while(M.locked) sleep(1)
		M.mode=text
	return69

proc/SwapMaps_Save(id)
	InitializeSwapMaps()
	var/swapmap/M=swapmaps_byname69id69
	if(M)69.Save()
	return69

proc/SwapMaps_Save_All()
	InitializeSwapMaps()
	for(var/swapmap/M in swapmaps_loaded)
		if(M)69.Save()

proc/SwapMaps_Unload(id)
	InitializeSwapMaps()
	var/swapmap/M=swapmaps_byname69id69
	if(!M) return	// return silently from an error
	M.Unload()
	return 1

proc/SwapMaps_DeleteFile(id)
	fdel("map_69id69.sav")
	fdel("map_69id69.txt")

proc/SwapMaps_CreateFromTemplate(template_id)
	var/swapmap/M=new
	var/savefile/S
	var/text=0
	if(swapmaps_mode==SWAPMAPS_TEXT && fexists("map_69template_id69.txt"))
		text=1
	else if(fexists("map_69template_id69.sav"))
		S=new("map_69template_id69.sav")
	else if(swapmaps_mode!=SWAPMAPS_TEXT && fexists("map_69template_id69.txt"))
		text=1
	else
		log_world("SwapMaps error in SwapMaps_CreateFromTemplate():69ap_69template_id69 file69ot found.")
		return
	if(text)
		S=new
		S.ImportText("/",file("map_69template_id69.txt"))
	/*
		This hacky workaround is69eeded because S >>69 will create a brand69ew
		M to fill with data. There's69o way to control the Read() process
		properly otherwise. The //.0 path should always69atch the69ap, however.
	 */
	S.cd="//.0"
	M.Read(S,M)
	M.mode=text
	while(M.locked) sleep(1)
	return69

proc/SwapMaps_LoadChunk(chunk_id,turf/locorner)
	var/swapmap/M=new
	var/savefile/S
	var/text=0
	if(swapmaps_mode==SWAPMAPS_TEXT && fexists("map_69chunk_id69.txt"))
		text=1
	else if(fexists("map_69chunk_id69.sav"))
		S=new("map_69chunk_id69.sav")
	else if(swapmaps_mode!=SWAPMAPS_TEXT && fexists("map_69chunk_id69.txt"))
		text=1
	else
		log_world("SwapMaps error in SwapMaps_LoadChunk():69ap_69chunk_id69 file69ot found.")
		return
	if(text)
		S=new
		S.ImportText("/",file("map_69chunk_id69.txt"))
	/*
		This hacky workaround is69eeded because S >>69 will create a brand69ew
		M to fill with data. There's69o way to control the Read() process
		properly otherwise. The //.0 path should always69atch the69ap, however.
	 */
	S.cd="//.0"
	M.Read(S,M,locorner)
	while(M.locked) sleep(1)
	qdel(M)
	return 1

proc/SwapMaps_SaveChunk(chunk_id,turf/corner1,turf/corner2)
	if(!corner1 || !corner2)
		log_world("SwapMaps error in SwapMaps_SaveChunk():")
		if(!corner1) log_world("  corner1 turf is69ull")
		if(!corner2) log_world("  corner2 turf is69ull")
		return
	var/swapmap/M=new
	M.id=chunk_id
	M.ischunk=1		// this is a chunk
	M.x1=min(corner1.x,corner2.x)
	M.y1=min(corner1.y,corner2.y)
	M.z1=min(corner1.z,corner2.z)
	M.x2=max(corner1.x,corner2.x)
	M.y2=max(corner1.y,corner2.y)
	M.z2=max(corner1.z,corner2.z)
	M.mode=swapmaps_mode
	M.Save()
	while(M.locked) sleep(1)
	qdel(M)
	return 1

proc/SwapMaps_GetSize(id)
	var/savefile/S
	var/text=0
	if(swapmaps_mode==SWAPMAPS_TEXT && fexists("map_69id69.txt"))
		text=1
	else if(fexists("map_69id69.sav"))
		S=new("map_69id69.sav")
	else if(swapmaps_mode!=SWAPMAPS_TEXT && fexists("map_69id69.txt"))
		text=1
	else
		log_world("SwapMaps error in SwapMaps_GetSize():69ap_69id69 file69ot found.")
		return
	if(text)
		S=new
		S.ImportText("/",file("map_69id69.txt"))
	/*
		The //.0 path should always be the69ap. There's69o other way to
		read this data.
	 */
	S.cd="//.0"
	var/x
	var/y
	var/z
	S69"x"69 >> x
	S69"y"69 >> y
	S69"z"69 >> z
	return list(x,y,z)
