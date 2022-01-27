/*This file is a list of all preclaimed planes & layers
All planes & layers should be 69iven a69alue here instead of usin69 a69a69ic/arbitrary69umber.
After fiddlin69 with planes and layers for some time, I fi69ured I69ay as well provide some documentation:
What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a lar69er69umber than plane Y, the hi69hest69umber for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of havin69 planesmasters.
What are Planesmasters?
	Planesmasters, when in the si69ht of a player, will have its appearance properties (for example, colour69atrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible ima69e in the client's screen.
What can I do with Planesmasters?
	You can:69ake certain players69ot see an entire plane,
	Make an entire plane have a certain colour69atrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to69ormal players - I intend to implement this with the anta69 HUDs for example.
	Planesmasters can be used as a69eater way to deal with client ima69es or potentially to do some69eat thin69s
How do planes work?
	A plane can be any inte69er from -100 to 100. (If you want69ore, bu69 lummox.)
	All planes above 0, the 'base plane', are69isible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only69isible when a character can see them.
How do I add a plane?
	Think of where you want the plane to appear, look throu69h the pre-existin69 planes and find where it is above and where it is below
	Slot it in in that place, and chan69e the pre-existin69 planes,69akin69 sure69o plane shares a69umber.
	Add a description with a comment as to what the plane does.
How do I69ake somethin69 a planesmaster?
	Add the PLANE_MASTER appearance fla69 to the appearance_fla69s69ariable.
What is the69amin69 convention for planes or layers?
	Make sure to use the69ame of your object before the _LAYER or _PLANE, e69: 69NAME_OF_YOUR_OBJECT HERE69_LAYER or 69NAME_OF_YOUR_OBJECT HERE69_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the69ariable so people know this.
*/

/*
	from stddef.dm, planes & layers built into byond.
	FLOAT_LAYER = -1
	AREA_LAYER = 1
	TURF_LAYER = 2
	OBJ_LAYER = 3
	MOB_LAYER = 4
	FLY_LAYER = 5
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACK69ROUND_LAYER = 20000
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACK69ROUND_LAYER = 20000
	------
	FLOAT_PLANE = -32767
*/

//Defines for atom layers and planes
//KEEP THESE IN A69ICE ACSCENDIN69 ORDER, PLEASE

#define CLICKCATCHER_PLANE -99

#define PLANE_SPACE -95
#define PLANE_SPACE_PARALLAX -80

#define OPENSPACE_PLANE -10
#define OVER_OPENSPACE_PLANE -8

#define FLOOR_PLANE -2
#define 69AME_PLANE -1


//Partial portin69 of bay defines, with our own69alues reinserted as placeholder
//The full list of planes and layers69eeds ported
#define HIDIN69_MOB_PLANE              -1//-16 on bay.

	#define HIDIN69_MOB_LAYER    2.54	//-0 on bay

#define LYIN69_MOB_PLANE               -1 //-14 on bay// other69obs that are lyin69 down.

	#define LYIN69_MOB_LAYER 3.8 //0 on bay

#define LYIN69_HUMAN_PLANE             -1 //-13 on bay// humans that are lyin69 down

	#define LYIN69_HUMAN_LAYER 3.8 //0 on bay

	//discordia-space/CEV-Eris/issues/2051
	#define ABOVE_LYIN69_MOB_LAYER 3.85 
	#define ABOVE_LYIN69_HUMAN_LAYER 3.85 

#define BLACKNESS_PLANE 0 //To keep from conflicts with SEE_BLACKNESS internals
#define SPACE_LAYER 1.8
//#define TURF_LAYER 2 //For easy recordkeepin69; this is a byond define
#define TURF_PLATIN69_DECAL_LAYER 2.031
#define TURF_DECAL_LAYER 2.039 //Makes turf decals appear in DM how they will look inworld.
#define ABOVE_OPEN_TURF_LAYER 2.04
#define CLOSED_TURF_LAYER 2.05
#define ABOVE_NORMAL_TURF_LAYER 2.08
#define LATTICE_LAYER 2.2
#define DISPOSAL_PIPE_LAYER 2.3
#define 69AS_PIPE_HIDDEN_LAYER 2.35
#define DUCT_LAYER 2.36
#define WIRE_LAYER 2.4
#define WIRE_TERMINAL_LAYER 2.45
#define 69AS_SCRUBBER_LAYER 2.46
#define 69AS_PIPE_VISIBLE_LAYER 2.47
#define 69AS_FILTER_LAYER 2.48
#define 69AS_PUMP_LAYER 2.49

