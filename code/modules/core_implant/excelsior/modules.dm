datum/core_module/complant/implant_type = /obj/item/weapon/implant/core_implant/complant

/datum/core_module/complant/common/preinstall()
	implant.remove_modules(COMPLANT_COMMON)
	implant.remove_modules(COMPLANT_LEADER)

/datum/core_module/complant/common/install()
	implant.name = "complant"
	implant.icon_state = ""
	implant.power = 50
	implant.max_power = 50
	implant.power_regen = 0.5
	implant.rituals = cruciform_base_rituals
	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()


/datum/core_module/complant/leader/preinstall()
	implant.remove_modules(COMPLANT_COMMON)
	implant.remove_modules(COMPLANT_LEADER)

/datum/core_module/complant/leader/install()
	implant.name = "complant"
	implant.icon_state = ""
	implant.power = 70
	implant.max_power = 70
	implant.power_regen = 0.7
	implant.rituals = cruciform_base_rituals + cruciform_priest_rituals
	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()