#define WELCOME_DCREW ""   // PLACCCEEE HOOOOLDERRRRR DU NUT FOGET here look at this don't skip it over

/datum/faction/dcrew
	id = FACTION_DCREW
	name = "Derelict Crew"
	antag = "crew"
	antag_plural = "Derelict crewmembers"
	welcome_text = WELCOME_DCREW

	hud_indicator = "Dcrew"

	possible_antags = list(ROLE_DCREW)

	faction_invisible = TRUE


/datum/faction/dcrew/add_leader(var/datum/antagonist/member, var/announce = TRUE)   //well lets get em a boss
	.=..()
	if (.)
		member.owner.current.add_language(LANGUAGE_COMMON)

		member.create_id("Derelict Captain")
