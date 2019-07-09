//	Buckle handlers
//	They decide how atom will behave when staff buckled to it
/datum/movement_handler/buckle_handler/DoMove(var/direction, var/mover)
	if(host.buckled_mob)
		host.buckled_mob.DoMove(direction, host, TRUE)	// Person help chair to move, while chair helps person to move (do you ever realized that ?)

/datum/movement_handler/buckle_handler/vehicle/DoMove(var/direction, var/mover)
	if(host.buckled_mob)
		if(host.buckled_mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
			direction = turn(direction, pick(90, -90))
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/vehicle/MayMove(var/mover, var/is_external)
	if(host.buckled_mob)
		if(mover == host.buckled_mob)
			if(istype(host.loc, /turf/space))
				return MOVEMENT_STOP
		if(!checkRiderCapabilities(1,1,FALSE))
			return MOVEMENT_STOP
	
	return MOVEMENT_PROCEED

// wheelchair for example
/datum/movement_handler/buckle_handler/moveableWithArms/DoMove(var/direction, var/mover)
	if(host.buckled_mob)
		if(ishuman(host.buckled_mob))
			var/mob/living/carbon/human/driver = host.buckled_mob
			var/arms = driver.has_appendage(BP_L_ARM) ? 1 : 0 + driver.has_appendage(BP_R_ARM) ? 1 : 0
			switch(arms)
				if (1)
					host.set_movement_delay(host.get_movement_delay()/min(1,3 * driver.stats.getDelayMult(STAT_TGH)))
				else
					host.reset_movement_delay()
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/moveableWithArms/MayMove(var/mover, var/is_external)
	if(host.buckled_mob)
		if(mover == host.buckled_mob)
			if(istype(host.loc, /turf/space))
				return MOVEMENT_STOP
		if(!checkRiderCapabilities(0,1,FALSE))
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/moveableWithLegs/DoMove(var/direction, var/mover)
	if(host.buckled_mob)
		if(ishuman(host.buckled_mob))
			var/mob/living/carbon/human/driver = host.buckled_mob
			var/legs = driver.has_appendage(BP_L_LEG) ? 1 : 0 + driver.has_appendage(BP_R_LEG) ? 1 : 0
			switch(legs)
				if (1)
					host.set_movement_delay(host.get_movement_delay()/2)
				else
					host.reset_movement_delay()

	return MOVEMENT_PROCEED
	
/datum/movement_handler/buckle_handler/moveableWithLegs/MayMove(var/mover, var/is_external)
	if(host.buckled_mob)
		if(mover == host.buckled_mob)
			if(istype(host.loc, /turf/space))
				return MOVEMENT_STOP
		if(!checkRiderCapabilities(1,0,FALSE))
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/mob/basic/MayMove(var/mover, var/is_external)
	if(mob.buckled_mob)
		if(!checkRiderCapabilities(0,2,TRUE) || !checkRiderCapabilities(2,0,TRUE))
			return MOVEMENT_PROCEED
		if(mover == mob.buckled_mob)
			if(!mob.MayMove())
				return MOVEMENT_STOP
			//if(!mob.canBeRidedBy(mob.buckled_mob)) Add something like dat
				//return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/proc/checkRiderCapabilities(var/requiredLegs, var/requiredArms, var/shouldDismount)
	if(!host.buckled_mob)
		return FALSE
	var/notCapable = FALSE
	if(get_turf(host.buckled_mob) != get_turf(host))
		notCapable = TRUE
		shouldDismount = TRUE
	if (isliving(host))
		if(ishuman(host.buckled_mob))
			var/mob/living/carbon/human/driver = host.buckled_mob
			switch(requiredLegs)
				if(1)
					if(!driver.has_appendage(BP_L_LEG) && !driver.has_appendage(BP_R_LEG))
						notCapable = TRUE
				if(2)
					if(!driver.has_appendage(BP_L_LEG) || !driver.has_appendage(BP_R_LEG))
						notCapable = TRUE
			switch(requiredArms)
				if(1)
					if(!driver.has_appendage(BP_L_ARM) && !driver.has_appendage(BP_R_ARM))
						notCapable = TRUE
				if(2)
					if(!driver.has_appendage(BP_L_ARM) || !driver.has_appendage(BP_R_ARM))
						notCapable = TRUE
	if(shouldDismount)
		host.buckled_mob.visible_message(SPAN_WARNING("[host.buckled_mob] has fallen of \the [host]!"), SPAN_WARNING("You have fallen of \the [host]!"))
		var/mob/living/rider = host.buckled_mob
		host.buckled_mob.buckled.unbuckle_mob(host)
		rider.DoMove(pick(cardinal), host.buckled_mob)
		return FALSE
	return notCapable ? FALSE : TRUE