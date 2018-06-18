//Defines for atom layers and planes
//KEEP THESE IN A NICE ACSCENDING ORDER, PLEASE

#define CLICKCATCHER_PLANE -99

#define PLANE_SPACE -95
#define PLANE_SPACE_PARALLAX -90

#define OPENSPACE_PLANE -10
#define OVER_OPENSPACE_PLANE -8

#define FLOOR_PLANE -2
#define GAME_PLANE -1
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
#define WIRE_LAYER 2.4
#define WIRE_TERMINAL_LAYER 2.45
#define GAS_SCRUBBER_LAYER 2.46
#define GAS_PIPE_VISIBLE_LAYER 2.47
#define GAS_FILTER_LAYER 2.48
#define GAS_PUMP_LAYER 2.49
#define LOW_OBJ_LAYER 2.5

#define BELOW_OPEN_DOOR_LAYER 2.6


#define DOOR_OPEN_LAYER 2.7		//Under all objects if opened. 2.7 due to tables being at 2.6
#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed

#define LIGHTING_PLANE 15
#define LIGHTING_LAYER 15

#define ABOVE_LIGHTING_PLANE 16
#define ABOVE_LIGHTING_LAYER 16

#define BYOND_LIGHTING_PLANE 17
#define BYOND_LIGHTING_LAYER 17

//HUD layer defines

#define FULLSCREEN_PLANE 18

#define FULLSCREEN_LAYER 18.1

#define HUD_PLANE 19
#define HUD_LAYER 19
#define ABOVE_HUD_PLANE 20
#define ABOVE_HUD_LAYER 20



// Custom layer definitions, supplementing the default TURF_LAYER, MOB_LAYER, etc.
#define OBFUSCATION_LAYER 21	//Where images covering the view for eyes are put
#define SCREEN_LAYER 22			//Mob HUD/effects layer


