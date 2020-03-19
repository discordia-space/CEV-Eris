
/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = "kitty"
	body_parts_covered = 0
	item_icons = list()

/obj/item/clothing/head/kitty/equipped(mob/user, slot)
	if(slot == slot_head)
		update_icon(user)
	..()

/obj/item/clothing/head/kitty/update_icon(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/icon/ears = new/icon('icons/inventory/head/mob.dmi', "kitty")
	ears.Blend(user.hair_color, ICON_ADD)

	var/icon/earbit = new/icon('icons/inventory/head/mob.dmi', "kittyinner")
	ears.Blend(earbit, ICON_OVERLAY)
	
/obj/item/organ_module/active/simple/neko
	name = "neko ears"
	desc = "lifelike neko ears in high demand by FS customers"
	verb_name = "Deploy ears"
	icon_state = "kitty"
	matter = list(MATERIAL_PLASTIC = 5)
	allowed_organs = list(BP_HEAD)
	holding_type = /obj/item/clothing/head/kitty

