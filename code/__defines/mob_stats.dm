#define STAT_VALUE_DEFAULT				0

#define STAT_MEC						"Mechanical"
#define STAT_COG						"Cognition"
#define STAT_BIO						"Biology"
#define STAT_ROB						"Robustness"
#define STAT_TGH						"Toughness"
#define STAT_VIG						"Vigilance"

#define ALL_STATS	list(STAT_MEC,STAT_COG,STAT_BIO,STAT_ROB,STAT_TGH,STAT_VIG)

#define STAT_LEVEL_NONE     0
#define STAT_LEVEL_BASIC    15
#define STAT_LEVEL_ADEPT    25
#define STAT_LEVEL_EXPERT   40
#define STAT_LEVEL_PROF     60

#define STAT_LEVEL_MIN      0 // Min stat value selectable
#define STAT_LEVEL_MAX      60 // Max stat value selectable


//Compound stat checks. These tell the getStat function how to combine multiple stats
#define STAT_MAX	"max"	//Get the highest value among the stats passed in
#define STAT_MIN	"min"	//Lowest value among the stats passed in
#define STAT_AVG	"avg"	//Get the average (mean) value of the stats
#define STAT_SUM	"sum" 	//Sum total of the stats