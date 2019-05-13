/obj/item/organ_module/armor
	name = "subdermal armor"
	desc = "A set of subdermal steel plates, designed to provide additional impact protection while remaining lightweight."
	allowed_organs = list(BP_CHEST)
	icon_state = "armor-chest"

/obj/item/organ_module/armor/onInstall(obj/item/organ/external/E)
	E.brute_mod -= 0.3

/obj/item/organ_module/armor/onRemove(obj/item/organ/external/E)
	E.brute_mod += 0.3
