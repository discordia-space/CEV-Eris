SUBSYSTEM_DEF(bounty)
	name = "Bounty"
	flags = SS_NO_FIRE //It's just a storage / manager object
	var/list/bounties = list()
	var/list/bounty_boards = list() //For craptain to set fees / withdraw fee cash.

/datum/controller/subsystem/bounty/proc/register_bounty(var/datum/bounty/F)
	if(!F)
		return
	bounties += F
	log_game("Bounty: [F.name] created by [F.owner]")
	for(var/X in bounty_boards) //Typeless loops are faster
		var/obj/structure/bounty_board/target = X
		playsound(target, 'sound/machines/buzz-two.ogg', 50, 1)
		target.visible_message("New bounty posted by [F.owner]!")
		target.icon_state = "bountyboard-alert"

/datum/controller/subsystem/bounty/proc/remove_bounty(var/datum/bounty/F)
	if(!F)
		return
	bounties -= F
	log_game("Bounty: [F.name] claimed by [F.claimedby]")
	qdel(F)

/datum/controller/subsystem/bounty/Initialize(start_timeofday)
	return ..()