/obj/random/contraband
	name = "random illegal item"
	icon_state = "box-red"

/obj/random/contraband/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/storage/pill_bottle/tramadol,\
				prob(4);/obj/item/weapon/haircomb,\
				prob(2);/obj/item/weapon/storage/pill_bottle/happy,\
				prob(2);/obj/item/weapon/storage/pill_bottle/zoom,\
				prob(5);/obj/item/weapon/contraband/poster,\
				prob(2);/obj/item/weapon/material/butterfly,\
				prob(3);/obj/item/weapon/material/butterflyblade,\
				prob(3);/obj/item/weapon/material/butterflyhandle,\
				prob(3);/obj/item/weapon/material/wirerod,\
				prob(1);/obj/item/weapon/material/butterfly/switchblade,\
				prob(1);/obj/item/clothing/mask/chameleon,\
				prob(1);/obj/item/clothing/glasses/chameleon,\
				prob(1);/obj/item/clothing/gloves/chameleon,\
				prob(1);/obj/item/weapon/storage/backpack/chameleon,\
				prob(1);/obj/item/clothing/shoes/chameleon,\
				prob(1);/obj/item/clothing/head/chameleon,\
				prob(1);/obj/item/clothing/under/chameleon,\
				prob(2);/obj/item/weapon/gun/energy/chameleon,\
				prob(1);/obj/item/weapon/reagent_containers/syringe/drugs)

/obj/random/contraband/low_chance
	name = "low chance random illegal item"
	icon_state = "box-red-low"
	spawn_nothing_percentage = 60
