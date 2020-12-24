#define ERR_OK 0
#define ERR_NOTFOUND "not found"
#define ERR_NOMATERIAL "no material"
#define ERR_NOREAGENT "no reagent"
#define ERR_NOLICENSE "no license"
#define ERR_PAUSED "paused"
#define ERR_NOINSIGHT "no insight"
#define MAX_STAT_VALUE 12

/obj/machinery/autolathe/artist_bench
	name = "artist's bench"
	desc = "Insert wood, steel, glass, plasteel, plastic and a bit of your soul to create a beautiful work of art."
	icon = 'icons/obj/machines/autolathe.dmi'
	icon_state = "bench"
	circuit = /obj/item/weapon/electronics/circuitboard/artist_bench
	have_disk = FALSE
	have_reagents = FALSE
	have_recycling = FALSE
	have_design_selector = FALSE
	categories = list("Artwork")

	suitable_materials = list(MATERIAL_WOOD, MATERIAL_STEEL, MATERIAL_GLASS, MATERIAL_PLASTEEL, MATERIAL_PLASTIC)
	var/min_mat = 20
	var/min_insight = 40
	var/datum/component/inspiration/inspiration
	var/obj/item/oddity

/obj/machinery/autolathe/artist_bench/ui_data()
	var/list/data = list()

	data["have_disk"] = have_disk
	data["have_materials"] = have_materials
	data |= materials_data()

	if(inspiration)
		var/list/L = list()
		var/list/LE = inspiration.calculate_statistics()
		for(var/stat in LE)
			var/list/LF = list("name" = stat, "level" = LE[stat])
			L.Add(list(LF))

		data["oddity_name"] = oddity.name
		data["oddity_stats"] = L

	return data


/obj/machinery/autolathe/artist_bench/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "artist_bench.tmpl", "Artist's Bench UI", 600, 700)

		ui.add_template("_materials", "autolathe_materials.tmpl")

		ui.set_initial_data(data)

		ui.open()

/obj/machinery/autolathe/artist_bench/attackby(obj/item/I, mob/user)
	GET_COMPONENT_FROM(C, /datum/component/inspiration, I)
	if(C && C.perk)
		insert_oddity(user, I)
		return
	. = ..()

/obj/machinery/autolathe/artist_bench/Topic(href, href_list)//var/mob/living/carbon/human/H, var/mob/living/user
	if(..())
		return

	usr.set_machine(src)

	if(href_list["oddity_name"])
		if(oddity)
			remove_oddity(usr)
		else
			insert_oddity(usr)
		return TRUE

	if(href_list["create_art"])
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			var/ins_used = 0
			if(H.stats.getPerk(PERK_ARTIST) && H.sanity.insight > 40)
				ins_used = input("How much of your insight will you dedicate to this work? 40-[H.sanity.insight > 100 ? 100 : H.sanity.insight]","Insight Used") as null|num
			else
				ins_used = H.sanity.insight
			create_art(ins_used, H)
			return TRUE
		return FALSE

/obj/machinery/autolathe/artist_bench/proc/insert_oddity(mob/living/user, obj/item/inserted_oddity) //Not sure if nessecary to name oddity this way. obj/item/weapon/oddity/inserted_oddity
	if(oddity)
		to_chat(user, SPAN_NOTICE("There's already \a [oddity] inside [src]."))
		return

	if(!inserted_oddity && istype(user))
		inserted_oddity = user.get_active_hand()

	if(!istype(inserted_oddity))
		return

	if(!Adjacent(user) || !Adjacent(inserted_oddity))
		return

	GET_COMPONENT_FROM(C, /datum/component/inspiration, inserted_oddity)
	if(!C || !C.perk)
		return

	if(istype(user) && (inserted_oddity in user))
		user.unEquip(inserted_oddity, src)

	inserted_oddity.forceMove(src)
	oddity = inserted_oddity
	inspiration = C
	to_chat(user, SPAN_NOTICE("You set \the [inserted_oddity] into the model stand in [src]."))
	SSnano.update_uis(src)

