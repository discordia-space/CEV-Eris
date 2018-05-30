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


