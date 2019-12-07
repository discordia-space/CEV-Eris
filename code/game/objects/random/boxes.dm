/obj/random/boxes
	name = "random box"
	icon_state = "box-blue"
	item_to_spawn()
		return pickweight(list(/obj/random/pack/rare = 1,
					/obj/item/weapon/storage/box/beakers = 3,
					/obj/item/weapon/storage/box/bloodpacks = 2,
					/obj/item/weapon/storage/box/autoinjectors = 2,
					/obj/item/weapon/storage/box/matches = 2,
					/obj/item/weapon/storage/box/donkpockets = 2,
					/obj/item/weapon/storage/box/data_disk/basic = 2,
					/obj/item/weapon/storage/box/data_disk = 1,
					/obj/item/weapon/storage/box/cups = 1,
					/obj/item/weapon/storage/box/drinkingglasses = 2,
					/obj/item/weapon/storage/box/fingerprints = 1,
					/obj/item/weapon/storage/box/handcuffs = 2,
					/obj/item/weapon/storage/box/holobadge = 1,
					/obj/item/weapon/storage/box/ids = 1,
					/obj/item/weapon/storage/box/injectors = 1,
					/obj/item/weapon/storage/box/lights = 1,
					/obj/item/weapon/storage/box/monkeycubes = 1,
					/obj/item/weapon/storage/box/mousetraps = 1,
					/obj/item/weapon/storage/box/pillbottles = 1,
					/obj/item/weapon/storage/box/rxglasses = 1,
					/obj/item/weapon/storage/box/samplebags = 1,
					/obj/item/weapon/storage/box/smokes = 1,
					/obj/item/weapon/storage/box/sniperammo = 1,
					/obj/item/weapon/storage/box/solution_trays = 1,
					/obj/item/weapon/storage/box/survival = 1,
					/obj/item/weapon/storage/box/swabs = 1,
					/obj/item/weapon/storage/briefcase/crimekit = 1))

/obj/random/boxes/low_chance
	name = "low chance box"
	icon_state = "box-blue-low"
	spawn_nothing_percentage = 60
