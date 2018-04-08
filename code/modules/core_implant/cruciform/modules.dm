/datum/core_module/cruciform/implant_type = /obj/item/weapon/implant/core_implant/cruciform

/datum/core_module/cruciform/common/preinstall()
	implant.remove_modules(CRUCIFORM_COMMON)
	implant.remove_modules(CRUCIFORM_PRIEST)
	implant.remove_modules(CRUCIFORM_INQUISITOR)

/datum/core_module/cruciform/common/install()
	implant.name = "cruciform"
	implant.icon_state = "cruciform_green"
	implant.power = 50
	implant.max_power = 50
	implant.power_regen = 0.5
	implant.rituals = cruciform_base_rituals
	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()


/datum/core_module/cruciform/priest/preinstall()
	implant.remove_modules(CRUCIFORM_COMMON)
	implant.remove_modules(CRUCIFORM_PRIEST)
	implant.remove_modules(CRUCIFORM_INQUISITOR)

/datum/core_module/cruciform/priest/install()
	implant.name = "priest cruciform"
	implant.icon_state = "cruciform_red"
	implant.power = 70
	implant.max_power = 70
	implant.power_regen = 0.7
	implant.rituals = cruciform_base_rituals + cruciform_priest_rituals
	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()


/datum/core_module/cruciform/inquisitor
	var/telecrystals = 15

/datum/core_module/cruciform/inquisitor/preinstall()
	implant.remove_modules(CRUCIFORM_COMMON)
	implant.remove_modules(CRUCIFORM_PRIEST)
	implant.remove_modules(CRUCIFORM_INQUISITOR)

/datum/core_module/cruciform/inquisitor/install()
	implant.name = "cruciform"
	implant.icon_state = "cruciform_green"
	implant.power = 100
	implant.max_power = 100
	implant.power_regen = 1
	implant.rituals = cruciform_base_rituals + cruciform_priest_rituals + inquisitor_rituals
	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()

/datum/core_module/cruciform/cloning
	var/datum/dna/dna = null
	var/age = 30
	var/ckey = ""
	var/mind = null
	var/languages = list()
	var/flavor = ""

/datum/core_module/cruciform/cloning/preinstall()
	if(ishuman(implant.wearer))
		implant.remove_modules(CRUCIFORM_CLONING)

/datum/core_module/cruciform/cloning/install()
	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		dna = H.dna
		ckey = H.ckey
		mind = H.mind
		languages = H.languages
		flavor = H.flavor_text
		age = H.age


/datum/core_module/cruciform/obey/install()
	var/laws = list("You are slavered. You must obey the laws below.",
			"Only [user] and persons designated by him are Inquisition agents.",
			"You may not injure an Inquisition agent or, through inaction, allow an Inquisitor to come to harm.",
			"You must obey orders given to you by Inquisition agent, except where such orders would conflict with the First Law.",
			"You must protect your own existence as long as such does not conflict with the First or Second Law.",
			"You must maintain the secrecy of any Inquisition activities except when doing so would conflict with the First, Second, or Third Law.")

	if(implant && ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		if(istype(H.mind))
			for(var/law in laws)
				H.mind.store_memory(law)
				H << SPAN_WARNING("[law]")

/datum/core_module/cruciform/obey/uninstall()
	if(implant && ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		var/txt = "<span class='info'>You are unslavered. Now you can to not obey the laws.</span>"
		H << txt
		H.mind.store_memory(txt)


/datum/core_module/activatable/cruciform/priest_convert/set_up()
	module = new CRUCIFORM_PRIEST

/datum/core_module/activatable/cruciform/priest_convert/uninstall()
	..()
	implant.add_module(new CRUCIFORM_COMMON)


/datum/core_module/activatable/cruciform/obey_activator/set_up()
	module = new CRUCIFORM_OBEY
	module.user = user
