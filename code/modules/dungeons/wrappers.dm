/obj/effect/step_trigger/teleporter/random/rogue
	teleport_z = 7
	teleport_z_offset = 7

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour
	var/margin = 15 //How far from the side should we teleport? Make sure to place the opposite
					//side's wrappers at less than this far from the hard boundary
					//else people will get stuck in the margins
					//Important for auto-determining the size, as well.

	var/mapsize = 300 //I don't know of a way to obtain map size sorry.

	//Important infos!
	var/quad_L
	var/quad_R
	var/quad_U
	var/quad_D

	//Relative to the quadrant
	var/rel_x
	var/rel_y

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/New()
	..()


	//Figure out where I am on the map and set up vars.
	if(x < mapsize/2 && y < mapsize/2) //We're in area 1!
		quad_L = 0
		quad_R = mapsize/2
		quad_U = mapsize/2
		quad_D = 0
		rel_x = x
		rel_y = y
	else if(x >= mapsize/2 && y < mapsize/2) //We're in area 2!
		quad_L = mapsize/2
		quad_R = mapsize
		quad_U = mapsize/2
		quad_D = 0
		rel_x = x-(mapsize/2)
		rel_y = y
	else if(x < mapsize/2 && y >= mapsize/2) //We're in area 3!
		quad_L = 0
		quad_R = mapsize/2
		quad_U = mapsize
		quad_D = mapsize/2
		rel_x = x
		rel_y = y-(mapsize/2)
	else if(x >= mapsize/2 && y >= mapsize/2) //We're in area 4!
		quad_L = mapsize/2
		quad_R = mapsize
		quad_U = mapsize
		quad_D = mapsize/2
		rel_x = x-(mapsize/2)
		rel_y = y-(mapsize/2)
	else
		return

//These are placed ON the side they are named after.
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/onleft/New()
	..()
	teleport_x = quad_R - margin
	teleport_x_offset = quad_R - margin
	teleport_y = quad_D + margin
	teleport_y_offset = quad_U - margin

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/onright/New()
	..()
	teleport_x = quad_L + margin
	teleport_x_offset = quad_L + margin
	teleport_y = quad_D + margin
	teleport_y_offset = quad_U - margin

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/ontop/New()
	..()
	teleport_x = quad_L + margin
	teleport_x_offset = quad_R - margin
	teleport_y = quad_D + margin
	teleport_y_offset = quad_D + margin

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/onbottom/New()
	..()
	teleport_x = quad_L + margin
	teleport_x_offset = quad_R - margin
	teleport_y = quad_U - margin
	teleport_y_offset = quad_U - margin

//Sure, I could probably do this with math. But I'm tired.
/*
         S1      300
 -----------------------------------
 |015/285  135/285|166/285  285/285|
 |                |                |S
 |       A3       |       A4       |2
 |                |                |
0|015/166  135/166|166/166  285/166|3
0|---------------------------------|0
0|015/135  135/135|166/135  285/135|0
 |                |                |
S|       A1       |       A2       |
4|                |                |
 |015/015  135/015|166/015  285/015|
 -----------------------------------
                 000      S3
*/
/*
//////////// AREA 1
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S1
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S2
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S3
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S4
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

//////////// AREA 2
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S1
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S2
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S3
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S4
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

//////////// AREA 3
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S1
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S2
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S3
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S4
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

//////////// AREA 4
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S1
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S2
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S3
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S4
	teleport_x =
	teleport_y =
	teleport_x_offset =
	teleport_y_offset =
*/