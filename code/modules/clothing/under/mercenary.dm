/obj/item/clothing/under/turtleneck
	name = "green turtleneck"
	desc = "Military style turtleneck, for operating in cold environments. Typically worn underneath armour"
	icon_state = "greenturtle"
	item_state = "bl_suit"
	has_sensor = 0
	price_tag = 50


/obj/item/clothing/under/turtleneck/New()
	if (prob(50))
		name = "black turtleneck"
		icon_state = "blackturtle"
