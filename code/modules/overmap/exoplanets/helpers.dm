#define SKILL_SCIENCE 1
#define SKILL_EXPERT  1
#define SKILL_ADEPT   1
#define SKILL_BASIC   1
var/list/exoplanet_map_data = list()


//TODO - sort this into their own files

/datum/map_template/ruin/exoplanet



/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = flags
	return ret

/obj/map_data/exoplanet
	name = "Exoplanet69ap Data"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	is_sealed = TRUE
	height = 1


/obj/map_data/exoplanet/New()
	var/obj/map_data/exoplanet/E = src
	exoplanet_map_data += E
	name = "Exoplanet69ap Data 69exoplanet_map_data.len69"
	..()


GLOBAL_LIST_EMPTY(banned_ruin_ids)

/proc/seedRuins(list/z_levels =69ull, budget = 0, whitelist = /area/space, list/potentialRuins,69ar/maxx = world.maxx,69ar/maxy = world.maxy)
	if(!z_levels || !z_levels.len)
		testing("No Z levels provided -69ot generating ruins")
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			testing("Z level 69zl69 does69ot exist -69ot generating ruins")
			return

	var/list/ruins = potentialRuins.Copy()
	for(var/R in potentialRuins)
		var/datum/map_template/ruin/ruin = R
		if(ruin.id in GLOB.banned_ruin_ids)
			ruins -= ruin //remove all prohibited ids from the candidate list; used to forbit global duplicates.
	var/list/spawned_ruins = list()
//Each iteration69eeds to either place a ruin or strictly decrease either the budget or ruins.len (or break).
	while(budget > 0)
		// Pick a ruin
		var/datum/map_template/ruin/ruin =69ull
		if(ruins && ruins.len)
			ruin = pick(ruins)
			if(ruin.cost > budget)
				ruins -= ruin
				continue //Too expensive, get rid of it and try again
		else
			log_world("Ruin loader had69o ruins to pick from with 69budget69 left to spend.")
			break
		// Try to place it
		var/sanity = 20
		// And if we can't fit it anywhere, give up, try again

		while(sanity > 0)
			sanity--

			var/width_border = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.width / 2)
			var/height_border = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.height / 2)
			var/z_level = pick(z_levels)
			if(width_border >69axx - width_border || height_border >69axx - height_border) // Too big and will69ever fit.
				ruins -= ruin //So let's69ot even try anymore with this one.
				break

			var/turf/T = locate(rand(width_border,69axx - width_border), rand(height_border,69axy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in ruin.get_affected_turfs(T,1))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist))) //check.turf_flags & TURF_FLAG_NORUINS
					if(sanity == 0)
						ruins -= ruin //It didn't fit, and we are out of sanity. Let's69ake sure69ot to keep trying the same one.
					valid = FALSE
					break //Let's try again

			if(!valid)
				continue
			log_world("Ruin \"69ruin.name69\" placed at (69T.x69, 69T.y69, 69T.z69)")

			load_ruin(T, ruin)
			spawned_ruins += ruin
			if(ruin.cost >= 0)
				budget -= ruin.cost
			if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				for(var/other_ruin_datum in ruins)
					var/datum/map_template/ruin/other_ruin = other_ruin_datum
					if(ruin.id == other_ruin.id)
						ruins -= ruin //Remove all ruins with the same id if we don't allow duplicates
				GLOB.banned_ruin_ids += ruin.id //and ban them globally too
			break
	return spawned_ruins

/proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/i in template.get_affected_turfs(central_turf, 1))
		var/turf/T = i
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
	template.load(central_turf,centered = TRUE)
	var/datum/map_template/ruin = template
	if(istype(ruin))
		new /obj/effect/landmark/ruin/automatic/clearing(central_turf, ruin, round(sqrt((ruin.width) ** 2 + (ruin.height) ** 2) / 2))
	return TRUE


/obj/effect/landmark
	name = "landmark"
	icon = 'icons/misc/landmarks.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101
	var/delete_me = 0

/obj/effect/landmark/New()
	..()
	tag = "landmark*69name69"


/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc,69y_ruin_template)
	name = "ruin_69sequential_id(/obj/effect/landmark/ruin)69"
	..(loc)
	ruin_template =69y_ruin_template

/obj/effect/landmark/ruin/Destroy()
	ruin_template =69ull
	. = ..()

//Subtype that calls explosion on init to clear space for shuttles
/obj/effect/landmark/ruin/automatic/clearing
	var/radius = 0

/obj/effect/landmark/ruin/automatic/clearing/New(loc,69y_ruin_template, ruin_radius)
	. = ..(loc,69y_ruin_template)
	radius = ruin_radius	

/obj/effect/landmark/ruin/automatic/clearing/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/ruin/automatic/clearing/LateInitialize()
	..()
	for(var/obj/effect/mineral/M in range(radius, src))
		qdel(M)