/obj/machinery/autolathe/artist_bench/proc/remove_oddity(mob/living/user)
	if(!oddity)
		return

	oddity.forceMove(drop_location())
	to_chat(usr, SPAN_NOTICE("You remove \the [oddity] from the model stand in [src]."))

	if(istype(user) && Adjacent(user))
		user.put_in_hands(oddity)

	oddity = null
	inspiration = null
	SSnano.update_uis(src)

/obj/machinery/autolathe/artist_bench/proc/choose_base_art(ins_used, mob/living/carbon/human/user)
	var/list/LStats = list()

	if(inspiration && user.stats.getPerk(PERK_ARTIST))
		LStats = inspiration.calculate_statistics()

	var/weight_artwork_statue = 20
	var/weight_artwork_revolver = 1 + LStats[STAT_VIG] * 2
	var/weight_artwork_weapon = 1 + max(LStats[STAT_ROB], LStats[STAT_TGH]) * 2
	var/weight_artwork_oddity = 1 + max(LStats[STAT_COG], LStats[STAT_BIO]) * 2
	var/weight_artwork_tool = 2 + LStats[STAT_MEC] * 2
	var/weight_artwork_toolmod = 2 + LStats[STAT_MEC] * 2
	var/weight_artwork_gunmod = 2 + LStats[STAT_COG] * 2

	if(ins_used >= 85)//Arbitrary values
		weight_artwork_revolver += 9
		weight_artwork_weapon += 9
	if(ins_used >= 70)
		weight_artwork_revolver += 4
		weight_artwork_weapon += 4
		weight_artwork_oddity += 13
		weight_artwork_gunmod += 8
	if(ins_used >= 55)
		weight_artwork_gunmod += 4
		weight_artwork_tool += 12
		weight_artwork_toolmod += 12
	else
		weight_artwork_statue += 12

	return pickweight(list(
		"artwork_revolver" = weight_artwork_revolver,
		"artwork_oddity" = weight_artwork_oddity,
		"artwork_toolmod" = weight_artwork_toolmod,
		"artwork_statue" = weight_artwork_statue
	))

