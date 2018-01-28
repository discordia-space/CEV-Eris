#define QUALITY_BOLT_TURNING			"bolt turning"
#define QUALITY_PRYING					"prying"
#define QUALITY_WELDING					"welding"
#define QUALITY_SCREW_DRIVING			"screw driving"
#define QUALITY_COMPRESSING				"compressing"
#define QUALITY_CAUTERIZING				"cauterizing"
#define QUALITY_RETRACTING				"retracting"
#define QUALITY_DRILLING				"drilling"
#define QUALITY_SAWING					"sawing"
#define QUALITY_BONE_SETTING			"bone setting"
#define QUALITY_VEIN_FIXING				"vein fixing"
#define QUALITY_BONE_FIXING				"bone fixing"
#define QUALITY_SHOVELING				"shoveling"
#define QUALITY_DIGGING					"digging"
#define QUALITY_CUTTING					"cutting"

//Remember that base time devided by tool level, which is 3 for base tools
#define WORKTIME_NEAR_INSTANT			60
#define WORKTIME_FAST					100
#define WORKTIME_NORMAL					200
#define WORKTIME_SLOW					300
#define WORKTIME_LONG					500
#define WORKTIME_EXTREMELY_LONG			800

//Fail chance for tool system calculated in that way: basic chance - tool level * 10. It means that basic tools will have -30% chance to fail
#define FAILCHANCE_VERY_EASY			20
#define FAILCHANCE_EASY					30
#define FAILCHANCE_NORMAL				40
#define FAILCHANCE_HARD					50
#define FAILCHANCE_CHALLENGING			60
#define FAILCHANCE_VERY_HARD			70
#define FAILCHANCE_IMPOSSIBLY			100
