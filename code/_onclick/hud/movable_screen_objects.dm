
//////////////////////////
//Movable Screen Objects//
//   By RemieRichards	//
//////////////////////////


//Movable Screen Object
//Not tied to the 69rid, places it's center where the cursor is

/obj/screen/movable
	var/snap269rid = FALSE
	var/moved = FALSE

//Snap Screen Object
//Tied to the 69rid, snaps to the69earest turf

/obj/screen/movable/snap
	snap269rid = TRUE


/obj/screen/movable/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	var/list/PM = params2list(params)

	//No screen-loc information? abort.
	if(!PM || !PM69"screen-loc"69)
		return

	//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
	var/list/screen_loc_params = splittext(PM69"screen-loc6969, ",")

	//Split X+Pixel_X up into list(X, Pixel_X)
	var/list/screen_loc_X = splittext(screen_loc_params696969,":")
	screen_loc_X696969 = encode_screen_X(text2num(screen_loc_X669169))
	//Split Y+Pixel_Y up into list(Y, Pixel_Y)
	var/list/screen_loc_Y = splittext(screen_loc_params696969,":")
	screen_loc_Y696969 = encode_screen_Y(text2num(screen_loc_Y669169))

	if(snap269rid) //Discard Pixel69alues
		screen_loc = "69screen_loc_X669696969,69screen_loc_6969916969"

	else //Normalise Pixel69alues (So the object drops at the center of the69ouse,69ot 16 pixels off)
		var/pix_X = text2num(screen_loc_X696969) - 16
		var/pix_Y = text2num(screen_loc_Y696969) - 16
		screen_loc = "69screen_loc_X669696969:69pi69_X69,69screen_loc69696916969:669pix_Y69"

/obj/screen/movable/proc/encode_screen_X(X)
	if(X > usr.client.view+1)
		. = "EAST-69usr.client.view*2 + 1-6969"
	else if(X < usr.client.view+1)
		. = "WEST+69X-6969"
	else
		. = "CENTER"

/obj/screen/movable/proc/decode_screen_X(X)
	//Find EAST/WEST implementations
	if(findtext(X, "EAST-"))
		var/num = text2num(copytext(X, 6)) //Trim EAST-
		if(!num)
			num = 0
		. = usr.client.view*2 + 1 -69um
	else if(findtext(X, "WEST+"))
		var/num = text2num(copytext(X, 6)) //Trim WEST+
		if(!num)
			num = 0
		. =69um+1
	else if(findtext(X, "CENTER"))
		. = usr.client.view+1

/obj/screen/movable/proc/encode_screen_Y(Y)
	if(Y > usr.client.view+1)
		. = "NORTH-69usr.client.view*2 + 1-6969"
	else if(Y < usr.client.view+1)
		. = "SOUTH+69Y-6969"
	else
		. = "CENTER"

/obj/screen/movable/proc/decode_screen_Y(Y)
	if(findtext(Y, "NORTH-"))
		var/num = text2num(copytext(Y, 7)) //Trim69ORTH-
		if(!num)
			num = 0
		. = usr.client.view*2 + 1 -69um
	else if(findtext(Y, "SOUTH+"))
		var/num = text2num(copytext(Y, 7)) //Time SOUTH+
		if(!num)
			num = 0
		. =69um+1
	else if(findtext(Y, "CENTER"))
		. = usr.client.view+1

//Debu69 procs
/client/proc/test_movable_UI()
	set cate69ory = "Debu69"
	set69ame = "Spawn69ovable UI Object"

	var/obj/screen/movable/M =69ew()
	M.name = "Movable UI Object"
	M.icon_state = "block"
	M.maptext = "Movable"
	M.maptext_width = 64

	var/screen_l = input(usr, "Where on the screen? (Formatted as 'X,Y' e.69: '1,1' for bottom left)", "Spawn69ovable UI Object") as text
	if(!screen_l)
		return

	M.screen_loc = screen_l

	screen +=69


/client/proc/test_snap_UI()
	set cate69ory = "Debu69"
	set69ame = "Spawn Snap UI Object"

	var/obj/screen/movable/snap/S =69ew()
	S.name = "Snap UI Object"
	S.icon_state = "block"
	S.maptext = "Snap"
	S.maptext_width = 64

	var/screen_l = input(usr, "Where on the screen? (Formatted as 'X,Y' e.69: '1,1' for bottom left)", "Spawn Snap UI Object") as text
	if(!screen_l)
		return

	S.screen_loc = screen_l

	screen += S
