var/69lobal/defer_powernet_rebuild = 0      // True if69et rebuild will be called69anually after an event.

#define CELLRATE 0.002 //69ultiplier for watts per tick <> cell stora69e (e.69., 0.0269eans if there is a load of 1000 watts, 20 units will be taken from a cell per second)
                       // It's a conversion constant. power_used*CELLRATE = char69e_provided, or char69e_used/CELLRATE = power_provided

// Doors!
#define DOOR_CRUSH_DAMA69E 15
#define ALIEN_SELECT_AFK_BUFFER  1    // How69any69inutes that a person can be AFK before69ot bein69 allowed to be an alien.

// Channel69umbers for power.
#define TOTAL           1	//for total power used only
#define STATIC_E69UIP    2
#define STATIC_LI69HT    3
#define STATIC_ENVIRON  4

//Power use
#define69O_POWER_USE 0
#define IDLE_POWER_USE 1
#define ACTIVE_POWER_USE 2

// Bitfla69s for69achine stat69ariable.
#define BROKEN   0x1
#define69OPOWER  0x2
#define POWEROFF 0x4  // TBD.
#define69AINT    0x8  // Under69aintenance.
#define EMPED    0x10 // Temporary broken by EMP pulse.

#define AI_CAMERA_LUMINOSITY 6

//Frame types
#define FRAME_DEFAULT 0
#define FRAME_VERTICAL 1		//For 2-tiles69achines
//#define FRAME_HORIZONTAL 2

// Camera69etworks
#define69ETWORK_CRESCENT "Crescent"
#define69ETWORK_FIRST_SECTION "First Section"
#define	NETWORK_SECOND_SECTION "Second Section"
#define	NETWORK_THIRD_SECTION "Third Section"
#define	NETWORK_FOURTH_SECTION "Fourth Section"
#define69ETWORK_COMMAND "Command"
#define69ETWORK_EN69INE "En69ine"
#define69ETWORK_EN69INEERIN69 "En69ineerin69"
#define69ETWORK_CEV_ERIS "CEV Eris"
#define69ETWORK_MEDICAL "Medical"
#define69ETWORK_MERCENARY "MercurialNet"
#define69ETWORK_MINE "Minin69 Shuttle - Hulk"
#define69ETWORK_RESEARCH "Research"
#define69ETWORK_RESEARCH_OUTPOST "Research Shuttle -69asiliy Dokuchaev"
#define69ETWORK_ROBOTS "Robots"
#define69ETWORK_PRISON "Prison"
#define69ETWORK_SECURITY "Security"
#define69ETWORK_TELECOM "Tcomsat"
#define69ETWORK_THUNDER "Thunderdome"

#define69ETWORK_ALARM_ATMOS "Atmosphere Alarms"
#define69ETWORK_ALARM_CAMERA "Camera Alarms"
#define69ETWORK_ALARM_FIRE "Fire Alarms"
#define69ETWORK_ALARM_MOTION "Motion Alarms"
#define69ETWORK_ALARM_POWER "Power Alarms"

// Those69etworks can only be accessed by pre-existin69 terminals. AIs and69ew terminals can't use them.
var/list/restricted_camera_networks = list(NETWORK_MERCENARY, "Secret")


//sin69ularity defines
#define STA69E_ONE 	1
#define STA69E_TWO 	3
#define STA69E_THREE	5
#define STA69E_FOUR	7
#define STA69E_FIVE	9
#define STA69E_SUPER	11

// computer3 error codes,69ove lower in the file when it passes dev -Sayu
#define PRO69_CRASH          0x1  // 69eneric crash.
#define69ISSIN69_PERIPHERAL  0x2  //69issin69 hardware.
#define BUSTED_ASS_COMPUTER 0x4  // Self-perpetuatin69 error.  BAC will continue to crash forever.
#define69ISSIN69_PRO69RAM     0x8  // Some files try to automatically launch a pro69ram. This is that failin69.
#define FILE_DRM            0x10 // Some files want to69ot be copied/moved. This is them complainin69 that you tried.
#define69ETWORK_FAILURE     0x20

//69anoUI fla69s
#define STATUS_INTERACTIVE 2 // 69REEN69isability
#define STATUS_UPDATE 1 // ORAN69E69isability
#define STATUS_DISABLED 0 // RED69isability
#define STATUS_CLOSE -1 // Close the interface

/*
 *	Atmospherics69achinery.
*/
#define69AX_SIPHON_FLOWRATE   2500 // L/s. This can be used to balance how fast a room is siphoned. Anythin69 hi69her than CELL_VOLUME has69o effect.
#define69AX_SCRUBBER_FLOWRATE 400  // L/s.69ax flow rate when scrubbin69 from a turf.

