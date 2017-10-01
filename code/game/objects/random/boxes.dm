/obj/random/boxes
	name = "random box"
	icon_state = "box-blue"
	item_to_spawn()
		return pick(prob(1);/obj/item/weapon/storage/box/botanydisk,\
					prob(3);/obj/item/weapon/storage/box/beakers,\
					prob(2);/obj/item/weapon/storage/box/bloodpacks,\
					prob(2);/obj/item/weapon/storage/box/autoinjectors,\
					prob(2);/obj/item/weapon/storage/box/matches,\
					prob(2);/obj/item/weapon/storage/box/donkpockets,\
					prob(3);/obj/item/weapon/storage/box/disks,\
					prob(1);/obj/item/weapon/storage/box/cups,\
					prob(2);/obj/item/weapon/storage/box/drinkingglasses,\
					prob(1);/obj/item/weapon/storage/box/fingerprints,\
					prob(2);/obj/item/weapon/storage/box/handcuffs,\
					prob(1);/obj/item/weapon/storage/box/holobadge,\
					prob(1);/obj/item/weapon/storage/box/ids,\
					prob(1);/obj/item/weapon/storage/box/injectors,\
					prob(1);/obj/item/weapon/storage/box/lights,\
					prob(1);/obj/item/weapon/storage/box/monkeycubes,\
					prob(1);/obj/item/weapon/storage/box/mousetraps,\
					prob(1);/obj/item/weapon/storage/box/pillbottles,\
					prob(1);/obj/item/weapon/storage/box/rxglasses,\
					prob(1);/obj/item/weapon/storage/box/samplebags,\
					prob(1);/obj/item/weapon/storage/box/smokes,\
					prob(1);/obj/item/weapon/storage/box/sniperammo,\
					prob(1);/obj/item/weapon/storage/box/solution_trays,\
					prob(1);/obj/item/weapon/storage/box/survival,\
					prob(1);/obj/item/weapon/storage/box/swabs,\
					prob(1);/obj/item/weapon/storage/briefcase/crimekit)

/obj/random/boxes/low_chance
	name = "low chance box"
	icon_state = "box-blue-low"
	spawn_nothing_percentage = 60
