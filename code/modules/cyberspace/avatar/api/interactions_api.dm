#define CYBERAVATAR_CONNECT_PROC_TO(Proc2Connect, TargetProc) ##Proc2Connect{. = ..(); if(istype(CyberAvatar) && CyberAvatar.enabled) CyberAvatar.##TargetProc(arglist(args))}

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

/atom/Click(location, control, params)
	. = ..()
	var/mob/user = usr
	if(IsCyberspaced(user) && IsCyberspaced(src))
		CyberAvatar.ClickedBy(usr, params)


/datum/CyberSpaceAvatar/proc/ClickedBy(mob/user as mob, params)
	if(istype(user.CyberAvatar, /datum/CyberSpaceAvatar))
		ClickedByAvatar(user, user.CyberAvatar, params)

/datum/CyberSpaceAvatar/proc/ClickedByAvatar(mob/user, datum/CyberSpaceAvatar/user_avatar, params)

// CYBERAVATAR_CONNECT_PROC_TO(/atom/movable/Bump(atom/Obstacle), OnBump)
// /datum/CyberSpaceAvatar/proc/OnBump(atom/Obstacle)

// CYBERAVATAR_CONNECT_PROC_TO(/atom/Bumped(AM as mob|obj), BumpedBy)
// /datum/CyberSpaceAvatar/proc/BumpedBy(atom/movable/AM)
// 	if(istype(AM.CyberAvatar) && AM.CyberAvatar.enabled)
// 		BumpedByAvatar(AM.CyberAvatar)

/datum/CyberSpaceAvatar/proc/BumpedByAvatar(datum/CyberSpaceAvatar/avatar)
