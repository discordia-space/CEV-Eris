/obj/structure/closet/secure_closet/bar
	name = "booze closet"
	req_access = list(access_bar)
	icon_state = "cabinet"
	icon_lock = "cabinet"


/obj/structure/closet/secure_closet/bar/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
