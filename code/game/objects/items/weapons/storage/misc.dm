/obj/item/storage/box/dice
	name = "pack of dice"
	desc = "A small container with dice inside."
	spawn_tags = SPAWN_TAG_ITEM
	prespawned_content_type = /obj/item/dice/d20
	prespawned_content_amount = 1

/obj/item/storage/box/dice/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/dice(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/*
 * Donut Box
 */

/obj/item/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	max_storage_space = 12 //The amount of starting donuts multiplied by the donut item size to keep only exact space requirement met.
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	prespawned_content_amount = 6
	prespawned_content_type = /obj/item/reagent_containers/food/snacks/donut/normal

/obj/item/storage/box/donut/populate_contents()
	var/list/spawnedAtoms = list()

	for(var/i in 1 to prespawned_content_amount)
		spawnedAtoms.Add(new prespawned_content_type(NULLSPACE))

	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	update_icon()

/obj/item/storage/box/donut/update_icon()
	cut_overlays()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
		overlays += image('icons/obj/food.dmi', "[i][D.overlay_state]")
		i++

/obj/item/storage/box/donut/empty
	prespawned_content_amount = 0

/*
 * Emergency Ration Pack
 */

/obj/item/storage/ration_pack
	icon = 'icons/obj/food.dmi'
	icon_state = "erp_closed"
	name = "emergency ration pack"
	desc = "Silvery plastic package, with the letters \"ERP\" pasted onto the front. Seems air tight, and vacuumed sealed. \
	The packaging holds usage information within the fineprint: \
	\"Instructions: Remove contents from packaging, open both mre container and ration can, use them in-hand to activate thermal heater. \
	Thermal insulation will keep them warm for over four hours. Nutrient paste and morale bar contains medicinal additives for field performace, DO NOT OVERCONSUME.\""
	can_hold = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/storage/fancy/mre_cracker,
		/obj/item/material/kitchen/utensil/spoon/mre
	)
	var/open = FALSE

/obj/item/storage/ration_pack/open(mob/user)
	if (!open)
		to_chat(user, SPAN_NOTICE("You tear \the [src] open."))
		icon_state = "erp_open"
		open = TRUE
	..()

/obj/item/storage/ration_pack/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/mre(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/mre/can(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/mre_paste(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/fancy/mre_cracker(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/candy/mre(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/material/kitchen/utensil/spoon/mre(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/ration_pack/ihr
	icon = 'icons/obj/food.dmi'
	icon_state = "ihr_closed"
	name = "ironhammer ration pack"
	desc = "Silvery plastic package, with the letters \"IHR\" pasted onto the front. Seems air tight, and vacuumed sealed. \
	The packaging holds usage information within the fineprint: \
	\"Instructions: Remove contents from packaging, open ration can, use them in-hand to activate thermal heater. \
	Thermal insulation will keep them warm for over four hours. Crayons for taste. \
	Nutrient paste and morale bar medicinal additives for field performace, DO NOT OVERCONSUME.\""
	can_hold = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/storage/fancy/mre_cracker,
		/obj/item/material/kitchen/utensil/spoon/mre,
		/obj/item/storage/fancy/crayons
	)

/obj/item/storage/ration_pack/ihr/open(mob/user)
	if (!open)
		to_chat(user, SPAN_NOTICE("You tear \the [src] open."))
		icon_state = "ihr_open"
		open = TRUE
	..()

/obj/item/storage/ration_pack/ihr/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/mre/can(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/mre_paste(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/reagent_containers/food/snacks/candy/mre(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/material/kitchen/utensil/spoon/mre(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/storage/fancy/crayons(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

/obj/item/storage/box/clown
	name = "clown costume box"
	desc = "A cardboard box with a clown costume."
	spawn_blacklisted = TRUE

/obj/item/storage/box/clown/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/bikehorn(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/mask/gas/clown_hat(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/shoes/clown_shoes(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/clothing/under/rank/clown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stamp/clown(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/bananapeel(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

