#define CYBERAVATAR_CONNECT_PROC_TO(Proc2Connect, TargetProc) ##Proc2Connect{. = ..(); if(istype(CyberAvatar) && CyberAvatar.enabled)CyberAvatar.##TargetProc(arglist(args))}

CYBERAVATAR_CONNECT_PROC_TO(/atom/Crossed(atom/movable/O), OnCrossedBy)
/datum/CyberSpaceAvatar/proc/OnCrossedBy(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Uncrossed(atom/movable/O), OnUncrossedBy)
/datum/CyberSpaceAvatar/proc/OnUncrossedBy(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Cross(atom/movable/O), OnCross)
/datum/CyberSpaceAvatar/proc/OnCross(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Uncross(atom/movable/O), OnUncross)
/datum/CyberSpaceAvatar/proc/OnUncross(atom/movable/O)

CYBERAVATAR_CONNECT_PROC_TO(/atom/movable/Move(NewLoc,Dir=0,step_x=0,step_y=0), OnMovedTo)
/datum/CyberSpaceAvatar/proc/OnMovedTo(NewLoc,Dir=0,step_x=0,step_y=0)

CYBERAVATAR_CONNECT_PROC_TO(/atom/attack_hand(mob/user as mob), attacked_by_hand)
/datum/CyberSpaceAvatar/proc/attacked_by_hand(mob/user as mob)
	var/datum/CyberSpaceAvatar/A = user.CyberAvatar
	if(istype(A))
		attacked_by_avatar(A, user.a_intent)

/datum/CyberSpaceAvatar/proc/attacked_by_avatar(datum/CyberSpaceAvatar/user, intent)

CYBERAVATAR_CONNECT_PROC_TO(/atom/movable/Bump(atom/Obstacle), OnBump)
/datum/CyberSpaceAvatar/proc/OnBump(atom/Obstacle)

CYBERAVATAR_CONNECT_PROC_TO(/atom/Bumped(AM as mob|obj), BumpedBy)
/datum/CyberSpaceAvatar/proc/BumpedBy(atom/movable/AM)
