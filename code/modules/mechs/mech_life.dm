/mob/living/exosuit/handle_disabilities()
	return

/mob/living/exosuit/Life()

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot.loc != src) // Admin jump or teleport/grab.
			if(pilot.client)
				pilot.client.screen -= HUDneed
				LAZYREMOVE(pilots, pilot)
				UNSETEMPTY(pilots)
		update_pilots()

	if(radio)
		radio.on = (head && head.radio && head.radio.is_functional())

	body.update_air(hatch_closed && use_air)

	if((client || LAZYLEN(pilots)) && get_cell())
		var/obj/item/cell/c = get_cell()
		c.drain_power(0, 0, calc_power_draw())

	updatehealth()
	if(health <= 0 && stat != DEAD)
		death()
	. = ..() //Handles stuff like environment
	lying = FALSE // Fuck off, carp.
	handle_vision()

/mob/living/exosuit/get_cell()
	return body?.get_cell()

/mob/living/exosuit/proc/calc_power_draw()
	//Passive power stuff here. You can also recharge cells or hardpoints if those69ake sense
	var/total_draw = 0
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_e69uipment/I = hardpoints69hardpoint69
		if(!istype(I))
			continue
		total_draw += I.passive_power_use

	if(head && head.active_sensors)
		total_draw += head.power_use

	if(body)
		total_draw += body.power_use

	return total_draw

/mob/living/exosuit/handle_environment(var/datum/gas_mixture/environment)
	if(!environment) return
	//Mechs and69ehicles in general can be assumed to just tend to whatever ambient temperature
	if(abs(environment.temperature - bodytemperature) > 10 )
		bodytemperature += ((environment.temperature - bodytemperature) / 3)
	var/meltpoint =69aterial ?69aterial.melting_point : 1000
	if(environment.temperature >69eltpoint * 1.25) //A bit higher because I like to assume there's a difference between a69ech and a wall
		apply_damage(damage = (environment.temperature - (meltpoint))/5 , damagetype = BURN)
	//A possibility is to hook up interface icons here. But this works pretty well in69y experience
		if(prob(5))
			visible_message(SPAN_DANGER("\The 69src69's hull bends and buckles under the intense heat!"))


/mob/living/exosuit/death(gibbed)
	// Eject the pilots
	hatch_locked = FALSE // So they can get out
	for(var/pilot in pilots)
		eject(pilot, silent=TRUE)

	// Salvage69oves into the wreck unless we're exploding69iolently.
	var/obj/wreck =69ew wreckage_path(drop_location(), src, gibbed)
	wreck.name = "wreckage of \the 69name69"
	if(!gibbed)
		if(arms.loc != src)
			arms =69ull
		if(legs.loc != src)
			legs =69ull
		if(head.loc != src)
			head =69ull
		if(body.loc != src)
			body =69ull

	// Handle the rest of things.
	..(gibbed, (gibbed ? "explodes!" : "grinds to a halt before collapsing!"))
	if(!gibbed)
		69del(src)

/mob/living/exosuit/gib()
	death(1)

	// Get a turf to play with.
	var/turf/T = get_turf(src)
	if(!T)
		69del(src)
		return

	// Hurl our component pieces about.
	var/list/stuff_to_throw = list()
	for(var/obj/item/thing in list(arms, legs, head, body))
		if(thing) stuff_to_throw += thing
	for(var/hardpoint in hardpoints)
		if(hardpoints69hardpoint69)
			var/obj/item/thing = hardpoints69hardpoint69
			thing.screen_loc =69ull
			stuff_to_throw += thing
	for(var/obj/item/thing in stuff_to_throw)
		thing.forceMove(T)
		thing.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(3,6),40)
	explosion(T, -1, 0, 2)
	69del(src)
	return

/mob/living/exosuit/handle_vision()
	if(head)
		sight = head.get_sight()
		see_invisible = head.get_invisible()
	if(body && (body.pilot_coverage < 100 || body.transparent_cabin) || !hatch_closed)
		sight &= ~BLIND

/mob/living/exosuit/additional_sight_flags()
	return sight

/mob/living/exosuit/additional_see_invisible()
	return see_invisible
