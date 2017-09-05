/datum/antagonist
	var/outer = FALSE

	var/landmark_id                         // Spawn point identifier.
	var/mob_path = /mob/living/carbon/human // Mobtype this antag will use if none is provided.

	var/id_type
	var/list/default_access = list()