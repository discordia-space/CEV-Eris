/obj/item/organ_module/armor
	name = "subdermal armor"
	desc = "A set of subdermal steel plates meant to be inserted into the torso. When inserted, they attach themselves to the ribcage and start producing nanomachines, which reduce the physical damage taken by the whole body by approximately 30%. They can be safely removed and reused; however, the nanomachines go inert in body without these plates."
	allowed_organs = list(BP_CHEST)
	icon_state = "armor-chest"

/obj/item/organ_module/armor/onInstall(obj/item/organ/external/E)
	E.brute_mod -= 0.3

/obj/item/organ_module/armor/onRemove(obj/item/organ/external/E)
	E.brute_mod += 0.3
