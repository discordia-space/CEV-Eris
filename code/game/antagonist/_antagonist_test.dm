/mob/living/carbon/human/verb/test_antag_system_s()
	set name = "Test single antagonist"

	make_antagonist(src.mind, ROLE_TRAITOR)


/mob/living/carbon/human/verb/test_antag_system_p()
	set name = "Test faction antagonist"

	var/datum/antagonist/A = make_antagonist(src.mind, ROLE_REVOLUTIONARY)

	var/datum/faction/F = A.faction

	world << "faction: [F.type]"

