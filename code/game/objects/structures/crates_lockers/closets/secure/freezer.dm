/obj/structure/closet/secure_closet/freezer
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	icon_state = "freezer"
	re69_access = list(access_kitchen)

/obj/structure/closet/secure_closet/freezer/kitchen/populate_contents()
	for(var/i in 1 to 6)
		new /obj/item/rea69ent_containers/food/condiment/flour(src)
	new /obj/item/rea69ent_containers/food/condiment/su69ar(src)
	for(var/i in 1 to 3)
		new /obj/item/rea69ent_containers/food/snacks/meat/monkey(src)

/obj/structure/closet/secure_closet/freezer/kitchen/minin69
	icon_state = "freezer"
	re69_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat frid69e"
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/meat/populate_contents()
	for(var/i in 1 to 3)
		new /obj/item/rea69ent_containers/food/snacks/meat/monkey(src)

/obj/structure/closet/secure_closet/freezer/frid69e
	name = "refri69erator"
	icon_state = "freezer"

/obj/structure/closet/secure_closet/freezer/frid69e/populate_contents()
	for(var/i in 1 to 5)
		new /obj/item/rea69ent_containers/food/drinks/milk(src)
	for(var/i in 1 to 3)
		new /obj/item/rea69ent_containers/food/drinks/soymilk(src)
	for(var/i in 1 to 2)
		new /obj/item/stora69e/fancy/e6969_box(src)

/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	icon_state = "freezer"
	re69_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/freezer/money/populate_contents()
	for(var/i in 1 to 3)
		new /obj/item/spacecash/bundle/c1000(src)
	for(var/i in 1 to 3)
		new /obj/item/spacecash/bundle/c500(src)
	for(var/i in 1 to 6)
		new /obj/item/spacecash/bundle/c200(src)
