/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = 0 //doesn't protect eyes because it's a monocle, duh
	prescription = TRUE
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2)
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1, MATERIAL_SILVER = 0.5)
	price_tag = 200
	bad_type = /obj/item/clothing/glasses/hud
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/proc/process_hud(mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/hud/process_hud(mob/M)
	return

/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	body_parts_covered = 0


/obj/item/clothing/glasses/hud/health/process_hud(mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	body_parts_covered = 0
	var/global/list/jobs[0]

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "Augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	spawn_blacklisted = TRUE

/obj/item/clothing/glasses/hud/security/process_hud(mob/M)
	process_sec_hud(M, 1)

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	prescription = TRUE

	New()
		..()
		src.hud = new/obj/item/clothing/glasses/hud/security(src)
		return

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "Ironhammer tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"

/obj/item/clothing/glasses/hud/broken/process_hud(mob/M)
	process_broken_hud(M, 1)


/obj/item/clothing/glasses/hud/excelsior
	name = "Excelsior HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their opinion on communism."
	icon_state = "excelhud"
	body_parts_covered = 0
	spawn_blacklisted = TRUE

/obj/item/clothing/glasses/hud/excelsior/process_hud(mob/M)
	if(is_excelsior(M))
		process_excel_hud(M)

/obj/item/clothing/glasses/hud/excelsior/equipped(mob/M)
	. = ..()

	var/mob/living/carbon/human/H = M
	if(!istype(H) || H.glasses != src)
		return

	if(!is_excelsior(H))
		to_chat(H, SPAN_WARNING("The hud fails to activate, a built-in speaker says, \"Failed to locate implant, please contact your nearest Excelsior representative immediately for assistance\"."))
