// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/jumpsuit/rainbow
	display_name = "jumpsuit, rainbow"
	path = /obj/item/clothing/under/rainbow

/datum/gear/uniform/jumpsuit/color_presets
	display_name = "jumpsuit, color presets"
	path = /obj/item/clothing/under/color/grey
	cost = 1

/datum/gear/uniform/jumpsuit/color_presets/New()
	..()
	var/jumpsuit = list(
		"Black"			=	/obj/item/clothing/under/color/black,
		"White"			=	/obj/item/clothing/under/color/white,
		"Grey"			=	/obj/item/clothing/under/color/grey,
		"Orange"		=	/obj/item/clothing/under/color/orange,
		"Crewman"		= 	/obj/item/clothing/under/rank/crewman
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
		"Brown Jacket" 			=	 /obj/item/clothing/under/leisure,
		"White Blazer" 			=	 /obj/item/clothing/under/leisure/white,
		"Patterned Pullover" 	=	 /obj/item/clothing/under/leisure/pullover,
		"Business Casual"		=	 /obj/item/clothing/under/leisure/joe
	)
	gear_tweaks += new /datum/gear_tweak/path(leisure)

/datum/gear/uniform/dress
	display_name = "dresses"
	path = /obj/item/clothing/under/dress/gray

/datum/gear/uniform/dress/New()
	..()
	var/dress = list(
		"Gray Dress" 	=	 /obj/item/clothing/under/dress/gray,
		"Blue Dress" 	=	 /obj/item/clothing/under/dress/blue,
		"Red Dress" 	=	 /obj/item/clothing/under/dress/red,
		"Purple Dress" 	=	 /obj/item/clothing/under/dress/purple,
		"White Dress" 	=	 /obj/item/clothing/under/dress/white,
		"Gray Dress" 	=	 /obj/item/clothing/under/dress/gray
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
		"green"			=	/obj/item/clothing/under/rank/medical/green,
		"purple"		=	/obj/item/clothing/under/rank/medical/purple,
		"blue"			=	/obj/item/clothing/under/rank/medical/blue
	)
	gear_tweaks += new /datum/gear_tweak/path(jumpsuit)

/datum/gear/uniform/neon
	display_name = "neon tracksuits, color presets"
	path = /obj/item/clothing/under/neon

/datum/gear/uniform/neon/New()
	..()
	var/neon = list(
		"green"		=	/obj/item/clothing/under/neon,
		"yellow"	=	/obj/item/clothing/under/neon/yellow,
		"blue"		=	/obj/item/clothing/under/neon/blue,
		"red" 		= 	/obj/item/clothing/under/neon/red
	)
	gear_tweaks += new /datum/gear_tweak/path(neon)

/datum/gear/uniform/cyber
	display_name = "augmented jumpsuit"
	path = /obj/item/clothing/under/cyber

/datum/gear/uniform/generic
	display_name = "generic outfit, color presets"
	path = /obj/item/clothing/under/genericb

/datum/gear/uniform/generic/New()
	..()
	var/generic = list(
		"blue" 			=	 /obj/item/clothing/under/genericb,
		"red" 			=	 /obj/item/clothing/under/genericr,
		"white" 		=	 /obj/item/clothing/under/genericw,
		"beige" 		=	 /obj/item/clothing/under/aerostatic,
		"brown" 		=	 /obj/item/clothing/under/jamrock,
		"tank top" 		=	 /obj/item/clothing/under/wifebeater
	)
	gear_tweaks += new /datum/gear_tweak/path(generic)

/datum/gear/uniform/punk
	display_name = "punk outfit, selection"
	path = /obj/item/clothing/under/johnny

/datum/gear/uniform/punk/New()
	..()
	var/punk = list(
		"punk" 			=	 /obj/item/clothing/under/johnny,
		"elvis" 		=	 /obj/item/clothing/under/raider,
		"jersey" 		=	 /obj/item/clothing/under/jersey,
		"tracksuit" 	=	 /obj/item/clothing/under/storage/tracksuit
	)
	gear_tweaks += new /datum/gear_tweak/path(punk)

/datum/gear/uniform/suits
	display_name = "suits, selection"
	path = /obj/item/clothing/under/black

/datum/gear/uniform/suits/New()
	..()
	var/suits = list(
		"green" 		=	 /obj/item/clothing/under/green,
		"red" 			=	 /obj/item/clothing/under/red,
		"red formal" 	=	 /obj/item/clothing/under/helltaker,
		"white" 		=	 /obj/item/clothing/under/white,
		"ash" 			=	 /obj/item/clothing/under/grey,
		"charcoal" 		=	 /obj/item/clothing/under/black,
		"black formal" 	=	 /obj/item/clothing/under/tuxedo,
		"tuxedo" 		=	 /obj/item/clothing/under/assistantformal
	)
	gear_tweaks += new /datum/gear_tweak/path(suits)

/datum/gear/uniform/security_formal
	display_name = "formal security outfit"
	path = /obj/item/clothing/under/security_formal
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/uniform/camopants
	display_name = "turtleneck and camo pants"
	path = /obj/item/clothing/under/camopants

/*/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("First Officer")*/

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
	display_name = "old security uniform"
	path = /obj/item/clothing/under/oldsec
	allowed_roles = list(ASSISTANT_TITLE)
