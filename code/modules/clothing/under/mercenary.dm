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

/obj/item/clothing/under/serbiansuit
	name = "green Battle Dress Uniform"
	desc = "A tough, wear-resistant battle dress uniform in forest colors. Typically worn underneath armour"
	icon_state = "serbiansuit"
	item_state = "bl_suit"
	has_sensor = 0
	price_tag = 200

/obj/item/clothing/under/serbiansuit/brown
	name = "brown Battle Dress Uniform"
	desc = "A tough, wear-resistant battle dress uniform in desert colors. Typically worn underneath armour"
	icon_state = "serbiansuit_brown"

/obj/item/clothing/under/serbiansuit/black
	name = "black Battle Dress Uniform"
	desc = "A tough, wear-resistant battle dress uniform in urban colors. Typically worn underneath armour"
	icon_state = "serbiansuit_black"