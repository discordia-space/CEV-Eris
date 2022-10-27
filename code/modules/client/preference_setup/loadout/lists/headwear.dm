/datum/gear/head
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana_green
	display_name = "bandana, green"
	path = /obj/item/clothing/head/bandana/green

/datum/gear/head/bandana_orange
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/bandana/orange

/datum/gear/head/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/ntsec
	display_name = "beret, old nanotrasen"
	path = /obj/item/clothing/head/beret/ntsec
	allowed_roles = list(ASSISTANT_TITLE)

/datum/gear/head/beret/bsec
	display_name = "beret, Operative"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/head/beret/bsec_warden
	display_name = "beret, Sergeant"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list("Ironhammer Commander","Gunnery Sergeant")

/datum/gear/head/beret/bsec_hos
	display_name = "beret, Lieutenant"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list("Ironhammer Commander")

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list(JOBS_ENGINEERING)

/datum/gear/head/cap/flat
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/corp
	display_name = "cap, corporate security"
	path = /obj/item/clothing/head/soft/sec/corp

/datum/gear/head/cap/sec
	display_name = "cap, old nanotrasen"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list(ASSISTANT_TITLE)

/datum/gear/head/cap/rainbow
	display_name = "cap, rainbow"
	path = /obj/item/clothing/head/soft/rainbow

/datum/gear/head/cap/color_presets
	display_name = "cap, color presets"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/color_presets/New()
	..()
	var/cap = list(
		"White"			=	/obj/item/clothing/head/soft/mime,
		"Grey"			=	/obj/item/clothing/head/soft/grey,
		"Brown-Flat"	=	/obj/item/clothing/head/flatcap,
		"Red"			=	/obj/item/clothing/head/soft/red,
		"Orange"		=	/obj/item/clothing/head/soft/orange,
		"Yellow"		=	/obj/item/clothing/head/soft/yellow,
		"Green"			=	/obj/item/clothing/head/soft/green,
		"Blue"			=	/obj/item/clothing/head/soft/blue,
		"Blue Station"	=	/obj/item/clothing/head/mailman,
		"Purple"		=	/obj/item/clothing/head/soft/purple,
	)
	gear_tweaks += new /datum/gear_tweak/path(cap)

/datum/gear/head/hairflower
	display_name = "hair flower pin, red"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/hardhat/color_presets
	display_name = "hardhat, color presets"
	path = /obj/item/clothing/head/hardhat/blue
	cost = 2

/datum/gear/head/hardhat/color_presets/New()
	..()
	var/hardhat = list(
		"Red"		=	/obj/item/clothing/head/hardhat/red,
		"Orange"	=	/obj/item/clothing/head/hardhat/orange,
		"Yellow"	=	/obj/item/clothing/head/hardhat,
		"Blue"		=	/obj/item/clothing/head/hardhat/blue,
	)
	gear_tweaks += new /datum/gear_tweak/path(hardhat)

/datum/gear/head/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler

/datum/gear/head/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/cap/secfield
	display_name = "cap, IH field"
	path = /obj/item/clothing/head/soft/sec2soft
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/head/cap/sarge
	display_name = "cap, IH sergeant"
	path = /obj/item/clothing/head/soft/sarge2soft
	allowed_roles = list("Ironhammer Commander","Ironhammer Gunnery Sergeant")

/datum/gear/head/cyberpunkgoggle
	display_name = "Type-34C Semi-Enclosed Headwear"
	path = /obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle
	cost = 2

/datum/gear/head/cap/military
    display_name = "military cap, color presets"
    path = /obj/item/clothing/head/soft/green2soft

/datum/gear/head/cap/military/New()
    ..()
    var/battledress_serb = list(
        "Green" = /obj/item/clothing/head/soft/green2soft,
        "Tan" = /obj/item/clothing/head/soft/tan2soft
    )
    gear_tweaks += new /datum/gear_tweak/path(battledress_serb)

/datum/gear/head/tanker_helmet/color_presets
	display_name = "tanker helmet, color presets"
	path = /obj/item/clothing/head/armor/helmet/tanker
	allowed_roles = list("Moebius Roboticist", "Guild Technician", "Technomancer", "Technomancer Exultant", ASSISTANT_TITLE)
	cost = 2

/datum/gear/head/tanker_helmet/color_presets/New()
	..()
	var/tanker_helmet = list(
		"Black"		=	/obj/item/clothing/head/armor/helmet/tanker,
		"Green"		=	/obj/item/clothing/head/armor/helmet/tanker/green,
		"Brown"		=	/obj/item/clothing/head/armor/helmet/tanker/brown,
		"Gray"		=	/obj/item/clothing/head/armor/helmet/tanker/gray,
	)
	gear_tweaks += new /datum/gear_tweak/path(tanker_helmet)



/datum/gear/head/cowboy
    display_name = "cowboy hat, color and size presets"
    path = /obj/item/clothing/head/cowboy

/datum/gear/head/cowboy/New()
    ..()
    var/cowboy = list(
		"Brown"			= /obj/item/clothing/head/cowboy,
		"Black"			= /obj/item/clothing/head/cowboy/black,
		"White"			= /obj/item/clothing/head/cowboy/white,
		"Wide, brown"	= /obj/item/clothing/head/cowboy/wide,
		"Wide, black"	= /obj/item/clothing/head/cowboy/wide/black,
		"Wide, white"	= /obj/item/clothing/head/cowboy/wide/white
	)
    gear_tweaks += new /datum/gear_tweak/path(cowboy)
