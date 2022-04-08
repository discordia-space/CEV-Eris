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
	name = "emergency space helmet"
	icon_state = "emergencyhelm"
	item_state = "syndi_helm_erm"	//currently not working somehow
	desc = "A simple helmet with a built in light, smells like mothballs."
	light_overlay = "helmet_light_syndi_soft"
	flash_protection = FLASH_PROTECTION_MINOR

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	icon_state = "emergency_suit"
	item_state = "emergency_suit"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	accompanying_object = /obj/item/clothing/head/space/emergency
	slowdown = HEAVY_SLOWDOWN
