/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("warned", "cautioned", "smashed")
	rarity_value = 5
	spawn_tags = SPAWN_TAG_JUNK
	price_tag = 10
	matter = list(MATERIAL_PLASTIC = 4)

/obj/item/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"
	matter = list(MATERIAL_PLASTIC = 2)

