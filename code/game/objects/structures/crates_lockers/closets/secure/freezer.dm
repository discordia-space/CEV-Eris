/obj/structure/closet/secure_closet/freezer
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	icon_state = "freezer"
	req_access = list(access_kitchen)

/obj/structure/closet/secure_closet/freezer/kitchen/populate_contents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/condiment/flour(src)
	new /obj/item/reagent_containers/food/condiment/sugar(src)
	new /obj/item/reagent_containers/food/condiment/ketchup(src)
	new /obj/item/reagent_containers/food/condiment/hotsauce(src)
	new /obj/item/reagent_containers/food/condiment/soysauce(src)
	new /obj/item/reagent_containers/food/condiment/coldsauce(src)
	new /obj/item/reagent_containers/food/condiment/cornoil(src)
	new /obj/item/reagent_containers/food/condiment/enzyme(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/snacks/sliceable/butterstick(src)
	for(var/i in 2 to 3)
		new /obj/item/reagent_containers/food/drinks/milk(src)
	for(var/i in 2 to 3)
		new /obj/item/reagent_containers/food/drinks/soymilk(src)
	for(var/i in 2 to 3)
		new /obj/item/storage/fancy/egg_box(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/condiment/saltshaker(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/condiment/peppermill(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/snacks/mint(src)
/obj/structure/closet/secure_closet/freezer/kitchen/mining
	icon_state = "freezer"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/meat/populate_contents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/snacks/meat(src)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/snacks/meat/chicken(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/fridge/populate_contents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/food/drinks/milk(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/food/drinks/soymilk(src)
	for(var/i in 1 to 2)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	icon_state = "freezer"
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/freezer/money/populate_contents()
	for(var/i in 1 to 3)
		new /obj/item/spacecash/bundle/c1000(src)
	for(var/i in 1 to 3)
		new /obj/item/spacecash/bundle/c500(src)
	for(var/i in 1 to 6)
		new /obj/item/spacecash/bundle/c200(src)
