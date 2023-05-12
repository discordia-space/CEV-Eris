/obj/item/clothing/under/excelsior
	name = "random excelsior jumpsuit"
	desc = "Excelsior jumpsuit designed to boost morale and spread the revolution"
	icon_state = "excelsior_white"
	item_state = "bl_suit"
	has_sensor = 0
	spawn_blacklisted = TRUE
		armor = list(
		melee = 2,
		bullet = 4,
		energy = 2,
		bomb = 2,
		bio = 5,
		rad = 5,
		)

/obj/item/clothing/under/excelsior/Initialize(mapload, ...)
	. = ..()
	name = "white excelsior jumpsuit"
	if(prob(66))
		name = "mixed excelsior jumpsuit"
		icon_state = "excelsior_mixed"
		if(prob(50))
			name = "orange excelsior jumpsuit"
			icon_state = "excelsior_orange"
