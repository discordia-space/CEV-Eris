// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/crewman
	display_name = "jumpsuit, crewman"
	path = /obj/item/clothing/under/rank/crewman

/datum/gear/uniform/jumpsuit/rainbow
	display_name = "jumpsuit, rainbow"
	path = /obj/item/clothing/under/rainbow

/datum/gear/uniform/jumpsuit/color_presets
	display_name = "jumpsuit, color presets"
	path = /obj/item/clothing/under/aqua
	cost = 2

/datum/gear/uniform/jumpsuit/color_presets/New()
	..()
	var/jumpsuit = list(
		"Black"			=	/obj/item/clothing/under/color/black,
		"White"			=	/obj/item/clothing/under/color/white,
		"Blue"			=	/obj/item/clothing/under/color/blue,
		"Green"			=	/obj/item/clothing/under/color/green,
		"Grey"			=	/obj/item/clothing/under/color/grey,
		"Pink"			=	/obj/item/clothing/under/color/pink,
		"Yellow"		=	/obj/item/clothing/under/color/yellow,
		"Light-Blue"	=	/obj/item/clothing/under/lightblue,
		"Red"			=	/obj/item/clothing/under/color/red,
		"Aqua"			=	/obj/item/clothing/under/aqua,
		"Purple"		=	/obj/item/clothing/under/purple,
		"Light-Purple"	=	/obj/item/clothing/under/lightpurple,
		"Light-Green"	=	/obj/item/clothing/under/lightgreen,
		"Light-Brown"	=	/obj/item/clothing/under/lightbrown,
		"Brown"			=	/obj/item/clothing/under/brown,
		"Yellow-Green"	=	/obj/item/clothing/under/yellowgreen,
		"Dark-Blue"		=	/obj/item/clothing/under/darkblue,
		"Light-Red"		=	/obj/item/clothing/under/lightred,
		"Dark-Red"		=	/obj/item/clothing/under/darkred,
	)
	gear_tweaks += new /datum/gear_tweak/path(jumpsuit)

/datum/gear/uniform/jumpsuit/colorable
	display_name = "jumpsuit, colorable"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/under/color/white

/datum/gear/uniform/leisure
	display_name = "leisure suits"
	path = /obj/item/clothing/under/leisure

/datum/gear/uniform/leisure/New()
	..()
	var/leisure = list(
		"Brown Jacket"			=	/obj/item/clothing/under/leisure,
		"White Blazer"			=	/obj/item/clothing/under/leisure/white,
		"Patterned Pullover"	=	/obj/item/clothing/under/leisure/pullover
	)
	gear_tweaks += new /datum/gear_tweak/path(leisure)

/datum/gear/uniform/dress
	display_name = "dresses"
	path = /obj/item/clothing/under/dress

/datum/gear/uniform/dress/New()
	..()
	var/dress = list(
		"Gray Dress"			=	/obj/item/clothing/under/dress/gray,
		"Blue Dress"			=	/obj/item/clothing/under/dress/blue,
		"Red Dress"				=	/obj/item/clothing/under/dress/red
	)
	gear_tweaks += new /datum/gear_tweak/path(dress)

/datum/gear/uniform/security_skirt
	display_name = "jumpskirt, operative"
	path = /obj/item/clothing/under/rank/security/skirt
	allowed_roles = list("Ironhammer Operative")

/datum/gear/uniform/medspec_skirt
	display_name = "jumpskirt, medical specialist"
	path = /obj/item/clothing/under/rank/medspec/skirt
	allowed_roles = list("Ironhammer Medical Specialist")

/datum/gear/uniform/warden_skirt
	display_name = "jumpskirt, warden"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Ironhammer Gunnery Sergeant")

/datum/gear/uniform/hos_skirt
	display_name = "jumpskirt, commander"
	path = /obj/item/clothing/under/rank/ih_commander/skirt
	allowed_roles = list("Ironhammer Commander")