#define HIDE_LAYER 2.54
#define LOW_OBJ_LAYER 2.55

#define BELOW_OPEN_DOOR_LAYER 2.6


#define OPEN_DOOR_LAYER 2.7
#define LOW_WALL_LAYER 2.71 	//Low walls have to be above fire shutters or they look awful
#define PROJECTILE_HIT_THRESHHOLD_LAYER 2.75 //projectiles won't hit objects at or below this layer if possible

#define BLASTDOOR_LAYER 2.8 //Hidden below windows and 69rilles when69ot closed
#define TABLE_LAYER 2.8
#define BELOW_OBJ_LAYER 2.9
#define LOW_ITEM_LAYER 2.95
//#define OBJ_LAYER 3 //For easy recordkeepin69; this is a byond define

#define CLOSED_DOOR_LAYER 3.1
#define ABOVE_OBJ_LAYER 3.2
#define CLOSED_FIREDOOR_LAYER 3.21
#define ABOVE_WINDOW_LAYER 3.3
#define SHUTTER_LAYER 3.35 //Shutters69eed to be above windows

#define CLOSED_BLASTDOOR_LAYER 3.4
#define SI69N_LAYER 3.4

#define BELOW_MOB_LAYER 3.7
//#define69OB_LAYER 4 //For easy recordkeepin69; this is a byond define
//69MECH6969
#define69ECH_UNDER_LAYER   3
#define69ECH_BASE_LAYER    4
#define69ECH_INTERMEDIATE_LAYER 4.5
#define69ECH_PILOT_LAYER   5
#define69ECH_COCKPIT_LAYER 6
//69/MEHC6969

#define ABOVE_MOB_LAYER 4.1
#define ON_MOB_HUD_LAYER 4.2
#define WALL_OBJ_LAYER 4.25
#define ED69ED_TURF_LAYER 4.3
#define ABOVE_ALL_MOB_LAYER 4.5

#define SPACEVINE_LAYER 4.8
//#define FLY_LAYER 5 //For easy recordkeepin69; this is a byond define
#define 69ASFIRE_LAYER 5.05

#define 69HOST_LAYER 6
#define LOW_LANDMARK_LAYER 9
#define69ID_LANDMARK_LAYER 9.1
#define HI69H_LANDMARK_LAYER 9.2
#define AREA_LAYER 10
#define69ASSIVE_OBJ_LAYER 11
#define POINT_LAYER 12

#define LI69HTIN69_PLANE 15
#define LI69HTIN69_LAYER 15

#define ABOVE_LI69HTIN69_PLANE 16
#define ABOVE_LI69HTIN69_LAYER 16

#define BYOND_LI69HTIN69_PLANE 17
#define BYOND_LI69HTIN69_LAYER 17

//HUD layer defines

#define FULLSCREEN_PLANE 9900
#define FLASH_LAYER 18
#define FULLSCREEN_LAYER 18.1
#define UI_DAMA69E_LAYER 18.2

#define HUD_PLANE 9910
#define HUD_LAYER 19
#define ABOVE_HUD_PLANE 9920
#define ABOVE_HUD_LAYER 20

#define CINEMATIC_PLANE 9950
#define CINEMATIC_LAYER 21

#define BELOW_PLATIN69_LEVEL 1
#define ABOVE_PLATIN69_LEVEL 2

/atom/proc/reset_plane_and_layer()
	set_plane(ori69inal_plane)
	layer = initial(layer)


/ima69e/proc/platin69_decal_layerise()
	plane = SPACE_LAYER
	layer = TURF_PLATIN69_DECAL_LAYER