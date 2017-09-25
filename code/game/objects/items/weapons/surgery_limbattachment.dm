/obj/item/robot_parts/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	var/limbloc = null

	if(!istype(M))
		return ..()

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/structure/bed/roller, M.loc) && (M.buckled || M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat)) && prob(75) || (locate(/obj/structure/table/, M.loc) && (M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(66))))
		return ..()

	if(!ishuman(M))
		return ..()

	if((user.targeted_organ == "l_arm") && (istype(src, /obj/item/robot_parts/l_arm)))
		limbloc = "l_hand"
	else if((user.targeted_organ == "r_arm") && (istype(src, /obj/item/robot_parts/r_arm)))
		limbloc = "r_hand"
	else if((user.targeted_organ == "r_leg") && (istype(src, /obj/item/robot_parts/r_leg)))
		limbloc = "r_foot"
	else if((user.targeted_organ == "l_leg") && (istype(src, /obj/item/robot_parts/l_leg)))
		limbloc = "l_foot"
	else
		user << SPAN_WARNING("That doesn't fit there!")
		return ..()

	var/mob/living/carbon/human/H = M
	var/datum/organ/external/S = H.organs[user.targeted_organ]
	if(S.status & ORGAN_DESTROYED)
		if(!(S.status & ORGAN_ATTACHABLE))
			user << SPAN_WARNING("The wound is not ready for a replacement!")
			return 0
		if(M != user)
			M.visible_message( \
				SPAN_NOTICE("\The [user] is beginning to attach \the [src] where [H]'s [S.display_name] used to be."), \
				SPAN_NOTICE("\The [user] begins to attach \the [src] where your [S.display_name] used to be."))
		else
			M.visible_message( \
				SPAN_NOTICE("\The [user] begins to attach a robotic limb where \his [S.display_name] used to be with [src]."), \
				SPAN_NOTICE("You begin to attach \the [src] where your [S.display_name] used to be."))

		if(do_mob(user, H, 100))
			if(M != user)
				M.visible_message( \
					SPAN_NOTICE("\The [user] finishes attaching [H]'s new [S.display_name]."), \
					SPAN_NOTICE("\The [user] finishes attaching your new [S.display_name]."))
			else
				M.visible_message( \
					SPAN_NOTICE("\The [user] finishes attaching \his new [S.display_name]."), \
					SPAN_NOTICE("You finish attaching your new [S.display_name]."))

			if(H == user && prob(25))
				user << SPAN_WARNING("You mess up!")
				S.take_damage(15)

			S.status &= ~ORGAN_BROKEN
			S.status &= ~ORGAN_SPLINTED
			S.status &= ~ORGAN_ATTACHABLE
			S.status &= ~ORGAN_DESTROYED
			S.status |= ORGAN_ROBOT
			var/datum/organ/external/T = H.organs["[limbloc]"]
			T.status &= ~ORGAN_BROKEN
			T.status &= ~ORGAN_SPLINTED
			T.status &= ~ORGAN_ATTACHABLE
			T.status &= ~ORGAN_DESTROYED
			T.status |= ORGAN_ROBOT
			H.update_body()
			M.updatehealth()
			M.UpdateDamageIcon()
			qdel(src)

			return 1
		return 0