/*/datum/gear/uniform/skirt
	display_name = "plaid skirt, blue"
	path = /obj/item/clothing/under/dress/plaid_blue

/datum/gear/uniform/skirt/purple
	display_name = "plaid skirt, purple"
	path = /obj/item/clothing/under/dress/plaid_purple

/datum/gear/uniform/skirt/red
	display_name = "plaid skirt, red"
	path = /obj/item/clothing/under/dress/plaid_red*/

/*/datum/gear/uniform/suit  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit*/

/datum/gear/uniform/scrubs/color_presets
	display_name = "scrubs, color presets"
	path = /obj/item/clothing/under/rank/medical/blue

/datum/gear/uniform/scrubs/color_presets/New()
	..()
	var/jumpsuit = list(
		"Green"			=	/obj/item/clothing/under/rank/medical/green,
	)
	gear_tweaks += new /datum/gear_tweak/path(jumpsuit)

/datum/gear/uniform/neon
	display_name = "neon tracksuits, color presets"
	path = /obj/item/clothing/under/neon

/datum/gear/uniform/neon/New()
	..()
	var/neon = list(
		"green"			=	/obj/item/clothing/under/neon,
		"yellow"			=	/obj/item/clothing/under/neon/yellow,
		"blue"	=	/obj/item/clothing/under/neon/blue,
		"red" = /obj/item/clothing/under/neon/red
	)
	gear_tweaks += new /datum/gear_tweak/path(neon)

/datum/gear/uniform/cyber
	display_name = "augmented jumpsuit"
	path = /obj/item/clothing/under/cyber

/datum/gear/uniform/jersey
	display_name = "revealing jersey"
	path = /obj/item/clothing/under/jersey

/datum/gear/uniform/generic
	display_name = "generic outfit, color presets"
	path = /obj/item/clothing/under/genericb

/datum/gear/uniform/generic/New()
	..()
	var/generic = list(
		"blue" = /obj/item/clothing/under/genericb,
		"red" = /obj/item/clothing/under/genericr,
		"white" = /obj/item/clothing/under/genericw
	)
	gear_tweaks += new /datum/gear_tweak/path(generic)

/datum/gear/uniform/tuxedo
	display_name = "cheap tuxedo"
	path = /obj/item/clothing/under/tuxedo/cheap
	cost = 2

/datum/gear/uniform/security_formal
	display_name = "formal security outfit"
	path = /obj/item/clothing/under/security_formal
	allowed_roles = list(JOBS_SECURITY)
	cost = 2

/datum/gear/uniform/assistantformal
	display_name = "assistant formal uniform"
	path = /obj/item/clothing/under/assistantformal
	cost = 2
	allowed_roles = list(ASSISTANT_TITLE)

/datum/gear/uniform/camopants
	display_name = "turtleneck and camo pants"
	path = /obj/item/clothing/under/camopants

/datum/gear/uniform/wifebeater
	display_name = "white tank top"
	path = /obj/item/clothing/under/wifebeater

/*/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("First Officer")*/

/datum/gear/uniform/soviet
	display_name = "soviet uniform"
	path = /obj/item/clothing/under/soviet

/datum/gear/uniform/battledress_serb
	display_name = "battle dress uniform, serbian"
	path = /obj/item/clothing/under/serbiansuit

/datum/gear/uniform/battledress_serb/New()
	..()
	var/battledress_serb = list(
		"green"	=	/obj/item/clothing/under/serbiansuit,
		"brown"	=	/obj/item/clothing/under/serbiansuit/brown,
		"black"	=	/obj/item/clothing/under/serbiansuit/black
	)
	gear_tweaks += new /datum/gear_tweak/path(battledress_serb)

/datum/gear/uniform/battledress_german
	display_name = "battle dress uniform, oberth"
	path = /obj/item/clothing/under/germansuit

/datum/gear/uniform/ntsec
	display_name = "Nanotrasen security uniform"
	path = /obj/item/clothing/under/ntsec
	allowed_roles = list(ASSISTANT_TITLE)
