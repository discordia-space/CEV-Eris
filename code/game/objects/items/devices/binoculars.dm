/obj/item/device/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	icon_state = "binoculars"

	flags = CONDUCT
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE, 7)
		)
	)
	volumeClass = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_WEAK
	throw_range = 15
	throw_speed = 3

	matter = list(MATERIAL_PLASTIC = 3, MATERIAL_GLASS = 1)


/obj/item/device/binoculars/attack_self(mob/user)
	zoom()
