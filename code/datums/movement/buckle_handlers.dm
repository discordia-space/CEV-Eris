//	Buckle handlers
//	They decide how atom will behave when staff buckled to it
/*
/datum/movement_handler/buckle_handler/vehicle/DoMove(var/direction, var/mover)
	// TODO: Datumlize buckle-handling
	if(istype(mob.buckled, /obj/vehicle))
		//drunk driving
		if(mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
			direction = turn(direction, pick(90, -90))
		mob.buckled.relaymove(mob, direction)
		return MOVEMENT_HANDLED

	if(mob.pulledby || mob.buckled) // Wheelchair driving!
		if(istype(mob.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			mob.pulledby.DoMove(direction, mob)
		else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			if(ishuman(mob))
				var/mob/living/carbon/human/driver = mob
				var/obj/item/organ/external/l_arm = driver.get_organ(BP_L_ARM)
				var/obj/item/organ/external/r_arm = driver.get_organ(BP_R_ARM)
				if((!l_arm || l_arm.is_stump()) && (!r_arm || r_arm.is_stump()))
					return // No arms to drive your chair? Tough luck!
			//drunk wheelchair driving
			direction = mob.AdjustMovementDirection(direction)
			mob.buckled.DoMove(direction, mob)
		// YEEEHHAAAA, we are riding this badboy
		else if (isliving(mob.buckled))
			. = MOVEMENT_PROCEED
			var/dismount = FALSE
			if(get_turf(mob) != get_turf(mob.buckled))
				dismount = TRUE
			else if(ishuman(mob))
				var/mob/living/carbon/human/driver = mob
				var/obj/item/organ/external/l_arm = driver.get_organ(BP_L_ARM)
				var/obj/item/organ/external/r_arm = driver.get_organ(BP_R_ARM)
				var/obj/item/organ/external/l_leg = driver.get_organ(BP_L_LEG)
				var/obj/item/organ/external/r_leg = driver.get_organ(BP_R_LEG)
				if((!l_arm || l_arm.is_stump()) && (!r_arm || r_arm.is_stump()) || !(l_leg && r_leg))
					dismount = TRUE // if no arms or no legs we cant hold onto mob
			if(dismount)
				mob.visible_message(SPAN_WARNING("[mob] has fallen of \the [mob.buckled]!"), SPAN_WARNING("You have fallen of \the [mob.buckled]!"))
				mob.buckled.unbuckle_mob(mob)
				return MOVEMENT_STOP

/datum/movement_handler/buckle_handler/vehicle/MayMove(var/mover)
	if(mob.buckled)
		if(!mob.buckled.buckle_movable)
			return MOVEMENT_STOP
		if(mob.buckled.buckle_drivable)
			return mob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) : MOVEMENT_STOP
		else
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/vehicle/DoMove(var/direction, var/mover)
	. = MOVEMENT_HANDLED

/datum/movement_handler/buckle_handler/vehicle/MayMove(var/mover)
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/wheelchair/DoMove(var/direction, var/mover)
	. = MOVEMENT_HANDLED

/datum/movement_handler/buckle_handler/wheelchair/MayMove(var/mover)
	return MOVEMENT_PROCEED
*/
// Movement of a mob mounted by other mob (basically movement of the horse)
/datum/movement_handler/buckle_handler/mob
	expected_host_type = /mob
	var/mob/mob

/datum/movement_handler/buckle_handler/mob/New(var/host)
	..()
	src.mob = host

/datum/movement_handler/buckle_handler/mob/Destroy()
	mob = null
	. = ..()

/datum/movement_handler/buckle_handler/mob/basic/DoMove(var/direction, var/mover)
	// grabbed be rider he controls
	// TODO
	if(mob.buckled_mob)
		mob.buckled_mob.DoMove(direction, mob, TRUE)
	// movement of mob will be handled in /datum/movement_handler/mob/movement
	return MOVEMENT_PROCEED

/datum/movement_handler/buckle_handler/mob/basic/MayMove(var/mover, var/is_external)
	// TODO ADD MOUNT OBEY CHECK
	if(mob.buckled_mob)
		if(is_external)
			//mob.canBeRidedBy(mob.buckled_mob) Add something like dat
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED