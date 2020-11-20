#define INSIGHT_MIN 40

/obj/machinery/autolathe/artist_bench
	name = "artist's bench"
	desc = "" //Temporary description.
	icon = 'icons/obj/machines/autolathe.dmi'
	icon_state = "protolathe"
	circuit = /obj/item/weapon/electronics/circuitboard/artist_bench

	var/obj/item/weapon/oddity/strange_item = null //Not sure if nessecary to name this way, autolathe.dm did it with there var definitions for beakers and disks. Temporary name. //var/obj/item/weapon/oddity/strange_item
	var/list/strange_item_stats = list()

	categories = list("Create Artwork") //Temporary name.

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

		ui.add_template("_materials", "autolathe_materials.tmpl")

		ui.set_initial_data(data)

		ui.open()

/obj/machinery/autolathe/artist_bench/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/oddity))
		insert_oddity(user, I)
	.=..()

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
		if(usr.stats.getPerk(PERK_ARTIST))
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

/obj/machinery/autolathe/artist_bench/proc/choose_base_art(ins_used)
	var/weight_artwork_statue = 8
	var/weight_artwork_weapon = 8
	var/weight_artwork_oddity = 8
	var/weight_artwork_revolver = 8
	var/weight_artwork_tool = 8
	var/weight_artwork_toolmod = 8
	var/weight_artwork_gunmod = 8

	if(ins_used >= 80)//Arbitrary values
		weight_artwork_weapon += 2
		weight_artwork_revolver += 2
	else if(ins_used >= 60)
		weight_artwork_oddity += 2
		weight_artwork_gunmod += 2
	else
		weight_artwork_statue += 2
		weight_artwork_tool += 2
		weight_artwork_toolmod += 2

	return pickweight(list(
		"artwork_revolver" = weight_artwork_revolver,
		"artwork_statue" = weight_artwork_statue,
		"artwork_oddity" = weight_artwork_oddity
	))

/obj/machinery/autolathe/artist_bench/proc/choose_full_art(ins_used, mob/living/user)
	var/mob/living/carbon/human/H = usr
	var/full_artwork = choose_base_art(ins_used)
	var/list/LStats = list()

	if(strange_item)
		if(H.stats.getPerk(PERK_ARTIST))
			var/datum/component/inspiration/I = strange_item.GetComponent(/datum/component/inspiration)
			var/list/LE = I.calculate_statistics()
			for(var/stat in LE)
				var/list/LF = list("name" = stat, "level" = LE[stat])
				LStats.Add(list(LF))

	var/weight_mechanical = 0 + LStats[STAT_MEC]
	var/weight_cognition = 0 + LStats[STAT_COG]
	var/weight_biology = 0 + LStats[STAT_BIO]
	var/weight_robustness = 0 + LStats[STAT_ROB]
	var/weight_toughness = 0 + LStats[STAT_TGH]
	var/weight_vigilance = 0 + LStats[STAT_VIG]

	//var/list/LWeights = list(weight_mechanical, weight_cognition, weight_biology, weight_robustness, weight_toughness, weight_vigilance)

	if(full_artwork == "artwork_revolver")
		var/obj/item/weapon/gun/projectile/revolver/artwork_revolver/R = new /obj/item/weapon/gun/projectile/revolver/artwork_revolver

		var/gun_pattern = pickweight(list(
			"pistol" = 8 + weight_robustness,
			"magnum" = 8 + weight_vigilance,
			"shotgun" = 8 + weight_robustness,
			"rifle" = 8 + weight_vigilance,
			"sniper" = 8 + weight_vigilance,
			"gyro" = 8 + weight_robustness + weight_mechanical,
			"cap" = 8,
			"rocket" = 8 + weight_vigilance + weight_toughness,
			"grenade" = 8 + weight_vigilance + weight_toughness
		))

		switch(gun_pattern)

			if("pistol") //From havelock.dm, Arbitrary Values
				R.caliber = pick(CAL_PISTOL, CAL_35A)
				R.damage_multiplier = 1.4
				R.penetration_multiplier = 1.4
				R.recoil_buildup = 18

			if("magnum") //From consul.dm, Arbitrary values
				R.caliber = CAL_MAGNUM
				R.damage_multiplier = 1.35
				R.penetration_multiplier = 1.5
				R.recoil_buildup = 35

			if("shotgun") //From bull.dm, Arbitrary values
				R.caliber = CAL_SHOTGUN
				R.damage_multiplier = 0.8
				R.penetration_multiplier = 0.75
				R.recoil_buildup = 1.2 //from sawnoff.dm
				R.one_hand_penalty = 10
				R.bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
				R.fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'

			if("rifle")
				R.caliber = pick(CAL_CLRIFLE, CAL_SRIFLE, CAL_LRIFLE)
				R.fire_sound = 'sound/weapons/guns/fire/smg_fire.ogg'
