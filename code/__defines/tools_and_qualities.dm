#define ABORT_CHECK						-1
#define TOOL_USE_FAIL					-1
#define TOOL_USE_CANCEL					0
#define TOOL_USE_SUCCESS				1

#define QUALITY_BOLT_TURNING			"bolt turning"
#define QUALITY_PULSING					"pulsing"
#define QUALITY_PRYING					"prying"
#define QUALITY_WELDING					"welding"
#define QUALITY_SCREW_DRIVING			"screw driving"
#define QUALITY_WIRE_CUTTING			"wire cutting"
#define QUALITY_COMPRESSING				"compressing"
#define QUALITY_CAUTERIZING				"cauterizing"
#define QUALITY_RETRACTING				"retracting"
#define QUALITY_DRILLING				"drilling"
#define QUALITY_SAWING					"sawing"
#define QUALITY_BONE_SETTING			"bone setting"
#define QUALITY_SHOVELING				"shoveling"
#define QUALITY_DIGGING					"digging"
#define QUALITY_EXCAVATION				"excavation"
#define QUALITY_CUTTING					"cutting"
#define QUALITY_LASER_CUTTING			"laser cutting"	//laser scalpels and e-swords - bloodless cutting

//Remember that base time devided by tool level, which is 3 for base tools
#define WORKTIME_INSTANT				0
#define WORKTIME_NEAR_INSTANT			20
#define WORKTIME_FAST					40
#define WORKTIME_NORMAL					80
#define WORKTIME_SLOW					100
#define WORKTIME_LONG					150
#define WORKTIME_EXTREMELY_LONG			200

//Fail chance for tool system calculated in that way: basic chance - tool level * 10. It means that basic tools will have -30% chance to fail
#define FAILCHANCE_VERY_EASY			20
#define FAILCHANCE_EASY					30
#define FAILCHANCE_NORMAL				40
#define FAILCHANCE_HARD					50
#define FAILCHANCE_CHALLENGING			60
#define FAILCHANCE_VERY_HARD			70
#define FAILCHANCE_IMPOSSIBLY			100

//Sounds for workong with tools
#define NO_WORKSOUND					-1

#define WORKSOUND_CIRCULAR_SAW			'sound/weapons/circsawhit.ogg'
#define WORKSOUND_SIMPLE_SAW			'sound/weapons/saw.ogg'
#define WORKSOUND_WRENCHING				'sound/items/Ratchet.ogg'
#define WORKSOUND_WIRECUTTING			'sound/items/Wirecutter.ogg'
#define WORKSOUND_WELDING				'sound/items/Welder.ogg'
#define WORKSOUND_PULSING				'sound/items/multitool_pulse.ogg'
#define WORKSOUND_SCREW_DRIVING			'sound/items/Screwdriver.ogg'
#define WORKSOUND_EASY_CROWBAR			'sound/items/Crowbar.ogg'
#define WORKSOUND_REMOVING				'sound/items/Deconstruct.ogg'
#define WORKSOUND_DRIVER_TOOL			'sound/items/e_screwdriver.ogg'
#define WORKSOUND_PICKAXE				'sound/items/pickaxe.ogg'
#define WORKSOUND_HARD_SLASH			'sound/weapons/bladeslice.ogg.ogg'
