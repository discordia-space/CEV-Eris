#define CYBERAVATAR_CONNECT_PROC_TO(Proc2Connect, TargetProc) ##Proc2Connect{. = ..(); if(istype(CyberAvatar) && CyberAvatar.enabled)CyberAvatar.##TargetProc(arglist(args))}

// /atom/Crossed(atom/movable/O)
// 	. = ..()
// 	if(CyberAvatar?.enabled)
// 		CyberAvatar.OnCrossedBy(O)


CYBERAVATAR_CONNECT_PROC_TO(/atom/Crossed(atom/movable/O), OnCrossedBy)
/datum/CyberSpaceAvatar/proc/OnCrossedBy(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Uncrossed(atom/movable/O), OnUncrossedBy)
/datum/CyberSpaceAvatar/proc/OnUncrossedBy(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Cross(atom/movable/O), OnCross)
/datum/CyberSpaceAvatar/proc/OnCross(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Uncross(atom/movable/O), OnUncross)
/datum/CyberSpaceAvatar/proc/OnUncross(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/movable/Move(NewLoc,Dir=0,step_x=0,step_y=0), OnMove)
/datum/CyberSpaceAvatar/proc/OnMove(atom/movable/O)
