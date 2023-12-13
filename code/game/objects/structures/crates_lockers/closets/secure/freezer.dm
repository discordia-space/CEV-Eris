/obj/structure/closet/secure_closet/freezer
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	icon_state = "freezer"
	req_access = list(access_kitchen)

/obj/structure/closet/secure_closet/freezer/kitchen/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to 6)
		spawnedAtoms.Add(new  /obj/item/reagent_containers/food/condiment/flour(NULLSPACE))
	spawnedAtoms.Add(new  /obj/item/reagent_containers/food/condiment/sugar(NULLSPACE))
	for(var/i in 1 to 3)
		spawnedAtoms.Add(new  /obj/item/reagent_containers/food/snacks/meat/monkey(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	icon_state = "freezer"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/meat/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to 3)
		spawnedAtoms.Add(new  /obj/item/reagent_containers/food/snacks/meat/monkey(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/fridge/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to 5)
		spawnedAtoms.Add(new  /obj/item/reagent_containers/food/drinks/milk(NULLSPACE))
	for(var/i in 1 to 3)
		spawnedAtoms.Add(new  /obj/item/reagent_containers/food/drinks/soymilk(NULLSPACE))
	for(var/i in 1 to 2)
		spawnedAtoms.Add(new  /obj/item/storage/fancy/egg_box(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	icon_state = "freezer"
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/freezer/money/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to 3)
		spawnedAtoms.Add(new  /obj/item/spacecash/bundle/c1000(NULLSPACE))
	for(var/i in 1 to 3)
		spawnedAtoms.Add(new  /obj/item/spacecash/bundle/c500(NULLSPACE))
	for(var/i in 1 to 6)
		spawnedAtoms.Add(new  /obj/item/spacecash/bundle/c200(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
