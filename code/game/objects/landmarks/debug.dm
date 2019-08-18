/obj/landmark/debug
	delete_me = TRUE

/obj/landmark/debug/allReagents/New()
	for(var/id in chemical_reagents_list)
		var/datum/reagent/R = chemical_reagents_list[id]
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B = new /obj/item/weapon/reagent_containers/glass/beaker/large(src.loc)
		B.name = R.name
		B.reagents.add_reagent(id, B.volume, null, TRUE)