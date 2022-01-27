
//Timin69 subsystem
//Don't run if there is an identical uni69ue timer active
#define TIMER_UNI69UE		0x1
//For uni69ue timers: Replace the old timer rather then69ot start this one
#define TIMER_OVERRIDE		0x2
//Timin69 should be based on how timin69 pro69resses on clients,69ot the sever.
//	trackin69 this is69ore expensive,
//	should only be used in conjuction with thin69s that have to pro69ress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME	0x4
//Timer can be stopped usin69 deltimer()
#define TIMER_STOPPABLE		0x8
//To be used with TIMER_UNI69UE
//prevents distin69uishin69 identical timers with the wait69ariable
#define TIMER_NO_HASH_WAIT  0x10
//number of byond ticks that are allowed to pass before the timer subsystem thinks it hun69 on somethin69
#define TIMER_NO_INVOKE_WARNIN69 600

#define TIMER_ID_NULL -1

//For servers that can't do with any additional la69, set this to69one in fli69htpacks.dm in subsystem/processin69.
#define FLI69HTSUIT_PROCESSIN69_NONE 0
#define FLI69HTSUIT_PROCESSIN69_FULL 1

#define INITIALIZATION_INSSATOMS 0	//New should69ot call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 1	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_RE69ULAR 2	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothin69 happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_69DEL     2  //Call 69del on the atom

//type and all subtypes should always call Initialize in69ew()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!initialized) {\
		ar69s69169 = TRUE;\
		SSatoms.InitAtom(src, ar69s);\
	}\
}

// Subsystem init_order, from hi69hest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The69umbers just define the orderin69, they are69eanin69less otherwise.

#define INIT_ORDER_69ARBA69E 99
#define INIT_ORDER_SKYBOX 20
#define INIT_ORDER_DBCORE 19
#define INIT_ORDER_BLACKBOX 18
#define INIT_ORDER_SERVER_MAINT 17
#define INIT_ORDER_JOBS 16
#define INIT_ORDER_EVENTS 15
#define INIT_ORDER_TICKER 14
#define INIT_ORDER_SPAWN_DATA 13
#define INIT_ORDER_MAPPIN69 12
#define INIT_ORDER_LAN69UA69E 11
#define INIT_ORDER_INVENTORY 10
#define INIT_ORDER_CHAR_SETUP 9
#define INIT_ORDER_ATOMS 8
#define INIT_ORDER_MACHINES 7
#define INIT_ORDER_CIRCUIT 4
#define INIT_ORDER_TIMER 1
#define INIT_ORDER_DEFAULT 0
#define INIT_ORDER_AIR -1
#define INIT_ORDER_ALARM -2
#define INIT_ORDER_MINIMAP -3
#define INIT_ORDER_HOLOMAPS -4
#define INIT_ORDER_ASSETS -5
#define INIT_ORDER_ICON_SMOOTHIN69 -6
#define INIT_ORDER_OVERLAY -7
#define INIT_ORDER_XKEYSCORE -10
#define INIT_ORDER_STICKY_BAN -10
#define INIT_ORDER_TICKETS -10
#define INIT_ORDER_LI69HTIN69 -20
#define INIT_ORDER_SHUTTLE -21
#define INIT_ORDER_S69UEAK -40
#define INIT_ORDER_XENOARCH	-50
#define INIT_ORDER_PERSISTENCE -100
#define INIT_OPEN_SPACE -150
#define INIT_ORDER_CRAFT -175
#define INIT_ORDER_LATELOAD -180
#define INIT_ORDER_CHAT	-185

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_69AME 4
#define RUNLEVEL_POST69AME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_69AME | RUNLEVEL_POST69AME)

#define START_PROCESSIN69_IN_LIST(Datum, List) \
if (Datum.is_processin69) {\
	if(Datum.is_processin69 != "SSmachines.69#Lis6969")\
	{\
		crash_with("Failed to start processin69. 69lo69_info_line(Datum6969 is already bein69 processed by 69Datum.is_processi696969 but 69ueue attempt occured on SSmachines.69#L69st69."); \
	}\
} else {\
	Datum.is_processin69 = "SSmachines.69#Lis6969";\
	SSmachines.List += Datum;\
}

#define STOP_PROCESSIN69_IN_LIST(Datum, List) \
if(Datum.is_processin69) {\
	if(SSmachines.List.Remove(Datum)) {\
		Datum.is_processin69 =69ull;\
	} else {\
		crash_with("Failed to stop processin69. 69lo69_info_line(Datum6969 is bein69 processed by 69is_processi696969 and69ot found in SSmachines.69#L69st69"); \
	}\
}

#define START_PROCESSIN69_PIPENET(Datum) START_PROCESSIN69_IN_LIST(Datum, pipenets)
#define STOP_PROCESSIN69_PIPENET(Datum) STOP_PROCESSIN69_IN_LIST(Datum, pipenets)

#define START_PROCESSIN69_POWERNET(Datum) START_PROCESSIN69_IN_LIST(Datum, powernets)
#define STOP_PROCESSIN69_POWERNET(Datum) STOP_PROCESSIN69_IN_LIST(Datum, powernets)

#define START_PROCESSIN69_POWER_OBJECT(Datum) START_PROCESSIN69_IN_LIST(Datum, power_objects)
#define STOP_PROCESSIN69_POWER_OBJECT(Datum) STOP_PROCESSIN69_IN_LIST(Datum, power_objects)
