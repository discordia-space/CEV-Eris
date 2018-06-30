/obj/structure/wire_splicing
	name = "wire splicing"
	desc = "Looks like someone was very drunk when doing this, or just didn't care. This can be removed by wirecutters."
	icon = 'icons/obj/traps.dmi'
	icon_state = "wire_splicing1"
	density = 0
	anchored = 1
	flags = CONDUCT
	layer = TURF_LAYER + 0.45
	var/messines = 0 // How bad the splicing was, determines the chance of shock

/obj/structure/wire_splicing/New()
	..()
	messines = rand (1,10)
	icon_state = "wire_splicing[messines]"

/obj/structure/wire_splicing/Crossed(AM as mob|obj)
	if(isliving(AM))
		var/mob/living/L = AM
		var/turf/T = get_turf(src)
		var/chance_to_shock = messines * 10
		if(L.m_intent == "walk")
			chance_to_shock = chance_to_shock - 30
		if(locate(/obj/structure/catwalk) in T)
			chance_to_shock = chance_to_shock - 20
		if(prob(chance_to_shock))
			shock(L)

/obj/structure/wire_splicing/proc/shock(mob/user as mob)
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = locate(/obj/structure/cable) in T
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			if(user.stunned)
				user << SPAN_WARNING("You got electrocuted by wire splicing!")
				return TRUE

/obj/structure/wire_splicing/attackby(obj/item/I, mob/user)
	if(QUALITY_WIRE_CUTTING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WIRE_CUTTING, FAILCHANCE_EASY, required_stat = STAT_PRD))
			if(!shock(user, 100))
				user << SPAN_NOTICE("You remove the splicing.")
				qdel(src)

	if(QUALITY_CUTTING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_PRD))
			if(!shock(user, 100))
				user << SPAN_NOTICE("You remove the splicing.")
				qdel(src)
