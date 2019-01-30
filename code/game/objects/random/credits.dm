//Spawns credits, has many subtypes
/obj/random/credits
	var/min = 100
	var/max = 1000
	has_postspawn = TRUE

/obj/random/credits/item_to_spawn()
	return /obj/item/weapon/spacecash/bundle

/obj/random/credits/post_spawn(var/list/spawns)
	for (var/obj/item/weapon/spacecash/bundle/C in spawns)
		C.worth = rand(min, max) //Rand conveniently produces integers
		C.update_icon()

/obj/random/credits/c50
	min = 1
	max = 50

/obj/random/credits/c100
	min = 5
	max = 100

/obj/random/credits/c500
	min = 100
	max = 500

/obj/random/credits/c1000
	min = 500
	max = 1000

/obj/random/credits/c5000
	min = 1000
	max = 5000

/obj/random/credits/c10000
	min = 5000
	max = 10000