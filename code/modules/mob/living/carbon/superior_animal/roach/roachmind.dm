#define ROACHMINDCAP 33
/datum/overmind/roachmind
	var/mob/living/carbon/superior_animal/roach/leader
	var/list/healers = list()
	var/list/ranged = list()
	var/list/harriers = list()
	var/list/casualties = list()
	var/datum/overmind/roachmind/superior
	var/list/subordinates = list()

/datum/overmind
	var/list/members = list()

/datum/overmind/Destroy()
	. = ..()
	if(length(members))
		CRASH("Overmind type /ref[src] destroyed with members still in existence!")
		
/datum/overmind/roachmind/Destroy()
	for(var/mob/living/carbon/superior_animal/roach/tonotify in members)
		tonotify.leaveOvermind()
		tonotify.overseer = null // we don't exist anymore, possibly revert to default behavior from swarm behaviour!
		tonotify.findOverseer()
	. = ..()

/datum/overmind/proc/rearrangeOverminds(datum/overmind/collatewith)
	if(!istype(collatewith, type)) // do the types partially match?
		return FALSE

/datum/overmind/roachmind/rearrangeOverminds(datum/overmind/roachmind/collatewith)
	if(!..())
		return FALSE
	var/list/highest[] // an overmind ruled by a fuhrer is subordinate to one ruled by a kaiser.
	if(istype(leader, /mob/living/carbon/superior_animal/roach/kaiser))
		highest += src
	if(!istype(collatewith.leader, /mob/living/carbon/superior_animal/roach/kaiser))
		highest += collatewith
	if(length(highest) == 1)
		if(highest[1] == src)
			collatewith.superior?.subordinates.Remove(collatewith)
			collatewith.superior = src
			subordinates.Add(collatewith)
			if(get_dist(leader, collatewith.leader) > 10) // slightly more than vision distance
				return TRUE
			var/list/transfercandidates = collatewith.members.Copy()
			transfercandidates.Remove(collatewith.leader)
			while(length(members) < ROACHMINDCAP && length(transfercandidates) > 0)
				var/chosencandidate = pick(transfercandidates)
				transfercandidates.Remove(chosencandidate)
				if(chosencandidate in collatewith.healers)
					collatewith.removeHealer(chosencandidate)
					addHealer(chosencandidate)
				else if(chosencandidate in collatewith.ranged)
					collatewith.removeRanged(chosencandidate)
					addRanged(chosencandidate)
				else if(chosencandidate in collatewith.harriers)
					collatewith.removeHarrier(chosencandidate)
					addHarrier(chosencandidate)
		else
			superior?.subordinates.Remove(src)
			superior = collatewith
			collatewith.subordinates.Add(src)
			if(get_dist(leader, collatewith.leader) > 10) // slightly more than vision distance
				return TRUE
			var/list/transfercandidates = members.Copy()
			transfercandidates.Remove(leader)
			while(length(collatewith.members) < ROACHMINDCAP && length(transfercandidates) > 0)
				var/chosencandidate = pick(transfercandidates)
				transfercandidates.Remove(chosencandidate)
				if(chosencandidate in healers)
					removeHealer(chosencandidate)
					collatewith.addHealer(chosencandidate)
				else if(chosencandidate in ranged)
					removeRanged(chosencandidate)
					collatewith.addRanged(chosencandidate)
				else if(chosencandidate in harriers)
					removeHarrier(chosencandidate)
					collatewith.addHarrier(chosencandidate)

/datum/overmind/proc/updatePosition(mob/living/carbon/superior_animal/potentialmember)
	return FALSE // we don't know anything

/datum/overmind/roachmind/updatePosition(mob/living/carbon/superior_animal/roach/potentialmember)
	if(get_dist(leader, potentialmember) > 10)
		potentialmember.leaveOvermind(src)
	else
		return TRUE // still in the swarm


/datum/overmind/roachmind/proc/removeHealer(mob/toremove)
	members.Remove(toremove)
	healers.Remove(toremove)

/datum/overmind/roachmind/proc/removeRanged(mob/toremove)
	members.Remove(toremove)
	ranged.Remove(toremove)

/datum/overmind/roachmind/proc/removeHarrier(mob/toremove)
	members.Remove(toremove)
	harriers.Remove(toremove)

/datum/overmind/roachmind/proc/addHealer(mob/toadd)
	members.Add(toadd)
	healers.Add(toadd)

/datum/overmind/roachmind/proc/addRanged(mob/toadd)
	members.Add(toadd)
	ranged.Add(toadd)

/datum/overmind/roachmind/proc/addHarrier(mob/toadd)
	members.Add(toadd)
	harriers.Add(toadd)

