/obj/item/organ_module/armor
	name = "subdermal armor"
	allowed_organs = list(BP_CHEST)
	icon_state = "armor-chest"

/obj/item/organ_module/armor/onInstall(obj/item/organ/external/E)
	E.brute_mod -= 0.3

/obj/item/organ_module/armor/onRemove(obj/item/organ/external/E)
	E.brute_mod += 0.3
