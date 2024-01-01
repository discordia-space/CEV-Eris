#define CSF_SEE_WIRES 1<<0
#define CSF_SEE_REAGENTS 1<<1
#define CSF_COMBAT_READER 1<<2

/obj/item/cyberstick
	name = "cyberstick"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant_health"
	volumeClass = ITEM_SIZE_TINY
	matter = list(MATERIAL_STEEL = 1, MATERIAL_GLASS = 1)
	var/list/skillBoosts = list(
		STAT_BIO = 0,
		STAT_COG = 0,
		STAT_MEC = 0,
		STAT_ROB = 0,
		STAT_TGH = 0,
		STAT_VIG = 0
	)
	var/cyberFlags = null

/obj/item/cyberstick/proc/onInstall(mob/living/carbon/human/user)
	if(user)
		for(var/stat in skillBoosts)
			user.stats.addTempStat(stat, skillBoosts[stat], INFINITY, "\ref[src]")
	return TRUE

/obj/item/cyberstick/proc/onUninstall(mob/living/carbon/human/formerUser)
	if(formerUser)
		for(var/stat in skillBoosts)
			formerUser.stats.removeTempStat(stat,"\ref[src]")
	return TRUE

/obj/item/cyberstick/engineering
	name = "Cyberstick - League's blessing"
	desc = "A cyberstick containing various secrets of technomancy. Most notably, telling what wires do what."
	skillBoosts = list(
		STAT_MEC = 5
	)
	cyberFlags = CSF_SEE_WIRES

/obj/item/cyberstick/security
	name = "Cyberstick - IH tactical analysis"
	desc = "A cyberstick making use of a highly-simplified tactical AI. Will give you basic readouts of someone's skills"
	skillBoosts = list(
		STAT_VIG = 5
	)
	cyberFlags = CSF_COMBAT_READER

/obj/item/cyberstick/science
	name = "Cyberstick - Moebius liquid-metanalysis"
	desc = "A cyberstick module which analyses the colour of any reagent. Will tell you what reagents it thinks you're seeing"
	skillBoosts = list(
		STAT_COG = 5
	)
	cyberFlags = CSF_SEE_REAGENTS