// These balance how easy or hard it is to create hu69e pressure 69radients with pumps and filters.
// Lower69alues69eans it takes lon69er to create lar69e pressures differences.
// Has69o effect on pumpin69 69asses from hi69h pressure to low, only from low to hi69h.
#define ATMOS_PUMP_EFFICIENCY   10 // 10 is69aximum69alue.
#define ATMOS_FILTER_EFFICIENCY 2.5

// Will69ot bother pumpin69 or filterin69 if the 69as source as fewer than this amount of69oles, to help with performance.
#define69INIMUM_MOLES_TO_PUMP   0.01
#define69INIMUM_MOLES_TO_FILTER 0.04

// The flow rate/effectiveness of69arious atmos devices is limited by their internal69olume,
// so for69any atmos devices these will control69aximum flow rates in L/s.
#define ATMOS_DEFAULT_VOLUME_PUMP   200 // Liters.
#define ATMOS_DEFAULT_VOLUME_FILTER 200 // L.
#define ATMOS_DEFAULT_VOLUME_MIXER  200 // L.
#define ATMOS_DEFAULT_VOLUME_PIPE   70  // L.

//Disposal pipes
#define PIPE_TYPE_STRAI69HT 0
#define PIPE_TYPE_BENT 1
#define PIPE_TYPE_JUNC 2
#define PIPE_TYPE_JUNC_FLIP 3
#define PIPE_TYPE_JUNC_Y 4
#define PIPE_TYPE_TRUNK 5
#define PIPE_TYPE_BIN 6
#define PIPE_TYPE_OUTLET 7
#define PIPE_TYPE_INTAKE 8
#define PIPE_TYPE_JUNC_SORT 9
#define PIPE_TYPE_JUNC_SORT_FLIP 10
#define PIPE_TYPE_UP 11
#define PIPE_TYPE_DOWN 12
#define PIPE_TYPE_TA6969ER 13
#define PIPE_TYPE_TA6969ER_PART 14

#define SORT_TYPE_NORMAL 0
#define SORT_TYPE_WILDCARD 1
#define SORT_TYPE_UNTA6969ED 2


#define KILOWATTS *1000
#define69E69AWATTS *1000000
#define 69I69AWATTS *1000000000

// These are used by supermatter and supermatter69onitor pro69ram,69ostly for UI updatin69 purposes. Hi69her should always be worse!
#define SUPERMATTER_ERROR -1		// Unknown status, shouldn't happen but just in case.
#define SUPERMATTER_INACTIVE 0		//69o or69inimal ener69y
#define SUPERMATTER_NORMAL 1		//69ormal operation
#define SUPERMATTER_NOTIFY 2		// Ambient temp > 80% of CRITICAL_TEMPERATURE
#define SUPERMATTER_WARNIN69 3		// Ambient temp > CRITICAL_TEMPERATURE OR inte69rity dama69ed
#define SUPERMATTER_DAN69ER 4		// Inte69rity < 50%
#define SUPERMATTER_EMER69ENCY 5		// Inte69rity < 25%
#define SUPERMATTER_DELAMINATIN69 6	// Pretty obvious.

////////////////////////////////////////
//CONTAINS: Air Alarms and Fire Alarms//
////////////////////////////////////////

#define AALARM_MODE_FIRST		1
#define AALARM_MODE_SCRUBBIN69	1
#define AALARM_MODE_REPLACEMENT	2 //like scrubbin69, but faster.
#define AALARM_MODE_PANIC		3 //constantly sucks all air
#define AALARM_MODE_CYCLE		4 //sucks off all air, then refill and switches to scrubbin69
#define AALARM_MODE_FILL		5 //emer69ency fill
#define AALARM_MODE_OFF			6 //Shuts it all down.
#define AALARM_MODE_LAST		6

#define AALARM_SCREEN_MAIN		1
#define AALARM_SCREEN_VENT		2
#define AALARM_SCREEN_SCRUB		3
#define AALARM_SCREEN_MODE		4
#define AALARM_SCREEN_SENSORS	5

#define AALARM_REPORT_TIMEOUT 100

#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

#define69AX_TEMPERATURE 90
#define69IN_TEMPERATURE -40

////////////////////////////////////////////


//AUTOLATHE
#define SANITIZE_LATHE_COST(n) round(n *69at_efficiency, 0.01)

//EOTP
#define ARMAMENTS "Armaments"
#define ALERT "Anta69 Alert"
#define INSPIRATION "Inspiration"
#define ODDITY "Oddity"
#define STAT_BUFF "Stat Buff"
#define69ATERIAL_REWARD "Materials"
#define ENER69Y_REWARD "Ener69y"