//
//No gun currently uses CAL_357 far as I know
//			if("revolver")
//				caliber = pick(CAL_357)

			if("sniper")//From sniper.dm, Arbitrary values
				R.caliber = CAL_ANTIM
				R.bulletinsert_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
				R.fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
				R.one_hand_penalty = 15 //From sniper.dm, Temporary values
				R.recoil_buildup = 90

			if("gyro")//From gyropistol.dm, Arbitrary values
				R.caliber = CAL_70
				R.recoil_buildup = 0.1

			if("cap")
				R.caliber = CAL_CAP

			if("rocket")//From RPG.dm, Arbitrary values
				R.caliber = CAL_ROCKET
				R.fire_sound = 'sound/effects/bang.ogg'
				R.bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
				R.one_hand_penalty = 15 //From ak47.dm, temporary values
				R.recoil_buildup = 15

			if("grenade")
				R.caliber = CAL_GRENADE
				R.fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
				R.bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
				R.one_hand_penalty = 15 //from sniper.dm, Temporary values
				R.recoil_buildup = 20 //from projectile_grenade_launcher.dm

		if(R.max_shells == 3 && (gun_pattern == "shotgun"||"rocket"))//From Timesplitters triple-firing RPG far as I know
			R.init_firemodes = list(
				list(mode_name="fire one barrel at a time", burst=1, icon="semi"),
				list(mode_name="fire three barrels at once", burst=3, icon="auto"),
				)

		return R

	else if(full_artwork == "artwork_statue")
		var/obj/structure/artwork_statue/S = new /obj/structure/artwork_statue
		return S

	else if(full_artwork == "artwork_oddity")
		var/obj/item/weapon/oddity/artwork/O = new /obj/item/weapon/oddity/artwork(src)

		var/oddity_pattern = pickweight(list(
			"combat" = 8 + weight_robustness + weight_toughness + weight_vigilance,
			"craft" = 8 + weight_mechanical + weight_cognition + weight_biology,
			"mix" = 4 + weight_mechanical + weight_cognition + weight_biology + weight_robustness + weight_toughness + weight_vigilance //Arbitrary value chance
			))

		var/list/oddity_stats = list(STAT_MEC = 0, STAT_COG = 0, STAT_BIO = 0, STAT_ROB = 0, STAT_TGH = 0, STAT_VIG = 0)//May not be nessecary
		switch(oddity_pattern)//Arbitrary values

			if("combat")
				oddity_stats = list(
					STAT_TGH = 9 + rand(-3,3),
					STAT_ROB = 9 + rand(-3,3),
					STAT_VIG = 9 + rand(-3,3),
				)

			if("craft")
				oddity_stats = list(
					STAT_COG = 9 + rand(-3,3),
					STAT_BIO = 9 + rand(-3,3),
					STAT_MEC = 9 + rand(-3,3),
				)

			if("mix")
				oddity_stats = list(
					STAT_TGH = 4 + rand(-1, 5),
					STAT_ROB = 4 + rand(-1, 5),
					STAT_VIG = 4 + rand(-1, 5),
					STAT_COG = 4 + rand(-1, 5),
					STAT_BIO = 4 + rand(-1, 5),
					STAT_MEC = 4 + rand(-1, 5),
				)

		O.oddity_stats = oddity_stats
		O.AddComponent(/datum/component/inspiration, O.oddity_stats)

		return O

	else
		return "ERR_ARTWORK"

/obj/machinery/autolathe/artist_bench/proc/create_art(ins_used)
	var/mob/living/carbon/human/H = usr
	var/artwork = choose_full_art()

	if(!ins_used)
		return

	if(ins_used < INSIGHT_MIN)
		to_chat(usr, SPAN_WARNING("At least 40 insight is needed to use this bench.")) //Temporary description
		return
//
//	if(!Adjacent(user))
//		return

	if(!H.stats.getPerk(PERK_ARTIST))
		var/list/stat_change = list()

		var/stat_pool = 5 //Arbitrary value for how much to remove the stats by, from sanity_mob
		while(stat_pool--)
			LAZYAMINUS(stat_change, pick(ALL_STATS), 1)

	consume_materials(artwork)
	H.put_in_hands(artwork)
	H.sanity.insight -= ins_used
	if(H.stats.getPerk(PERK_ARTIST) && H.sanity.resting)
		H.sanity.finish_rest()
