//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

/obj/item/trash
	name = "trash"
	desc = "This is rubbish."
	icon = 'icons/obj/trash.dmi'
	volumeClass = ITEM_SIZE_SMALL
	rarity_value = 20
	spawn_tags = SPAWN_TAG_JUNK
	matter = list(MATERIAL_PLASTIC = 1)

/obj/item/trash/attack(mob/M, mob/living/user)
	return


/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state= "4no_raisins"

/obj/item/trash/shokoloud
	name = "Shokoloud chocolate bar"
	icon_state = "shokoloud"

/obj/item/trash/cheesie
	name = "\improper Cheesie Honkers"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "chips"
	icon_state = "chips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/wok
	name = "Wok"
	icon_state = "wok"

/obj/item/trash/waffles
	name = "waffles"
	icon_state = "waffles"

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"
	matter = list(MATERIAL_GLASS = 1)

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"
	matter = list(MATERIAL_GLASS = 1)

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

/obj/item/trash/liquidfood
	name = "\improper \"LiquidFood\" ration"
	icon_state = "liquidfood"

/obj/item/trash/tastybread
	name = "bread tube"
	icon_state = "tastybread"

/obj/item/trash/mre
	name = "mre"
	icon_state = "mre_trash"

/obj/item/trash/mre_paste
	name = "nutrient paste"
	icon_state = "paste_trash"

/obj/item/trash/mre_candy
	name = "candy"
	icon_state = "mre_candy_trash"

/obj/item/trash/mre_can
	name = "ration can"
	icon_state = "ration_can_trash"

/obj/item/trash/gym_ticket
	name = "expired electronic ticket"
	icon_state = "gym_ticket_trash"
