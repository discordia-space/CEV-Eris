/obj/machinery/autolathe/artist_bench
	name = "artist's bench"
	desc = "" //Temporary description.
	icon = 'icons/obj/machines/autolathe.dmi'
	icon_state = "protolathe"
	circuit = /obj/item/weapon/circuitboard/artist_bench

	var/obj/item/weapon/oddity/strange_item = null //Not sure if nessecary to name this way, autolathe.dm did it with there var definitions for beakers and disks. Temporary name. //var/obj/item/weapon/oddity/strange_item
	var/list/strange_item_stats = list()

	categories = list("Creat Artwork") //Temporary name.

	suitable_materials = list(MATERIAL_WOOD, MATERIAL_STEEL, MATERIAL_GLASS, MATERIAL_PLASTEEL, MATERIAL_PLASTIC)

/obj/machinery/autolathe/artist_bench/ui_data()
	var/list/data = list()

	if(strange_item)
		var/list/L = list()
		var/datum/component/inspiration/I = strange_item.GetComponent(/datum/component/inspiration)
		var/list/LE = I.calculate_statistics()
		for(var/stat in LE)
			var/list/LF = list("name" = stat, "level" = LE[stat])
			L.Add(list(LF))

		data["strange_item_name"] = strange_item.name
		data["strange_item_stats"] = L

	return data


/obj/machinery/autolathe/artist_bench/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "artist_bench.tmpl", "Artist's Bench UI", 600, 700)

		ui.set_initial_data(data)

		ui.open()

/obj/machinery/autolathe/artist_bench/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/oddity))
		insert_oddity(user, I)

/obj/machinery/autolathe/artist_bench/Topic(href, href_list)//var/mob/living/carbon/human/H, var/mob/living/user
	if(..())
		return

	usr.set_machine(src)

	if(href_list["strange_item_name"])
		if(strange_item)
			remove_oddity(usr)
		else
			insert_oddity(usr)
		return 1

	if(href_list["create_art"])
		var/mob/living/carbon/human/H = usr
		var/ins_used = 0
		if(usr.stats.getPerk(/datum/perk/artist/)) //Temporary job title
			ins_used = input("How much of your insight will you dedicate to this work? 40-[H.sanity.insight]","Insight Used") as null|num
		else
			ins_used = H.sanity.insight
		create_art(ins_used)
		return 1

/obj/machinery/autolathe/artist_bench/proc/insert_oddity(mob/living/user, obj/item/weapon/oddity/inserted_oddity) //Not sure if nessecary to name oddity this way. obj/item/weapon/oddity/inserted_oddity
	if(!inserted_oddity && istype(user))
		inserted_oddity = user.get_active_hand()

	if(!istype(inserted_oddity))
		return

	if(!Adjacent(user) && !Adjacent(inserted_oddity))
		return

	if(strange_item)
		to_chat(user, SPAN_NOTICE("There's already \a [strange_item] inside [src].")) //Temporary description
		return

	if(istype(user) && (inserted_oddity in user))
		user.unEquip(inserted_oddity, src)

	inserted_oddity.forceMove(src)
	strange_item = inserted_oddity
	to_chat(user, SPAN_NOTICE("You set \the [inserted_oddity] onto the model stand in [src].")) //Temporary description.
	SSnano.update_uis(src)

/obj/machinery/autolathe/artist_bench/proc/remove_oddity(mob/living/user)
	if(!strange_item)
		return

	strange_item.forceMove(drop_location())
	to_chat(usr, SPAN_NOTICE("You remove \the [strange_item] from the model stand in [src].")) //Temporary description.

	if(istype(user) && Adjacent(user))
		user.put_in_active_hand(strange_item)

	strange_item = null

/obj/machinery/autolathe/artist_bench/proc/create_art(ins_used, mob/living/user)
	var/mob/living/carbon/human/H = usr

	if(!ins_used)
		return

	if(ins_used < 40)
		to_chat(usr, SPAN_WARNING("At least 40 insight is needed to use this bench.")) //Temporary description
		return

	if(H.stats.getPerk(/datum/perk/artist/) && H.sanity.insight_block == 1)
		H.sanity.finish_rest()

	if(!H.stats.getPerk(/datum/perk/artist/))
		var/list/stat_change = list()

		var/stat_pool = 5 //Arbitrary value for how much to remove the stats by, from sanity_mob
		while(stat_pool--)
			LAZYAMINUS(stat_change, pick(ALL_STATS), 1)