/obj/machinery/autolathe/artist_bench/proc/choose_full_art(ins_used, mob/living/carbon/human/user)
	var/full_artwork = choose_base_art(ins_used, user)
	var/list/LStats = list()

	if(inspiration && user.stats.getPerk(PERK_ARTIST))
		LStats = inspiration.calculate_statistics()

	var/weight_mechanical = 0 + LStats[STAT_MEC]
	var/weight_cognition = 0 + LStats[STAT_COG]
	var/weight_biology = 0 + LStats[STAT_BIO]
	var/weight_robustness = 0 + LStats[STAT_ROB]
	var/weight_toughness = 0 + LStats[STAT_TGH]
	var/weight_vigilance = 0 + LStats[STAT_VIG]

	//var/list/LWeights = list(weight_mechanical, weight_cognition, weight_biology, weight_robustness, weight_toughness, weight_vigilance)

	if(full_artwork == "artwork_revolver")
		var/obj/item/weapon/gun/projectile/revolver/artwork_revolver/R = new(src)

		var/gun_pattern = pickweight(list(
			"pistol" = 16 + weight_robustness,
			"magnum" = 8 + weight_vigilance,
			"shotgun" = 8 + weight_robustness,
			"rifle" = 8 + weight_vigilance,
			"sniper" = 8 + max(weight_vigilance + weight_cognition),
			"gyro" = 1 + weight_mechanical,
			"cap" = 16 + weight_biology,
			"rocket" = 8 + weight_toughness,
			"grenade" = 8 + weight_toughness
		))

		switch(gun_pattern)

			if("pistol") //From havelock.dm, Arbitrary Values
				R.caliber = pick(CAL_PISTOL)
				R.damage_multiplier = 1.2 + rand(-5,5)/10
				R.penetration_multiplier = 1.2 + rand(-5,5)/10
				R.recoil_buildup = 18 + rand(-3,3)

			if("magnum") //From consul.dm, Arbitrary values
				R.caliber = CAL_MAGNUM
				R.damage_multiplier = 1.2 + rand(-5,5)/10
				R.penetration_multiplier = 1.2 + rand(-5,5)/10
				R.recoil_buildup = 35 + rand(-5,5)

			if("shotgun") //From bull.dm, Arbitrary values
				R.caliber = CAL_SHOTGUN
				R.damage_multiplier = 0.8 + rand(-2,2)/10
				R.penetration_multiplier = 0.75 + rand(-3,3)/10
				R.recoil_buildup = 1.2 + rand(-2,2)/10//from sawnoff.dm
				R.one_hand_penalty = 12 + rand(-2,3)
				R.bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
				R.fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'

			if("rifle")
				R.caliber = pick(CAL_CLRIFLE, CAL_SRIFLE, CAL_LRIFLE)
				R.fire_sound = 'sound/weapons/guns/fire/smg_fire.ogg'

			//No gun currently uses CAL_357 far as I know
			//	if("revolver")
			//		caliber = pick(CAL_357)

			if("sniper")//From sniper.dm, Arbitrary values
				R.caliber = CAL_ANTIM
				R.bulletinsert_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
				R.fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
				R.one_hand_penalty = 15 + rand(-3,5) //From sniper.dm, Temporary values
				R.recoil_buildup = 90 + rand(-10,10)

			if("gyro")//From gyropistol.dm, Arbitrary values
				R.caliber = CAL_70
				R.recoil_buildup = 0.1 * rand(1,20)

			if("cap")
				R.caliber = CAL_CAP

			if("rocket")//From RPG.dm, Arbitrary values
				R.caliber = CAL_ROCKET
				R.fire_sound = 'sound/effects/bang.ogg'
				R.bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
				R.one_hand_penalty = 15 + rand(-3,5)//From ak47.dm, temporary values
				R.recoil_buildup = 15 + rand(-3,3)

			if("grenade")
				R.caliber = CAL_GRENADE
				R.fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
				R.bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
				R.one_hand_penalty = 15 + rand(-2,3)//from sniper.dm, Temporary values
				R.recoil_buildup = 20 + rand(-5,5) //from projectile_grenade_launcher.dm

		if(R.max_shells == 3 && (gun_pattern == "shotgun"||"rocket"))//From Timesplitters triple-firing RPG far as I know
			R.init_firemodes = list(
				list(mode_name="fire one barrel at a time", burst=1, icon="semi"),
				list(mode_name="fire three barrels at once", burst=3, icon="auto"),
				)
		return R

	else if(full_artwork == "artwork_statue")
		var/obj/structure/artwork_statue/S = new(src)
		return S

	else if(full_artwork == "artwork_oddity")
		var/obj/item/weapon/oddity/artwork/O = new(src)
		var/list/oddity_stats = list(STAT_MEC = rand(0,1), STAT_COG = rand(0,1), STAT_BIO = rand(0,1), STAT_ROB = rand(0,1), STAT_TGH = rand(0,1), STAT_VIG = rand(0,1))//May not be nessecary
		var/stats_amt = 3
		if(ins_used >= 85)//Arbitrary values
			stats_amt += 3
		if(ins_used >= 70)
			stats_amt += 3
		if(ins_used >= 55)
			stats_amt += 3//max = 3*4*2+6 = 30 points, min 3*4+6 = 18
		for(var/i in 1 to stats_amt)
			var/stat = pick(ALL_STATS)
			oddity_stats[stat] = min(MAX_STAT_VALUE, oddity_stats[stat]+rand(1,2))

		O.oddity_stats = oddity_stats
		O.AddComponent(/datum/component/inspiration, O.oddity_stats, O.perk)
		return O

	else if(full_artwork == "artwork_toolmod")
		var/obj/item/weapon/tool_upgrade/artwork_tool_mod/TM = new(src, ins_used)
		return TM
	else
		return "ERR_ARTWORK"

