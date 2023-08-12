/obj/item/implanter/installer/disposable/armor
	name = "disposable cybernetic installer (armor)"
	desc = "A set of subdermal steel plates, designed to provide additional impact protection to the torso while remaining lightweight."
	mod = /obj/item/organ_module/armor
	spawn_tags = null

/obj/item/organ_module/armor
	name = "subdermal armor"
	desc = "A set of subdermal steel plates, designed to provide additional impact protection to the torso while remaining lightweight."
	allowed_organs = list(BP_CHEST)
	icon_state = "armor-chest"
	mod_overlay = "installer_armor"
/obj/item/organ_module/armor/onInstall(obj/item/organ/external/E)
	E.brute_mod -= 0.3

/obj/item/organ_module/armor/onRemove(obj/item/organ/external/E)
	E.brute_mod += 0.3
