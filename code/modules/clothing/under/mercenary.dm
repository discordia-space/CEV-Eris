/obj/item/clothing/under/turtleneck
	name = "green turtleneck"
	desc = "Military style turtleneck, for operating in cold environments. Typically worn underneath armour"
	icon_state = "greenturtle"
	item_state = "bl_suit"

	has_sensor = 0
	armor = list(melee = 15, bullet = 15, laser = 15,energy = 15, bomb = 15, bio = 10, rad = 20)
	siemens_coefficient = 0.9
	price_tag = 50


/obj/item/clothing/under/turtleneck/New()
	if (prob(50))
		name = "black turtleneck"
		icon_state = "blackturtle"
