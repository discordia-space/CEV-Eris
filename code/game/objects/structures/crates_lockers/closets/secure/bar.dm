/obj/structure/closet/secure_closet/bar
	name = "booze closet"
	req_access = list(access_bar)
	icon_state = "cabinet"
	icon_lock = "cabinet"


/obj/structure/closet/secure_closet/bar/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/drinks/bottle/small/beer(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
