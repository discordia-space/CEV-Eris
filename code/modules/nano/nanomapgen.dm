// This file is a69odified69ersion of https://raw2.github.com/Baystation12/OldCode-BS12/master/code/TakePicture.dm

#define69ANOMAP_ICON_SIZE 4
#define69ANOMAP_MAX_ICON_DIMENSION 1024

#define69ANOMAP_TILES_PER_IMAGE (NANOMAP_MAX_ICON_DIMENSION /69ANOMAP_ICON_SIZE)

#define69ANOMAP_TERMINALERR 5
#define69ANOMAP_INPROGRESS 2
#define69ANOMAP_BADOUTPUT 2
#define69ANOMAP_SUCCESS 1
#define69ANOMAP_WATCHDOGSUCCESS 4
#define69ANOMAP_WATCHDOGTERMINATE 3


//Call these procs to dump your world to a series of image files (!!)
//NOTE: Does69ot explicitly support69on 32x32 icons or stuff with large pixel_*69alues, so don't blame69e if it doesn't work perfectly

/client/proc/nanomapgen_DumpImage()
	set69ame = "Generate69anoUI69ap"
	set category = "Server"

	if(holder)
		nanomapgen_DumpTile(1, 1, text2num(input(usr,"Enter the Z level to generate")))

/client/proc/nanomapgen_DumpTile(var/startX = 1,69ar/startY = 1,69ar/currentZ = 1,69ar/endX = -1,69ar/endY = -1)

	if (endX < 0 || endX > world.maxx)
		endX = world.maxx

	if (endY < 0 || endY > world.maxy)
		endY = world.maxy

	if (currentZ < 0 || currentZ > world.maxz)
		to_chat(usr, "NanoMapGen: <B>ERROR: currentZ (69currentZ69)69ust be between 1 and 69world.maxz69</B>")

		sleep(3)
		return69ANOMAP_TERMINALERR

	if (startX > endX)
		to_chat(usr, "NanoMapGen: <B>ERROR: startX (69startX69) cannot be greater than endX (69endX69)</B>")

		sleep(3)
		return69ANOMAP_TERMINALERR

	if (startY > endX)
		to_chat(usr, "NanoMapGen: <B>ERROR: startY (69startY69) cannot be greater than endY (69endY69)</B>")
		sleep(3)
		return69ANOMAP_TERMINALERR

	var/icon/Tile = icon(file("nano/mapbase1024.png"))
	if (Tile.Width() !=69ANOMAP_MAX_ICON_DIMENSION || Tile.Height() !=69ANOMAP_MAX_ICON_DIMENSION)
		world.log << "NanoMapGen: <B>ERROR: BASE IMAGE DIMENSIONS ARE69OT 69NANOMAP_MAX_ICON_DIMENSION69x69NANOMAP_MAX_ICON_DIMENSION69</B>"
		sleep(3)
		return69ANOMAP_TERMINALERR

	log_world("NanoMapGen: <B>GENERATE69AP (69startX69,69startY69,69currentZ69) to (69endX69,69endY69,69currentZ69)</B>")
	to_chat(usr, "NanoMapGen: <B>GENERATE69AP (69startX69,69startY69,69currentZ69) to (69endX69,69endY69,69currentZ69)</B>")

	var/count = 0;
	for(var/WorldX = startX, WorldX <= endX, WorldX++)
		for(var/WorldY = startY, WorldY <= endY, WorldY++)

			var/atom/Turf = locate(WorldX, WorldY, currentZ)

			var/icon/TurfIcon =69ew(Turf.icon, Turf.icon_state, dir = Turf.dir)
			TurfIcon.Scale(NANOMAP_ICON_SIZE,69ANOMAP_ICON_SIZE)

			Tile.Blend(TurfIcon, ICON_OVERLAY, ((WorldX - 1) *69ANOMAP_ICON_SIZE), ((WorldY - 1) *69ANOMAP_ICON_SIZE))

			count++

			if (count % 8000 == 0)
				world.log << "NanoMapGen: <B>69count69 tiles done</B>"
				sleep(1)

	var/mapFilename = "new_69map_image_file_name(currentZ)69"

	log_world("NanoMapGen: <B>sending 69mapFilename69 to client</B>")

	usr << browse(Tile, "window=picture;file=69mapFilename69;display=0")

	log_world("NanoMapGen: <B>Done.</B>")

	to_chat(usr, "NanoMapGen: <B>Done. File 69mapFilename69 uploaded to your cache.</B>")

	if (Tile.Width() !=69ANOMAP_MAX_ICON_DIMENSION || Tile.Height() !=69ANOMAP_MAX_ICON_DIMENSION)
		return69ANOMAP_BADOUTPUT

	return69ANOMAP_SUCCESS