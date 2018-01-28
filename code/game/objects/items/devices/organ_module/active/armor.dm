/obj/item/organ_module/armor
	name = "subdermal armor"
	allowed_organs = list(BP_CHEST)
	icon_state = "armor-chest"

/obj/item/organ_module/armor/install(obj/item/organ/external/E)
	E.brute_mod -= 0.3

/obj/item/organ_module/armor/remove(obj/item/organ/external/E)
	E.brute_mod += 0.3
