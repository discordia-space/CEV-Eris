/datum/antagonist/excelsior
	id = ROLE_EXCELSIOR_REV
	role_text = "Excelsior Infiltrator"
	role_text_plural = "Infiltrators"
	bantype = ROLE_BANTYPE_EXCELSIOR
	welcome_text = "Viva la revolution!"
	antaghud_indicator = "hudexcelsior"

	faction_id = FACTION_EXCELSIOR
	allow_neotheology = FALSE //Implant causes head asplode

	story_ineligible = list(JOBS_SECURITY, JOBS_COMMAND)

/datum/antagonist/excelsior/equip()
	.=..()

	// Makes sures to exclude the leader implant when used with implanter
	for(var/obj/O in owner.current)
		if(istype(O, /obj/item/weapon/implant/excelsior))
			return

	var/obj/item/weapon/implant/excelsior/leader/implant = new(owner.current)
	implant.install(owner.current, BP_HEAD)
