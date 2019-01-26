//Defines for wages, prices, and money related things

//Hourly wage defines
#define WAGE_NONE			0	//Unpaid. Assistant, captain, and those who sell things
#define WAGE_LABOUR_DUMB	450 //Dumb jobs anyone can do. Janitor, actor, cargotech, etc
#define WAGE_LABOUR			600 //The standard wage that most people get
#define WAGE_LABOUR_HAZARD	750	//Hazard pay. For miners and IHOperatives
#define WAGE_PROFESSIONAL	900	//The wage for educated professionals. Doctors, scientists, etc
#define WAGE_COMMAND		1200	//Wage paid to command staff, generally regardless of department

//Defines used for department and job funding sources
#define FUNDING_NONE		0	//No funding
#define FUNDING_INTERNAL	1	//Funded from another account on the ship. Usually the ship itself
#define FUNDING_EXTERNAL	2	//Funded from an external source, like moebius corp. Money is technically created out of nothing