/obj/item/clothing/under/excelsior
	name = "random excelsior jumpsuit"
	desc = "Reject decadent capitalist 'fashion', embrace the liberation of true revolutionary style"
	icon_state = "excelsior_white"
	item_state = "bl_suit"
	has_sensor = 0
	spawn_blacklisted = TRUE
	armor = list(
		melee = 2,
		bullet = 2,
		energy = 2,
		bomb = 5,
		bio = 0,
		rad = 0
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
