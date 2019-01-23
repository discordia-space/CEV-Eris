/datum/antagonist/excelsior
	id = ROLE_EXCELSIOR_REV
	role_text = "Excelsior Infiltrator"
	role_text_plural = "Infiltrators"
	bantype = ROLE_BANTYPE_EXCELSIOR
	welcome_text = "Viva la revolution!"

	faction_id = FACTION_EXCELSIOR
	allow_neotheology = FALSE //Implant causes head asplode

/datum/antagonist/excelsior/equip()
	.=..()
	var/obj/item/weapon/implant/excelsior/leader/implant = new(owner.current)
	implant.install(owner.current, BP_HEAD)