/datum/species/golem
	name = "Golem"
	name_plural = "golems"

	icobase = 'icons/mob/human_races/r_golem.dmi'
	deform = 'icons/mob/human_races/r_golem.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags =69O_BREATHE |69O_PAIN |69O_BLOOD |69O_SCAN |69O_POISON |69O_MINOR_CUT
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 0

	breath_type =69ull
	poison_type =69ull

	blood_color = "#515573"
	flesh_color = "#137E8F"

	has_process = list(
		BP_BRAIN = /obj/item/organ/internal/brain/golem
		)

	death_message = "becomes completely69otionless..."

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Golem"
	H.real_name = "adamantine golem (69rand(1, 1000)69)"
	H.name = H.real_name
	..()