/obj/machinery/autolathe/artist_bench/proc/create_art(ins_used, mob/living/carbon/human/user)
	ins_used = CLAMP(ins_used, 0, user.sanity.insight)
	//ins_used = max(ins_used, min_insight)//debug
	if(ins_used < min_insight)
		to_chat(user, SPAN_WARNING("At least 40 insight is needed to use this bench."))
		return
	flick("[initial(icon_state)]_work", src)
	working = TRUE
	if(!do_after(user, 15 * user.stats.getMult(STAT_MEC, STAT_LEVEL_GODLIKE), src))
		error = "Lost artist."
		working = FALSE
		return
	working = FALSE

	var/obj/artwork = choose_full_art(ins_used, user)
	var/datum/design/art
	if(isobj(artwork))
		art = new()
		randomize_materialas(artwork)
		art.build_path = artwork.type
		art.AssembleDesignInfo(artwork)
	else
		visible_message(SPAN_WARNING("Unknown error."))
		return
	var/err = can_print(art, ins_used)
	//err = ERR_OK //for debug
	if(err != ERR_OK)
		if(err in error_messages)
			error = error_messages[err]
		else
			error = "Unknown error."
		visible_message(SPAN_WARNING("[error]"))
		qdel(artwork)
		QDEL_NULL(art)
		return
	artwork.price_tag += ins_used
	artwork.make_art_review()
	artwork.forceMove(get_turf(src))

	consume_materials(art)
	if(isitem(artwork) && Adjacent(user))
		user.put_in_hands(artwork)
	user.sanity.insight -= ins_used
	if(!user.stats.getPerk(PERK_ARTIST))
		var/list/stat_change = list()

		var/stat_pool = rand(4,10) //Arbitrary value for how much to remove the stats by, from sanity_mob
		while(stat_pool--)
			LAZYAPLUS(stat_change, pick(ALL_STATS), -1)

		for(var/stat in stat_change)
			user.stats.changeStat(stat, stat_change[stat])
		to_chat(user, SPAN_WARNING("To create this work of art you have sacrificed a part of yourself."))
	else if(user.sanity.resting)
		user.sanity.finish_rest()

/obj/machinery/autolathe/artist_bench/can_print(datum/design/design)
	if(working)
		return "isworking"

	for(var/rmat in suitable_materials)
		if(stored_material[rmat] < min_mat)
			return ERR_NOMATERIAL

	for(var/rmat in design.materials)
		if(!(rmat in stored_material))
			return ERR_NOMATERIAL

		if(stored_material[rmat] < SANITIZE_LATHE_COST(design.materials[rmat]))
			return ERR_NOMATERIAL

	if(design.chemicals.len)
		if(!container || !container.is_drawable())
			return ERR_NOREAGENT

		for(var/rgn in design.chemicals)
			if(!container.reagents.has_reagent(rgn, design.chemicals[rgn]))
				return ERR_NOREAGENT

	return ERR_OK


/obj/machinery/autolathe/artist_bench/proc/randomize_materialas(obj/O)
	var/material_num = pick(0, suitable_materials.len)
	var/list/new_materials = list()
	LAZYAPLUS(new_materials, pick(suitable_materials), rand(3,5))
	for(var/i in 1 to material_num)
		LAZYAPLUS(new_materials, pick(suitable_materials), rand(0,2))
	O.matter = new_materials


#undef ERR_OK
#undef ERR_NOTFOUND
#undef ERR_NOMATERIAL
#undef ERR_NOREAGENT
#undef ERR_NOLICENSE
#undef ERR_PAUSED
#undef ERR_NOINSIGHT
#undef MAX_STAT_VALUE
