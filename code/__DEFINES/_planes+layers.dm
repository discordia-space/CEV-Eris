/*This file is a list of all preclaimed planes & layers
All planes & layers should be given a value here instead of using a magic/arbitrary number.
After fiddling with planes and layers for some time, I figured I may as well provide some documentation:
What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of having planesmasters.
What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.
What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things
How do planes work?
	A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.
How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.
How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.
What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.
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
	BACKGROUND_LAYER = 20000
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	------
	FLOAT_PLANE = -32767
*/

//Defines for atom layers and planes
//KEEP THESE IN A NICE ACSCENDING ORDER, PLEASE

#define CLICKCATCHER_PLANE -99

#define PLANE_SPACE -95
#define PLANE_SPACE_PARALLAX -80

#define OPENSPACE_PLANE -10
#define OVER_OPENSPACE_PLANE -8

#define FLOOR_PLANE -2
#define GAME_PLANE -1


//Partial porting of bay defines, with our own values reinserted as placeholder
//The full list of planes and layers needs ported
#define HIDING_MOB_PLANE              -1//-16 on bay.

#define HIDING_MOB_LAYER    2.54	//-0 on bay

#define LYING_MOB_PLANE               -1 //-14 on bay// other mobs that are lying down.

#define LYING_MOB_LAYER 3.8 //0 on bay

#define LYING_HUMAN_PLANE             -1 //-13 on bay// humans that are lying down

#define LYING_HUMAN_LAYER 3.8 //0 on bay

//discordia-space/CEV-Eris/issues/2051
#define ABOVE_LYING_MOB_LAYER 3.85
#define ABOVE_LYING_HUMAN_LAYER 3.85

#define BLACKNESS_PLANE 0 //To keep from conflicts with SEE_BLACKNESS internals
#define SPACE_LAYER 1.8
//#define TURF_LAYER 2 //For easy recordkeeping; this is a byond define
#define TURF_PLATING_DECAL_LAYER 2.031
#define TURF_DECAL_LAYER 2.039 //Makes turf decals appear in DM how they will look inworld.
#define ABOVE_OPEN_TURF_LAYER 2.04
#define CLOSED_TURF_LAYER 2.05
#define ABOVE_NORMAL_TURF_LAYER 2.08
#define LATTICE_LAYER 2.2
#define DISPOSAL_PIPE_LAYER 2.3
#define GAS_PIPE_HIDDEN_LAYER 2.35
#define DUCT_LAYER 2.36
#define WIRE_LAYER 2.4
#define WIRE_TERMINAL_LAYER 2.45
#define GAS_SCRUBBER_LAYER 2.46
#define GAS_PIPE_VISIBLE_LAYER 2.47
#define GAS_FILTER_LAYER 2.48
#define GAS_PUMP_LAYER 2.49

#define HIDE_LAYER 2.54
#define LOW_OBJ_LAYER 2.55

#define BELOW_OPEN_DOOR_LAYER 2.6


#define OPEN_DOOR_LAYER 2.7
#define LOW_WALL_LAYER 2.71 	//Low walls have to be above fire shutters or they look awful
#define PROJECTILE_HIT_THRESHHOLD_LAYER 2.75 //projectiles won't hit objects at or below this layer if possible

#define BLASTDOOR_LAYER 2.8 //Hidden below windows and grilles when not closed
#define TABLE_LAYER 2.8
#define BELOW_OBJ_LAYER 2.9
#define LOW_ITEM_LAYER 2.95
//#define OBJ_LAYER 3 //For easy recordkeeping; this is a byond define

#define TOP_ITEM_LAYER 3.05
#define CLOSED_DOOR_LAYER 3.1
#define ABOVE_OBJ_LAYER 3.2
#define CLOSED_FIREDOOR_LAYER 3.21
#define ABOVE_WINDOW_LAYER 3.3
#define SHUTTER_LAYER 3.35 //Shutters need to be above windows

#define CLOSED_BLASTDOOR_LAYER 3.4
#define SIGN_LAYER 3.4

#define BELOW_MOB_LAYER 3.7
//#define MOB_LAYER 4 //For easy recordkeeping; this is a byond define
//[MECHS]
#define MECH_UNDER_LAYER   3
#define MECH_BASE_LAYER    4
#define MECH_INTERMEDIATE_LAYER 4.5
#define MECH_PILOT_LAYER   5
#define MECH_COCKPIT_LAYER 6
#define MECH_ABOVE_LAYER 7
//[/MEHCS]

#define ABOVE_MOB_LAYER 4.1
#define ON_MOB_HUD_LAYER 4.2
#define WALL_OBJ_LAYER 4.25
#define EDGED_TURF_LAYER 4.3
#define ABOVE_ALL_MOB_LAYER 4.5

#define SPACEVINE_LAYER 4.8
//#define FLY_LAYER 5 //For easy recordkeeping; this is a byond define
#define GASFIRE_LAYER 5.05

#define GHOST_LAYER 6
#define LOW_LANDMARK_LAYER 9
#define MID_LANDMARK_LAYER 9.1
#define HIGH_LANDMARK_LAYER 9.2
#define AREA_LAYER 10
#define MASSIVE_OBJ_LAYER 11
#define POINT_LAYER 12

#define LIGHTING_PLANE 15
#define LIGHTING_LAYER 15

#define ABOVE_LIGHTING_PLANE 16
#define ABOVE_LIGHTING_LAYER 16

#define BYOND_LIGHTING_PLANE 17
#define BYOND_LIGHTING_LAYER 17

//HUD layer defines

#define FULLSCREEN_PLANE 9900
#define FLASH_LAYER 18
#define FULLSCREEN_LAYER 18.1
#define UI_DAMAGE_LAYER 18.2

#define HUD_PLANE 9910
#define HUD_LAYER 19
#define ABOVE_HUD_PLANE 9920
#define ABOVE_HUD_LAYER 20

#define CINEMATIC_PLANE 9950
#define CINEMATIC_LAYER 21

#define BELOW_PLATING_LEVEL 1
#define ABOVE_PLATING_LEVEL 2

/atom/proc/reset_plane_and_layer()
	if(!(atomFlags & AF_PLANE_UPDATE_HANDLED))
		set_plane(original_plane)
	if(!(atomFlags & AF_LAYER_UPDATE_HANDLED))
		layer = initial(layer)


/image/proc/plating_decal_layerise()
	plane = SPACE_LAYER
	layer = TURF_PLATING_DECAL_LAYER
