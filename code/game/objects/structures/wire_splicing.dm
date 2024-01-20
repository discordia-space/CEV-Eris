/obj/structure/wire_splicing
	name = "wire splicing"
	desc = "Looks like someone was very drunk when doing this, or just didn't care. This can be removed by wirecutters."
	icon = 'icons/obj/traps.dmi'
	icon_state = "wire_splicing1"
	density = FALSE
	anchored = TRUE
	flags = CONDUCT
	layer = TURF_LAYER + 0.45
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_TRAP_ARMED_WIRE
	var/messiness = 0 // How bad the splicing was, determines the chance of shock

/obj/structure/wire_splicing/Initialize(roundstart)
	.=..()


	//Wire splice can only exist on a cable. Lets try to place it in a good location
	if (!(locate(/obj/structure/cable) in loc))
		//No cable in our location, lets find one nearby

		//Make a list of turfs with cables in them
		var/list/candidates = list()

		//We will give each turf a score to determine its suitability
		var/best_score = -INFINITY
		for (var/obj/structure/cable/C in range(3, loc))
			var/turf/simulated/floor/T = get_turf(C)

			//Wire inside a wall? can't splice there
			if (!istype(T))
				continue

			//We already checked this one
			if (T in candidates)
				continue

			var/turf_score = 0

			//Nobody walks on underplating so we don't want to place traps there
			if (istype(T.flooring, /decl/flooring/reinforced/plating/under))
				turf_score -= 1

			if (turf_is_external(T))
				continue //No traps in space

			//Catwalks are made for walking on, we definitely want traps there
			if (locate(/obj/structure/catwalk) in T)
				turf_score += 2

			//If its below the threshold ignore it
			if (turf_score < best_score)
				continue

			//If it sets a new threshold, discard everything before
			else if (turf_score > best_score)
				best_score = turf_score
				candidates.Cut()

			candidates.Add(T)

		//No nearby cables? Cancel
		if (!candidates.len)
			return INITIALIZE_HINT_QDEL

		forceMove(pick(candidates))
	messiness = rand (1,10)
	icon_state = "wire_splicing[messiness]"

	//At messiness of 2 or below, triggering when walking on a catwalk is impossible
	//Above that it becomes possible, so we will change the layer to make it poke through catwalks
	if (messiness > 2)
		layer = LOW_OBJ_LAYER  // I wont do such stuff on splicing "reinforcement". Take it as nasty feature

/obj/structure/wire_splicing/examine(mob/user)
	..(user, afterDesc = "It has [messiness] wire[messiness > 1?"s":""] dangling around")

/obj/structure/wire_splicing/Crossed(AM as mob|obj)
	if(isliving(AM))
		var/mob/living/L = AM
		var/turf/T = get_turf(src)
		var/chance_to_shock = messiness * 10
		chance_to_shock -= L.skill_to_evade_traps()
		if(locate(/obj/structure/catwalk) in T)
			chance_to_shock -= 20
		if(prob(chance_to_shock))
			shock(L, FALSE)

/obj/structure/wire_splicing/proc/shock(mob/user as mob, using_hands = TRUE)
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = locate(/obj/structure/cable) in T
	if(C)
		if(electrocute_mob(user, C, src, hands = using_hands))
			if(C.powernet)
				C.powernet.trigger_warning()
			if(user.stunned)
				to_chat(user, SPAN_WARNING("You got electrocuted by wire splicing!"))
				return TRUE

/obj/structure/wire_splicing/attackby(obj/item/I, mob/user)
	if(QUALITY_WIRE_CUTTING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WIRE_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			if(!shock(user, 100))
				to_chat(user, SPAN_NOTICE("You remove the splicing."))
				qdel(src)

	if(QUALITY_CUTTING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			if(!shock(user, 100))
				to_chat(user, SPAN_NOTICE("You remove the splicing."))
				qdel(src)

	if(istype(I, /obj/item/stack/cable_coil) && user.a_intent == I_HURT)
		if(used_now)
			to_chat(user, "The [src.name] is already being manipulated!") //so people with low stats can't spam their way past the failure chance
			return
		if(messiness >= 10)
			messiness = 10
			to_chat(user, SPAN_WARNING("Enough."))
			return
		used_now = TRUE
		// keep goin!
		var/obj/item/stack/cable_coil/coil = I
		if(coil.get_amount() >= 1)
			to_chat(user, SPAN_NOTICE("You started to wire to this pile of wires..."))
			if(shock(user)) //check if he got his insulation gloves
				used_now = FALSE
				return 		//he didn't
			if(do_after(user, 20, src))
				if(shock(user)) //check if he got his insulation gloves. Again.
					used_now = FALSE
					return
				var/fail_chance = FAILCHANCE_HARD - user.stats.getStat(STAT_MEC) // 72 for assistant
				if(prob(fail_chance))
					if(!shock(user, FALSE)) //why not
						to_chat(user, SPAN_WARNING("You failed to finish your task with [src.name]! There was a [fail_chance]% chance to screw this up."))
					used_now = FALSE
					return
				if(messiness >= 10)
					messiness = 10
				//all clear, update things
				coil.use(1)
				messiness += 1
				icon_state = "wire_splicing[messiness]"
				to_chat(user, SPAN_NOTICE("You added one more wire."))
				used_now = FALSE

