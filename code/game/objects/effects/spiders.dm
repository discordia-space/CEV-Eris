//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "it's stringy and sticky"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = FALSE
	bad_type = /obj/effect/spider
	var/health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/explosion_act(target_power, explosion_handler/handler)
	qdel(src)
	return 0

/obj/effect/spider/attackby(obj/item/I, mob/user)
	if(I.attack_verb.len)
		visible_message(SPAN_WARNING("\The [src] have been [pick(I.attack_verb)] with \the [I][(user ? " by [user]." : ".")]"))
	else
		visible_message(SPAN_WARNING("\The [src] have been attacked with \the [I][(user ? " by [user]." : ".")]"))

	var/damage = I.force / 4

	if(QUALITY_WELDING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_INSTANT, QUALITY_WELDING, FAILCHANCE_ZERO))
			damage = 15

	health -= damage
	healthcheck()

/obj/effect/spider/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.get_structure_damage()
	healthcheck()

/obj/effect/spider/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/effect/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

/obj/effect/spider/stickyweb
	health = 5
	icon_state = "stickyweb1"
	rarity_value = 10
	spawn_tags = SPAWN_TAG_CLEANABLE
	New()
		if(prob(50))
			icon_state = "stickyweb2"
		..()

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	var/mob/M = mover
	if(istype(M))
		if(M.faction == "spiders")
			return 1
	if(isliving(mover))
		if(prob(50))
			to_chat(mover, SPAN_WARNING("You get stuck in \the [src] for a moment."))
			return 0
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return 1

/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life"
	icon_state = "eggs"
	var/amount_grown = 0
	var/spiderlings_lower = 6
	var/spiderlings_upper = 24

/obj/effect/spider/eggcluster/minor
	amount_grown = 20
	spiderlings_lower = 4
	spiderlings_upper = 8

/obj/effect/spider/eggcluster/New(location, atom/parent)
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)
	get_light_and_color(parent)
	..()

/obj/effect/spider/eggcluster/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		O.implants -= src

	. = ..()

/obj/effect/spider/eggcluster/Process()
	amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/num = rand(spiderlings_lower,spiderlings_upper)
		var/obj/item/organ/external/O
		if(istype(loc, /obj/item/organ/external))
			O = loc

		for(var/i=0, i<num, i++)
			var/spiderling = new /obj/effect/spider/spiderling(loc, src)
			if(O)
				O.implants += spiderling
		qdel(src)

/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon_state = "spiderling"
	anchored = FALSE
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	health = 3
	//spawn_values
	rarity_value = 5
	spawn_tags = SPAWN_TAG_SPIDER
	var/last_itch = 0
	var/amount_grown = -1
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0

/obj/effect/spider/spiderling/New(location, atom/parent)
	pixel_x = rand(6,-6)
	pixel_y = rand(6,-6)
	START_PROCESSING(SSobj, src)
	//50% chance to grow up
	if(prob(50))
		amount_grown = 1
	get_light_and_color(parent)
	..()

/obj/effect/spider/spiderling/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(entry_vent)
		entry_vent = null
	walk(src, 0)
	if (istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		O.implants -= src
	. = ..()

/obj/effect/spider/spiderling/Bump(atom/user)
	if(istype(user, /obj/structure/table))
		src.loc = user.loc
	else
		..()

/obj/effect/spider/spiderling/proc/die()
	visible_message("<span class='alert'>[src] dies!</span>")
	new /obj/effect/decal/cleanable/spiderling_remains(loc)
	qdel(src)

/obj/effect/spider/spiderling/healthcheck()
	if(health <= 0)
		die()

/obj/effect/spider/spiderling/Process()
	if(travelling_in_vent)
		if(istype(src.loc, /turf))
			travelling_in_vent = 0
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
			if(entry_vent.network && entry_vent.network.normal_members.len)
				var/list/vents = list()
				for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in entry_vent.network.normal_members)
					vents.Add(temp_vent)
				if(!vents.len)
					entry_vent = null
					return
				var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = pick(vents)

				spawn(rand(20,60))
					//Dirty hack
					if(!isnull(gc_destroyed))
						return

					loc = exit_vent
					var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
					spawn(travel_time)

						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return

						if(prob(50))
							src.visible_message(SPAN_NOTICE("You hear something squeezing through the ventilation ducts."),2)
						sleep(travel_time)
						//Dirty hack
						if(!isnull(gc_destroyed))
							return
						if(!exit_vent || exit_vent.welded)
							loc = entry_vent
							entry_vent = null
							return
						loc = exit_vent.loc
						entry_vent = null
						var/area/new_area = get_area(loc)
						if(new_area)
							new_area.Entered(src)
			else
				entry_vent = null
	//=================

	if(isturf(loc))
		if(prob(25))
			var/list/nearby = RANGE_TURFS(5, src) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(25))
					src.visible_message(SPAN_NOTICE("\The [src] skitters[pick(" away"," around","")]."))
		else if(prob(1))
			//vent crawl!
			for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break

		if(amount_grown >= 100)
			var/spawn_type = pick(typesof(/mob/living/carbon/superior_animal/giant_spider))
			new spawn_type(src.loc, src)
			qdel(src)
	else if(isorgan(loc))
		if(!amount_grown) amount_grown = 1
		var/obj/item/organ/external/O = loc
		if(!O.owner || O.owner.stat == DEAD || amount_grown > 80)
			O.implants -= src
			src.loc = O.owner ? O.owner.loc : O.loc
			src.visible_message("<span class='warning'>\A [src] makes its way out of [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!</span>")
			if(O.owner)
				O.owner.apply_damage(1, BRUTE, O.organ_tag, used_weapon = src)
		else if(prob(1))
			O.owner.apply_damage(1, TOX, O.organ_tag)
			if(world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				to_chat(O.owner, SPAN_NOTICE("Your [O.name] itches..."))
	else if(prob(1))
		src.visible_message(SPAN_NOTICE("\The [src] skitters."))

	if(amount_grown)
		amount_grown += rand(0,2)

/obj/effect/decal/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"

/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web"
	icon_state = "cocoon1"
	health = 5

	var/is_large_cocoon

/obj/effect/spider/cocoon/Initialize()
	. = ..()
	icon_state = pick("cocoon1","cocoon2","cocoon3")

/obj/effect/spider/cocoon/proc/becomeLarge()
	health = 20
	is_large_cocoon = 1
	icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")

/obj/effect/spider/cocoon/Destroy()
	src.visible_message(SPAN_WARNING("\The [src] splits open."))
	for(var/atom/movable/A in contents)
		A.forceMove(get_turf(src))
	return ..()
