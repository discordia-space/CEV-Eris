
/obj/item/cyberstick
	name = "cyberstick"
	icon = 'icons/obj/shard.dmi'
	icon_state = ""
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
	bad_type = /obj/item/cyberstick
	rarity_value = 200
	spawn_tags = SPAWN_ODDITY

/obj/item/cyberstick/Destroy(force)
	holdingSlot = null
	. = ..()

/obj/item/cyberstick/proc/onInstall(mob/living/carbon/human/user)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER + 1
	var/matrix/transf = new(transform)
	transf.Turn(-90)
	transform = transf
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
	transform = initial(transform)
	mouse_opacity = initial(mouse_opacity)
	return TRUE

/// technomancers
/obj/item/cyberstick/engineering_analysis
	name = "Cyberstick - League's blessing"
	desc = "A cyberstick containing various secrets of technomancy. Most notably, telling what wires do what."
	icon_state = "see_wires"
	spawn_blacklisted = TRUE
	cyberFlags = CSF_SEE_WIRES

/obj/item/cyberstick/engineering_booster
	name = "Cyberstick - Teachings of the repairer"
	desc = "A cyberstick containing various general purpose information about engineering , material science and electromagnetic phenomenons."
	icon_state = "mec_boost"
	skillBoosts = list(
		STAT_MEC = 15,
		STAT_COG = 10
	)

/// Ironhammer
/obj/item/cyberstick/security_analysis
	name = "Cyberstick - IH tactical analysis"
	desc = "A cyberstick making use of a highly-simplified tactical AI. Will give you basic readouts of someone's skills"
	icon_state = "scan_stat"
	spawn_blacklisted = TRUE
	cyberFlags = CSF_COMBAT_READER


/*
/obj/item/cyberstick/operative
	name = "Cyberstick - IH combat arts"
	desc = "A cyberstick module containing information about various fighting styles. Helps with general CQC combat"
	icon_state = "stick_ih"
	skillBoosts = list(
		STAT_TGH = 15,
		STAT_ROB = 10
	)
*/

/obj/item/cyberstick/ironhammer_scanner
	name = "Cyberstick - IH scanner"
	desc = "A cyberstick making use of bluespace technologies to scan the contents of a object. Has a maximum depth of 1."
	icon_state = "see_pockets"
	cyberFlags = CSF_CONTENTS_READER

// Syndicate old-tech

/obj/item/cyberstick/syndicate
	name = "Cyberstick prototype - Syndicate hypercognition"
	desc = "A experimental cyberstick created when the technology was just invented. Significantly boosts combat toughness and aiming"
	icon_state = "goon_stat_boost"
	skillBoosts = list(
		STAT_VIG = 25,
		STAT_TGH = 30
	)
	rarity_value = 300
// Moebius
/obj/item/cyberstick/science_analysis
	name = "Cyberstick - Moebius liquid-metanalysis"
	desc = "A cyberstick module which analyses the colour of any reagent. Will tell you what reagents it thinks you're seeing"
	icon_state = "see_chems"
	cyberFlags = CSF_SEE_REAGENTS

/obj/item/cyberstick/medical_booster
	name = "Cyberstick - Hippocrate's touch"
	desc = "A cyberstick module containing data about medical procedures , the general functioning of the human body, and protocols for safe surgery."
	icon_state = "bio_boost"
	skillBoosts = list(
		STAT_BIO = 20
	)

/obj/item/cyberstick/science_booster
	name = "Cyberstick - Moebius primer"
	desc = "A cyberstick module containing information about various scientific standards employed by Moebius Technologies."
	icon_state = "nerd_stat_boost"
	skillBoosts = list(
		STAT_COG = 10,
		STAT_BIO = 10
	)
	rarity_value = 250
/obj/item/cyberstick/maintenance_wired
	name = "Cyberstick - makeshift mechanical booster"
	desc = "A cyberstick of makeshift . Will boost(?) your mechanical abilities."
	icon_state = "mec_boost_junk"
	skillBoosts = list()
	rarity_value = 125

/obj/item/cyberstick/maintenance_wired/Initialize()
	. = ..()
	skillBoosts = list(
		STAT_MEC = rand(-10,15)
	)

/obj/item/cyberstick/wealth_judge
	name = "Cyberstick - nobility identifier"
	desc = "A cyberstick of... noble origin?"
	icon_state = "net_worth"
	rarity_value = 30
	cyberFlags = CSF_WEALTH_JUDGE
	spawn_tags = SPAWN_TAG_SCIENCE_JUNK

/obj/item/cyberstick/military
	name = "Cyberstick - Oberth primer"
	desc = "A cyberstick of oberth origin , famously used by mass-recruited soldiers to be on par with veterans. Time seems to have degraded it"
	icon_state = "see_pockets"
	skillBoosts = list()
	rarity_value = 400

/obj/item/cyberstick/military/Initialize()
	. = ..()
	skillBoosts = list(
		STAT_TGH = rand(5,10),
		STAT_ROB = rand(5,15),
		STAT_VIG = rand(5,15)
	)

/obj/item/cyberstick/rob_boost
	name = "Cyberstick - Robustness booster"
	desc = "A cyberstick which boosts your robustness."
	icon_state = "rob_boost"
	skillBoosts = list(
		STAT_ROB = 15
	)
	rarity_value = 50

/obj/item/cyberstick/rob_boost
	name = "Cyberstick - Toughness booster"
	desc = "A cyberstick which boosts your toughness."
	icon_state = "tgh_boost"
	skillBoosts = list(
		STAT_TGH = 15
	)
	rarity_value = 50

/obj/item/cyberstick/rob_boost
	name = "Cyberstick - Vigilance booster"
	desc = "A cyberstick which boosts your vigilance."
	icon_state = "vig_boost"
	skillBoosts = list(
		STAT_VIG = 15
	)
	rarity_value = 50

/// insanely powerfull if you let it go deeper as it could read PEOPLE.
/obj/item/cyberstick/guilds_edge
	name = "Cyberstick - Guilds edge"
	desc = "A cyberstick manufactured by the aster's guild. Uses bluespace manipulation to find out what others are carrying. Only works for items with 1 layer of matter encapsulation."
	icon_state = "see_money"
	skillBoosts = list()
	cyberFlags = CSF_CONTENTS_READER|CSF_BANKING_READER

/obj/item/cyberstick/taste_reader
	name = "Cyberstick - Taste reader"
	desc = "A cyberstick made by leading cookware companies. It tells you what something would taste like."
	icon_state = "see_booze"
	skillBoosts = list()
	cyberFlags = CSF_TASTE_READER
	rarity_value = 120
	spawn_tags = SPAWN_JUNK

/obj/item/cyberstick/lore_common
	name = "Cyberstick - Public knowledge archives"
	desc = "A cyberstick containing information about past events. This one seems to trigger only when examining a item it knows a event related to."
	icon_state = "see_lore"
	skillBoosts = list()
	cyberFlags = CSF_LORE_COMMON_KNOWLEDGE
	rarity_value = 80
	spawn_tags = SPAWN_JUNK

/obj/item/cyberstick/implant_blocker
	name = "Cyberstick - Implant blocker"
	desc = "A cyberstick containing a program that will block most implants from triggering."
	icon_state = "disable_implants"
	skillBoosts = list()
	rarity_value = 100


