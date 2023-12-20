/obj/item/gym_ticket
	name = "electronic ticket"
	desc = "An electronic ticket used by the Club exercise equipment."
	description_info = "Gym structures can use rest points to permanently increase your stats. Otherwise, they only temporary increase them."
	icon = 'icons/obj/gym_ticket.dmi'
	icon_state = "gym_ticket"
	volumeClass = ITEM_SIZE_TINY
	throwforce = WEAPON_FORCE_HARMLESS
	rarity_value = 40
	spawn_tags = SPAWN_TAG_RARE_ITEM
	var/used = FALSE

/obj/item/gym_ticket/used
	name = "used electronic ticket"
	icon_state = "gym_ticket_used"
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 80
	used = TRUE

/obj/item/gym_ticket/proc/use()
	if(!used)
		name = "used electronic ticket"
		icon_state = "gym_ticket_used"
		used = TRUE
		return TRUE
	else
		to_chat(src, SPAN_WARNING("The holographic ticket is spent and cannot be used."))
		return FALSE
