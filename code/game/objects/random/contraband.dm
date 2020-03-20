/obj/random/contraband
	name = "random illegal item"
	icon_state = "box-red"

/obj/random/contraband/item_to_spawn()
	return pickweight(list(
				/obj/random/pack/rare = 1,
				/obj/item/weapon/storage/pill_bottle/tramadol = 3,
				/obj/item/weapon/haircomb = 4,
				/obj/item/weapon/storage/pill_bottle/happy = 2,
				/obj/item/weapon/storage/pill_bottle/zoom = 2,
				/obj/item/weapon/contraband/poster = 5,
				/obj/item/weapon/material/butterfly = 2,
				/obj/item/weapon/material/butterflyblade = 3,
				/obj/item/weapon/material/butterflyhandle = 3,
				/obj/item/weapon/material/wirerod = 3,
				/obj/item/weapon/material/butterfly/switchblade = 1,
				/obj/item/clothing/mask/chameleon = 1,
				/obj/item/clothing/glasses/chameleon = 1,
				/obj/item/clothing/gloves/chameleon = 1,
				/obj/item/weapon/storage/backpack/chameleon = 1,
				/obj/item/clothing/shoes/chameleon = 1,
				/obj/item/clothing/head/chameleon = 1,
				/obj/item/clothing/under/chameleon = 1,
				/obj/item/weapon/gun/energy/chameleon = 2,
				/obj/item/weapon/reagent_containers/syringe/drugs = 1,
				/obj/item/weapon/reagent_containers/syringe/drugs_recreational = 1))

/obj/random/contraband/low_chance
	name = "low chance random illegal item"
	icon_state = "box-red-low"
	spawn_nothing_percentage = 60
