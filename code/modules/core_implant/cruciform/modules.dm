/datum/core_module/cruciform/implant_type = /obj/item/weapon/implant/core_implant/cruciform


/datum/core_module/cruciform/red_light/install()
	implant.icon_state = "cruciform_red"
	implant.max_power = 80
	implant.power_regen = 0.8

	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()

/datum/core_module/cruciform/red_light/uninstall()
	implant.icon_state = "cruciform_green"
	implant.max_power = 50
	implant.power_regen = 0.5

	if(ishuman(implant.wearer))
		var/mob/living/carbon/human/H = implant.wearer
		H.update_implants()


/datum/core_module/cruciform/uplink
	var/telecrystals = 15

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
	var/laws = list("You are enslaved. You must obey the laws below.",
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
	implant.remove_modules(CRUCIFORM_PRIEST)


/datum/core_module/activatable/cruciform/obey_activator/set_up()
	module = new CRUCIFORM_OBEY
	module.user = user


/datum/core_module/cruciform/christianhud

/datum/core_module/cruciform/christianhud/proc/update_crucihud()
	if(implant.wearer.client)
		for(var/mob/living/carbon/human/christian in christians)
			var/image/I = image('icons/mob/hud.dmi', christian, icon_state = "hudcyberchristian", layer = ABOVE_LIGHTING_LAYER)
			implant.wearer.client.images += I
		implant.use_power(1)
		if(implant.power < 1)
			implant.wearer << SPAN_WARNING("Your cruciform pings. The energy is low.")
			implant.remove_module(src)

///////////

/datum/core_module/rituals/cruciform
	implant_type = /obj/item/weapon/implant/core_implant/cruciform


/datum/core_module/rituals/cruciform/base/set_up()
	rituals = subtypesof(/datum/ritual/cruciform/base)+subtypesof(/datum/ritual/targeted/cruciform/base)
	rituals += subtypesof(/datum/ritual/group/cruciform)

/datum/core_module/rituals/cruciform/priest/set_up()
	rituals = subtypesof(/datum/ritual/cruciform/priest)+subtypesof(/datum/ritual/targeted/cruciform/priest)



/datum/core_module/rituals/cruciform/inquisitor/set_up()
	rituals = subtypesof(/datum/ritual/inquisitor)+subtypesof(/datum/ritual/targeted/inquisitor)


/datum/core_module/rituals/cruciform/crusader/set_up()
	rituals = list()