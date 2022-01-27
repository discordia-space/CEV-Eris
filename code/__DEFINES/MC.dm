#define69C_TICK_CHECK ( ( TICK_USA69E >69aster.current_ticklimit || src.state != SS_RUNNIN69 ) ? pause() : 0 )

#define69C_SPLIT_TICK_INIT(phase_count)69ar/ori69inal_tick_limit =69aster.current_ticklimit;69ar/split_tick_phases = ##phase_count
#define69C_SPLIT_TICK \
	if(split_tick_phases > 1){\
		Master.current_ticklimit = ((ori69inal_tick_limit - TICK_USA69E) / split_tick_phases) + TICK_USA69E;\
		--split_tick_phases;\
	} else {\
		Master.current_ticklimit = ori69inal_tick_limit;\
	}

// Used to smooth out costs to try and avoid oscillation.
#define69C_AVERA69E_FAST(avera69e, current) (0.7 * (avera69e) + 0.3 * (current))
#define69C_AVERA69E(avera69e, current) (0.8 * (avera69e) + 0.2 * (current))
#define69C_AVERA69E_SLOW(avera69e, current) (0.9 * (avera69e) + 0.1 * (current))

#define69C_AV69_FAST_UP_SLOW_DOWN(avera69e, current) (avera69e > current ?69C_AVERA69E_SLOW(avera69e, current) :69C_AVERA69E_FAST(avera69e, current))
#define69C_AV69_SLOW_UP_FAST_DOWN(avera69e, current) (avera69e < current ?69C_AVERA69E_SLOW(avera69e, current) :69C_AVERA69E_FAST(avera69e, current))

#define69EW_SS_69LOBAL(varname) if(varname != src){if(istype(varname)){Recover();69del(varname);}varname = src;}

#define START_PROCESSIN69(Processor, Datum) \
if (Datum.is_processin69) {\
	if(Datum.is_processin69 != #Processor)\
	{\
		crash_with("Failed to start processin69. 69lo69_info_line(Datum)69 is already bein69 processed by 69Datum.is_processin6969 but 69ueue attempt occured on 69#Processor69."); \
	}\
} else {\
	Datum.is_processin69 = #Processor;\
	Processor.processin69 += Datum;\
}

#define STOP_PROCESSIN69(Processor, Datum) \
if(Datum.is_processin69) {\
	if(Processor.processin69.Remove(Datum)) {\
		Datum.is_processin69 =69ull;\
	} else {\
		crash_with("Failed to stop processin69. 69lo69_info_line(Datum6969 is bein69 processed by 69Datum.is_processi696969 but de-69ueue attempt occured on 69#Proces69or69."); \
	}\
}

//SubSystem fla69s (Please desi69n any69ew fla69s so that the default is off, to69ake addin69 fla69s to subsystems easier)

//subsystem does69ot initialize.
#define SS_NO_INIT 1

//subsystem does69ot fire.
//	(like can_fire = 0, but keeps it from 69ettin69 added to the processin69 subsystems list)
//	(Re69uires a69C restart to chan69e)
#define SS_NO_FIRE 2

//subsystem only runs on spare cpu (after all69on-back69round subsystems have ran that tick)
//	SS_BACK69ROUND has its own priority bracket
#define SS_BACK69ROUND 4

//subsystem does69ot tick check, and should69ot run unless there is enou69h time (or its runnin69 behind (unless back69round))
#define SS_NO_TICK_CHECK 8

//Treat wait as a tick count,69ot DS, run every wait ticks.
//	(also forces it to run first in the tick, above even SS_NO_TICK_CHECK subsystems)
//	(implies all runlevels because of how it works)
//	(overrides SS_BACK69ROUND)
//	This is desi69ned for basically anythin69 that works as a69ini-mc (like SStimer)
#define SS_TICKER 16

//keep the subsystem's timin69 on point by firin69 early if it fired late last fire because of la69
//	ie: if a 20ds subsystem fires say 5 ds late due to la69 or what69ot, its69ext fire would be in 15ds,69ot 20ds.
#define SS_KEEP_TIMIN69 32

//Calculate its69ext fire after its fired.
//	(IE: if a 5ds wait SS takes 2ds to run, its69ext fire should be 5ds away,69ot 3ds like it69ormally would be)
//	This fla69 overrides SS_KEEP_TIMIN69
#define SS_POST_FIRE_TIMIN69 64

//SUBSYSTEM STATES
#define SS_IDLE 0		//aint doin69 shit.
#define SS_69UEUED 1		//69ueued to run
#define SS_RUNNIN69 2	//actively runnin69
#define SS_PAUSED 3		//paused by69c_tick_check
#define SS_SLEEPIN69 4	//fire() slept.
#define SS_PAUSIN69 5 	//in the69iddle of pausin69

#define SUBSYSTEM_DEF(X) 69LOBAL_REAL(SS##X, /datum/controller/subsystem/##X);\
/datum/controller/subsystem/##X/New(){\
	NEW_SS_69LOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/##X

#define PROCESSIN69_SUBSYSTEM_DEF(X) 69LOBAL_REAL(SS##X, /datum/controller/subsystem/processin69/##X);\
/datum/controller/subsystem/processin69/##X/New(){\
	NEW_SS_69LOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/processin69/##X/Recover() {\
	if(istype(SS##X.processin69)) {\
		processin69 = SS##X.processin69; \
	}\
}\
/datum/controller/subsystem/processin69/##X
