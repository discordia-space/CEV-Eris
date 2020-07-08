/obj/item/clothing/under/excelsior
	name = "random excelsior jumpsuit"
	desc = "Excelsior jumpsuit designed to boost morale and spread the revolution"
	icon_state = "excelsior_white"
	item_state = "bl_suit"
	has_sensor = 0

/obj/item/clothing/under/excelsior/New()
	name = "white excelsior jumpsuit"
	if (prob(66))
		name = "mixed excelsior jumpsuit"
		icon_state = "excelsior_mixed"
		if (prob(50))
			name = "orange excelsior jumpsuit"
			icon_state = "excelsior_orange"