/datum/overmind/proc/targetEnemy(mob/tokill)
	for(var/mob/living/carbon/superior_animal/member in members)
		if(member.isValidAttackTarget(tokill))
			if(member.stance == HOSTILE_STANCE_IDLE)
				member.target_mob = tokill
				member.stance = HOSTILE_STANCE_ATTACK

/datum/overmind/roachmind/targetEnemy(mob/tokill)
	var/attackers = ranged.Copy() + harriers.Copy() // healers are not attackers, they get left behind
	for(var/mob/living/carbon/superior_animal/roach/attacker in attackers)
		if(attacker.isValidAttackTarget(tokill))
			if(attacker.stance == HOSTILE_STANCE_IDLE)
				attacker.target_mob = tokill
				attacker.stance = HOSTILE_STANCE_ATTACK

/mob/living/carbon/superior_animal/roach/proc/findOverseer()
	. = FALSE
	if(overseer)
		if(overseer.updatePosition(src))
			return TRUE // we already got one
	// we are not currently in a swarm
	if(type != /mob/living/carbon/superior_animal/roach/kaiser)	// Kaiser doesn't join overminds, Kaiser only creates them.
		for(var/mob/living/carbon/superior_animal/roach/potentialsuperior in view(8))
			if(QDELETED(potentialsuperior)) // not this one.
				continue
			if(istype(potentialsuperior, /mob/living/carbon/superior_animal/roach/kaiser) || (istype(potentialsuperior, /mob/living/carbon/superior_animal/roach/fuhrer) && type != /mob/living/carbon/superior_animal/roach/fuhrer)) // is it a kaiser or a fuhrer and we aren't?
				if(!potentialsuperior.overseer && potentialsuperior.stat != DEAD) // if the living superior doesn't have one, give them one and join it
					var/datum/overmind/roachmind/newoverseer = new()
					newoverseer.leader = potentialsuperior
					potentialsuperior.joinOvermind(newoverseer)
					joinOvermind(newoverseer)
					return TRUE // job done, we got one
				else if((!QDELETED(potentialsuperior.overseer)) && length(potentialsuperior.overseer.members) < ROACHMINDCAP) // skip over any full or dead overminds
					joinOvermind(potentialsuperior.overseer)
					return TRUE // job done, we got one
			
	if((type == /mob/living/carbon/superior_animal/roach/fuhrer) || (type == /mob/living/carbon/superior_animal/roach/kaiser)) // we can start our own
		var/datum/overmind/roachmind/newoverseer = new()
		newoverseer.leader = src
		joinOvermind(newoverseer)
		return TRUE

/mob/living/carbon/superior_animal/roach/proc/joinOvermind(datum/overmind/roachmind/jointhis)
	jointhis.addHarrier(src) // Kampfer is Harrier
	overseer = jointhis

/mob/living/carbon/superior_animal/roach/proc/leaveOvermind()
	overseer?.removeHarrier(src) // Kampfer is Harrier
	overseer?.casualties.Remove(src)
	overseer = null

/datum/overmind/proc/awaken()
	for(var/mob/living/member in members)
		if(member.AI_inactive) // all sleepers, awaken
			member.activate_ai()


/datum/overmind/roachmind/proc/supportMove(mob/tomove, atom/targetatom)
	if(isroach(tomove))
		var/mob/living/carbon/superior_animal/roach/summoned = tomove
		if(summoned.stance == HOSTILE_STANCE_IDLE)
			summoned.stop_automated_movement = TRUE
			summoned.set_glide_size(DELAY2GLIDESIZE(summoned.move_to_delay))
			walk_to(summoned, targetatom, 1, summoned.move_to_delay)

/datum/overmind/roachmind/proc/updateHealing() // instant-state AIs are incredibly messed up from the perspective of real-time worlds but this seems like the way to do it well
	if(length(healers))
		var/list/readied = list()
		for(var/mob/living/carbon/superior_animal/roach/tocheck in healers)
			var/mob/living/carbon/superior_animal/roach/support/seuche = tocheck
			if(istype(seuche))
				if(seuche.gas_sac.has_reagent("blattedin", 20))
					readied.Add(seuche)
		for(var/mob/living/carbon/superior_animal/roach/casualty in casualties)
			for(var/mob/living/carbon/superior_animal/roach/support/ready in readied)
				if(get_dist(ready, casualty) <= 3 && ready.z == casualty.z)
					ready.gas_attack() // heal whoever's closest first
					readied.Remove(ready)
					casualties.Remove(casualty) // they'll just go right back on the list if they're tank class, but it's good enough for a loop
					break // we got one close enough already, we don't need another
			for(var/mob/living/carbon/superior_animal/roach/support/ready in readied) // loop again, this time with the knowledge that none of the roaches are close enough.
				if(ready in viewers(casualty)) // can ready see the roach?
					supportMove(ready, casualty)
					break // we got a healer on the way
			

	else
		return FALSE


#undef ROACHMINDCAP
