/datum/antagonist
	var/outer = FALSE

	var/landmark_id                         // Spawn point identifier.
	var/mob_path = /mob/living/carbon/human // Mobtype this antag will use if none is provided.

	var/id_type


	//If this is true, and the mob_path is human, then we will load the player's character from preferences,
	//applying the hairstyles, skin tones, hair color, eyes, etc to the newly created mob.
	//This will all happen before antagonist.equip is called, so the character can be farther modified there
	var/load_character = TRUE

	//If true, players will load an appearance editor upon spawning in
	var/appearance_editor = TRUE