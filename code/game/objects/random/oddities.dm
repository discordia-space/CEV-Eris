/obj/random/common_oddities
	name = "random common odities"
	icon_state = "techloot-grey"

/obj/random/common_oddities/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/oddity/common/blueprint = 3,
				/obj/item/weapon/oddity/common/coin = 3,
				/obj/item/weapon/oddity/common/photo_landscape = 2,
				/obj/item/weapon/oddity/common/photo_coridor = 2,
				/obj/item/weapon/oddity/common/photo_eyes = 1,
				/obj/item/weapon/oddity/common/old_newspaper = 3,
				/obj/item/weapon/oddity/common/paper_crumpled = 2,
				/obj/item/weapon/oddity/common/paper_omega = 1,
				/obj/item/weapon/oddity/common/book_eyes = 1,
				/obj/item/weapon/oddity/common/book_omega = 2,
				/obj/item/weapon/oddity/common/book_bible = 3,
				/obj/item/weapon/oddity/common/old_money = 3,
				/obj/item/weapon/oddity/common/healthscanner = 2,
				/obj/item/weapon/oddity/common/old_pda = 3,
				/obj/item/weapon/oddity/common/teddy = 2,
				/obj/item/weapon/oddity/common/old_knife = 2,
				/obj/item/weapon/oddity/common/old_id = 1,
				/obj/item/weapon/oddity/common/old_radio = 1,
				/obj/item/weapon/oddity/common/paper_bundle = 2,
				/obj/item/weapon/oddity/common/towel = 3))

/obj/random/common_oddities/low_chance
	name = "low chance random common odities"
	icon_state = "techloot-grey-low"
	spawn_nothing_percentage = 60
