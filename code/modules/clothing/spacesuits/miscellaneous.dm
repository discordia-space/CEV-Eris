//Space santa outfit suit
/obj/item/clothing/head/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	item_state = "santahat"
	item_flags = STOPPRESSUREDAMAGE
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	item_flags = STOPPRESSUREDAMAGE
	allowed = list(/obj/item) //for stuffing exta special presents

//Orange emergency space suit
/obj/item/clothing/head/space/emergency
	name = "Emergency Space Helmet"
	icon_state = "emergencyhelm"
	item_state = "emergencyhelm"
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "Emergency Softsuit"
	icon_state = "emergency_suit"
	item_state = "emergency_suit"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	slowdown = 2

//onestart

/obj/item/clothing/head/space/onestar_helmet
	name = "one start helmet"
	icon_state = "onestar_helmet"
	item_state = "onestar_helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. in perfect one star fashion."
	armor = list(
		melee = 50,
		bullet = 40,
		energy = 40,
		bomb = 50,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/captain
	name = "one start void suit"
	desc = "A brand new one start suit. for your safety and confort!"
	icon_state = "onestart_voidsuit"
	item_state = "onestart_voidsuit"
	slowdown = 0.3
	armor = list(
		melee = 50,
		bullet = 40,
		energy = 40,
		bomb = 50,
		bio = 100,
		rad = 50
	)
	siemens_coefficient = 0.7
