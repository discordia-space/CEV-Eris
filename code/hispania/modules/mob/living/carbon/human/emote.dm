/mob/proc/handle_emote_param(var/target, var/not_self, var/vicinity, var/return_mob) //Only returns not null if the target param is valid.
	var/view_vicinity = vicinity ? vicinity : null									 //not_self means we'll only return if target is valid and not us
	if(target)																		 //vicinity is the distance passed to the view proc.
		for(var/mob/A in view(view_vicinity, null))									 //if set, return_mob will cause this proc to return the mob instead of just its name if the target is valid.
			if(target == A.name && (!not_self || (not_self && target != name)))
				if(return_mob)
					return A
				else
					return target

/mob/living/carbon/human/proc/get_age_pitch()
	return 1.0 + 0.5*(30 - age)/80

/datum/proc/p_their(capitalized, temp_gender)
	. = "its"
	if(capitalized)
		. = capitalize(.)
