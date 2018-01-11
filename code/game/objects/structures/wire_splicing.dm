/obj/structure/wire_splicing
	name = "wire splicing"
	desc = "Looks like someone was very drunk when doing this, or just dont care. This can be removed by wirecutters."
	icon = 'icons/obj/traps.dmi'
	icon_state = "wire_splicing1"
	density = 0
	anchored = 1
	flags = CONDUCT
	layer = 2.5
	var/messines = 0 // How bad the splicing was, determines the chance of shock

/obj/structure/wire_splicing/New()
	messines = rand (1,10)
	icon_state = "wire_splicing[messines]"

/obj/structure/wire_splicing/Crossed(AM as mob|obj)
	if(isliving(AM))
		var/mob/living/L = AM
		var/chance_to_shock = messines * 10
		if(L.m_intent == "walk")
			chance_to_shock = chance_to_shock - 30
		if(prob(chance_to_shock))
			shock(L)

/obj/structure/wire_splicing/proc/shock(mob/user as mob)
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(user.stunned)
				user << SPAN_WARNING("You got electrocuted by wire splicing!")
				return 1
		else
			return 0
	return 0
