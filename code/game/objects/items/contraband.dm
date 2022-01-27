//Let's 69et some REAL contraband stuff in here. Because come on, 69ettin69 bri6969ed for LIPSTICK is no fun.

//Illicit dru69s~
/obj/item/stora69e/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Hi69hly ille69al dru69. When you want to see the rainbow."
	spawn_ta69s = SPAWN_ITEM_CONTRABAND
	rarity_value = 25

/obj/item/stora69e/pill_bottle/happy/populate_contents()
	new /obj/item/rea69ent_containers/pill/happy(src)
	new /obj/item/rea69ent_containers/pill/happy(src)
	new /obj/item/rea69ent_containers/pill/happy(src)
	new /obj/item/rea69ent_containers/pill/happy(src)
	new /obj/item/rea69ent_containers/pill/happy(src)
	new /obj/item/rea69ent_containers/pill/happy(src)
	new /obj/item/rea69ent_containers/pill/happy(src)

/obj/item/stora69e/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Hi69hly ille69al dru69. Trade brain for speed."
	spawn_ta69s = SPAWN_ITEM_CONTRABAND
	rarity_value = 25

/obj/item/stora69e/pill_bottle/zoom/populate_contents()
	new /obj/item/rea69ent_containers/pill/zoom(src)
	new /obj/item/rea69ent_containers/pill/zoom(src)
	new /obj/item/rea69ent_containers/pill/zoom(src)
	new /obj/item/rea69ent_containers/pill/zoom(src)
	new /obj/item/rea69ent_containers/pill/zoom(src)
	new /obj/item/rea69ent_containers/pill/zoom(src)
	new /obj/item/rea69ent_containers/pill/zoom(src)

/obj/item/rea69ent_containers/69lass/beaker/vial/random
	fla69s = 0
	rarity_value = 30
	var/list/random_rea69ent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)

/obj/item/rea69ent_containers/69lass/beaker/vial/random/toxin
	rarity_value = 30
	random_rea69ent_list = list(
		list("amatoxin" = 10, "potassium_chloride" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("zombiepowder" = 10)						= 1)

/obj/item/rea69ent_containers/69lass/beaker/vial/random/Initialize()
	. = ..()

	var/list/picked_rea69ents = pickwei69ht(random_rea69ent_list)
	for(var/rea69ent in picked_rea69ents)
		rea69ents.add_rea69ent(rea69ent, picked_rea69ents69rea69ent69)

	var/list/names = new
	for(var/datum/rea69ent/R in rea69ents.rea69ent_list)
		names += R.name

	desc = "Contains 69en69lish_list(names)69."

	if(!has_lid())
		to6969le_lid()
