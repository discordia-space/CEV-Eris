// Eyes
/datum/gear/eyes
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"


/datum/gear/eyes/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	cost = 2

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle
	cost = 2

/datum/gear/eyes/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/green_goggles
	display_name = "green goggles"
	path = /obj/item/clothing/glasses/regular/goggles

/datum/gear/eyes/yellow_goggles
	display_name = "black goggles"
	path = /obj/item/clothing/glasses/regular/goggles/black

/datum/gear/eyes/clear_goggles
	display_name = "goggles"
	path = /obj/item/clothing/glasses/regular/goggles/clear

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/powered/science
	allowed_roles = list(JOBS_SCIENCE,"Moebius Bio-Engineer")

/datum/gear/eyes/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/eyes/medical
	display_name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list(JOBS_MEDICAL)

/datum/gear/eyes/shades
	display_name = "Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses
	cost = 2

/datum/gear/eyes/shades/prescriptionsun
	display_name = "Sunglasses, prescription"
	path = /obj/item/clothing/glasses/sunglasses/prescription


/datum/gear/eyes/shades/big
	display_name = "Sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	allowed_roles = list("Ironhammer Operative","Ironhammer Commander","Ironhammer Gunnery Sergeant","Captain","First Officer","Ironhammer Inspector","Guild Merchant","Moebius Biolab Officer","Moebius Expedition Overseer","Technomancer Exultant","Club Manager","NeoTheology Preacher")


