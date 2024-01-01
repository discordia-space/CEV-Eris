
/obj/item/cyberstick
	name = "cyberstick"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant_health"
	volumeClass = ITEM_SIZE_TINY
	matter = list(MATERIAL_STEEL = 1, MATERIAL_GLASS = 1)
	var/list/skillBoosts = list()
	/*
	list(
		STAT_BIO = 0,
		STAT_COG = 0,
		STAT_MEC = 0,
		STAT_ROB = 0,
		STAT_TGH = 0,
		STAT_VIG = 0
	)
	*/
	var/cyberFlags = null
	var/obj/screen/cyberdeck_slot/holdingSlot = null

/obj/item/cyberstick/Destroy(force)
	holdingSlot = null
	. = ..()

/obj/item/cyberstick/proc/onInstall(mob/living/carbon/human/user)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER + 1
	if(user)
		for(var/stat in skillBoosts)
			user.stats.addTempStat(stat, skillBoosts[stat], INFINITY, "\ref[src]")
	return TRUE

/obj/item/cyberstick/proc/onUninstall(mob/living/carbon/human/formerUser)
	if(formerUser)
		for(var/stat in skillBoosts)
			formerUser.stats.removeTempStat(stat,"\ref[src]")
	plane = initial(plane)
	layer = initial(layer)
	mouse_opacity = initial(mouse_opacity)
	return TRUE

/// technomancers
/obj/item/cyberstick/engineering_analysis
	name = "Cyberstick - League's blessing"
	desc = "A cyberstick containing various secrets of technomancy. Most notably, telling what wires do what."
	icon_state = "stick_technomancer"
	cyberFlags = CSF_SEE_WIRES

/obj/item/cyberstick/engineering_booster
	name = "Cyberstick - Teachings of the repairer"
	desc = "A cyberstick containing various general purpose information about engineering , material science and electromagnetic phenomenons."
	icon_state = "stick_technobooster"
	skillBoosts = list(
		STAT_MEC = 15,
		STAT_COG = 10
	)

/// Ironhammer
/obj/item/cyberstick/security_analysis
	name = "Cyberstick - IH tactical analysis"
	desc = "A cyberstick making use of a highly-simplified tactical AI. Will give you basic readouts of someone's skills"
	icon_state = "stick_ih"
	cyberFlags = CSF_COMBAT_READER


/obj/item/cyberstick/operative
	name = "Cyberstick - IH combat arts"
	desc = "A cyberstick module containing information about various fighting styles. Helps with general CQC combat"
	icon_state = "stick_ih"
	skillBoosts = list(
		STAT_TGH = 15,
		STAT_ROB = 10
	)

// Syndicate old-tech

/obj/item/cyberstick/syndicate
	name = "Cyberstick prototype - Syndicate hypercognition"
	desc = "A experimental cyberstick created when the technology was just invented. Significantly boosts combat toughness and aiming"
	icon_state = "stick_syndicate"
	skillBoosts = list(
		STAT_VIG = 25,
		STAT_TGH = 30
	)
// Moebius
/obj/item/cyberstick/science_analysis
	name = "Cyberstick - Moebius liquid-metanalysis"
	desc = "A cyberstick module which analyses the colour of any reagent. Will tell you what reagents it thinks you're seeing"
	icon_state = "stick_moebius"
	cyberFlags = CSF_SEE_REAGENTS

/obj/item/cyberstick/medical_booster
	name = "Cyberstick - Hippocrate's touch"
	desc = "A cyberstick module containing data about medical procedures , the general functioning of the human body, and protocols for safe surgery."
	icon_state = "stick_medical"
	skillBoosts = list(
		STAT_BIO = 15
	)

