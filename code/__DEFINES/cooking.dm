//#define CWJ_DEBUG 1


//Step classifications, for easy reference later.
//If something falls outside these classifications, why would it?
#define CWJ_START 					1		//Default step to construct the list.
#define CWJ_ADD_ITEM 				2		//Adding an item to a recipe (Ex- adding a slice of bread)
#define CWJ_ADD_REAGENT 			3		//Adding a reagent to a recipe (Ex- Adding salt)
#define CWJ_USE_ITEM 				4 		//Using an item in a recipe (Ex- cutting bread with a knife)
#define CWJ_USE_TOOL				5
#define CWJ_ADD_PRODUCE				6		//Adding Produce to a recipe
#define CWJ_USE_STOVE	 			7 		//Using a stove in a recipe
#define CWJ_USE_GRILL	 			8 		//Using a grill in a recipe
#define CWJ_USE_OVEN	 			9 		//Using a oven in a recipe
#define CWJ_USE_OTHER 				10 		//Custom Command flag, will take in argument lists.


//Optional flags
#define CWJ_ADD_ITEM_OPTIONAL		200
#define CWJ_ADD_REAGENT_OPTIONAL	300
#define CWJ_USE_ITEM_OPTIONAL		400
#define CWJ_USE_TOOL_OPTIONAL		500
#define CWJ_ADD_PRODUCE_OPTIONAL	600
#define CWJ_USE_STOVE_OPTIONAL		700
#define CWJ_USE_GRILL_OPTIONAL		800
#define CWJ_USE_OVEN_OPTIONAL		900
#define CWJ_OTHER_OPTIONAL 			1000


#define CWJ_BEGIN_EXCLUSIVE_OPTIONS 10000	//Beginning an exclusive option list
#define CWJ_END_EXCLUSIVE_OPTIONS 	20000	//Ending an exclusive option list
#define CWJ_BEGIN_OPTION_CHAIN 		30000	//Beginning an option chain
#define CWJ_END_OPTION_CHAIN 		40000	//Ending an option chain

//Recipe state flags
#define CWJ_IS_LAST_STEP 			1		//If the step in the recipe is marked as the last step
#define CWJ_IS_OPTIONAL 			2		//If the step in the recipe is marked as 'Optional'
#define CWJ_IS_OPTION_CHAIN 		4		//If the step in the recipe is marked to be part of an option chain.
#define CWJ_IS_EXCLUSIVE 			8		//If the step in the recipe is marked to exclude other options when followed.
#define CWJ_BASE_QUALITY_ENABLED 	16
#define CWJ_MAX_QUALITY_ENABLED 	32

//Check item use flags
#define CWJ_NO_STEPS  	  	1 //The used object has no valid recipe uses
#define CWJ_CHOICE_CANCEL 	2 //The user opted to cancel when given a choice
#define CWJ_SUCCESS 		3 //The user decided to use the item and the step was followed
#define CWJ_PARTIAL_SUCCESS	4 //The user decided to use the item but the qualifications for the step was not fulfilled
#define CWJ_COMPLETE		5 //The meal has been completed!
#define CWJ_LOCKOUT			6 //Someone tried starting the function while a prompt was running. Jerk.
#define CWJ_BURNT			7 //The meal was ruined by burning the food somehow.

#define CWJ_CHECK_INVALID	0
#define CWJ_CHECK_VALID		1
#define CWJ_CHECK_FULL		2 //For reagents, nothing can be added to

//Cooking container types
#define PLATE 			"plate"
#define CUTTING_BOARD	"cutting board"
#define PAN				"pan"
#define POT				"pot"
#define BOWL			"bowl"
#define DF_BASKET		"deep fryer basket"
#define AF_BASKET		"air fryer basket"
#define OVEN			"oven"
#define GRILL			"grill grate"

//Stove temp settings.
#define J_LO "Low"
#define J_MED "Medium"
#define J_HI "High"

//Just a catalog for the cooking catalog
#define CATALOG_COOKING "cooking"

//Burn times for cooking things on a stove.
//Anything put on a stove for this long becomes a burned mess.
#define CWJ_BURN_TIME_LOW		15 MINUTES
#define CWJ_BURN_TIME_MEDIUM	10 MINUTES
#define CWJ_BURN_TIME_HIGH		5 MINUTES

//Ignite times for reagents interacting with a stove.
//The stove will catch fire if left on too long with flammable reagents in any of its holders.
#define CWJ_IGNITE_TIME_LOW		1 HOUR
#define CWJ_IGNITE_TIME_MEDIUM	30 MINUTES
#define CWJ_IGNITE_TIME_HIGH	15 MINUTES

//Determines how much quality is taken from a food each tick when a 'no recipe' response is made.
#define CWJ_BASE_QUAL_REDUCTION 5

//Food Quality Tiers
#define CWJ_QUALITY_GARBAGE			-2
#define CWJ_QUALITY_GROSS			-1.5
#define CWJ_QUALITY_MEH				0.5
#define CWJ_QUALITY_NORMAL			1
#define CWJ_QUALITY_GOOD			1.2
#define CWJ_QUALITY_VERY_GOOD		1.4
#define CWJ_QUALITY_CUISINE			1.6
#define CWJ_QUALITY_LEGENDARY		1.8
#define CWJ_QUALITY_ELDRITCH		2.0
