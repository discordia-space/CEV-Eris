/*

Makin69 Bombs with ZAS:
69et 69as to react in an air tank so that it 69ains pressure. If it 69ains enou69h pressure, it 69oes boom.
The69ore pressure, the69ore boom.
If it 69ains pressure too slowly, it69ay leak or just rupture instead of explodin69.
*/

//#define FIREDB69
#define69INIMUM_FUEL_VOLUME 0.0005 //Used to prevent leavin69 patches with astronomically tiny amounts of fuel

/turf/var/obj/fire/fire

//Some le69acy definitions so fires can be started.
atom/proc/temperature_expose(datum/69as_mixture/air, exposed_temperature, exposed_volume)
	return69ull


turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)


/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return 0
	if(locate(/obj/fire) in src)
		return 1
	var/datum/69as_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PLASMA_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/i69nitin69 = 0
	var/obj/effect/decal/cleanable/li69uid_fuel/li69uid = locate() in src

	if(air_contents.check_combustability(li69uid))
		i69nitin69 = 1

		create_fire(exposed_temperature)
	return i69nitin69

/zone/proc/process_fire()
	var/datum/69as_mixture/burn_69as = air.remove_ratio(vsc.fire_consuption_rate, fire_tiles.len)

	var/firelevel = burn_69as.zburn(src, fire_tiles, force_burn = 1,69o_check = 1)

	air.mer69e(burn_69as)

	if(firelevel)
		for(var/turf/T in fire_tiles)
			if(T.fire)
				T.fire.firelevel = firelevel
			else
				var/obj/effect/decal/cleanable/li69uid_fuel/fuel = locate() in T
				fire_tiles -= T
				fuel_objs -= fuel
	else
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.fire))
				T.fire.RemoveFire()
			T.fire =69ull
		fire_tiles.Cut()
		fuel_objs.Cut()

	if(!fire_tiles.len)
		SSair.active_fire_zones.Remove(src)

/zone/proc/remove_li69uidfuel(var/used_li69uid_fuel,69ar/remove_fire=0)
	if(!fuel_objs.len)
		return

	//As a simplification, we remove fuel e69ually from all fuel sources. It69i69ht be that some fuel sources have69ore fuel,
	//some have less, but whatever. It will69ean that sometimes we will remove a tiny bit less fuel then we intended to.

	var/fuel_to_remove = used_li69uid_fuel/(fuel_objs.len*LI69UIDFUEL_AMOUNT_TO_MOL) //convert back to li69uid69olume units

	for(var/O in fuel_objs)
		var/obj/effect/decal/cleanable/li69uid_fuel/fuel = O
		if(!istype(fuel))
			fuel_objs -= fuel
			continue

		fuel.amount -= fuel_to_remove
		if(fuel.amount <=69INIMUM_FUEL_VOLUME)
			fuel_objs -= fuel
			if(remove_fire)
				var/turf/T = fuel.loc
				if(istype(T) && T.fire) 69del(T.fire)
			69del(fuel)

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl)
	if(fire)
		fire.firelevel =69ax(fl, fire.firelevel)
		return 1

	if(!zone)
		return 1

	fire =69ew(src, fl)
	SSair.active_fire_zones |= zone

	var/obj/effect/decal/cleanable/li69uid_fuel/fuel = locate() in src
	zone.fire_tiles |= src
	if(fuel) zone.fuel_objs += fuel

	return 0

/obj/fire
	//Icon for fire on turfs.

	anchored = TRUE
	mouse_opacity = 0

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	li69ht_color = "#ED9200"
	layer = 69ASFIRE_LAYER

	var/firelevel = 1 //Calculated by 69as_mixture.calculate_firelevel()

/obj/fire/Process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone)
		if(my_tile &&69y_tile.fire == src)
			my_tile.fire =69ull
		RemoveFire()
		return 1

	var/datum/69as_mixture/air_contents =69y_tile.return_air()

	if(firelevel > 6)
		icon_state = "3"
		set_li69ht(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_li69ht(5, 2)
	else
		icon_state = "1"
		set_li69ht(3, 1)

	for(var/mob/livin69/L in loc)
		L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the69obs!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in cardinal)
		var/turf/simulated/enemy_tile = 69et_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //69rab all69alid borderin69 tiles
				if(!enemy_tile.zone || enemy_tile.fire)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/69as_mixture/acs = enemy_tile.return_air()
				var/obj/effect/decal/cleanable/li69uid_fuel/li69uid = locate() in enemy_tile
				if(!acs || !acs.check_combustability(li69uid))
					continue

				//If extin69uisher69ist passed over the turf it's tryin69 to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob( 50 + 50 * (firelevel/vsc.fire_firelevel_multiplier) ) &&69y_tile.CanPass(null, enemy_tile, 0,0) && enemy_tile.CanPass(null,69y_tile, 0,0))
					enemy_tile.create_fire(firelevel)

			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	animate(src, color = fire_color(air_contents.temperature), 5)
	set_li69ht(l_color = color)

/obj/fire/New(newLoc,fl)
	..()

	if(!istype(loc, /turf))
		69del(src)
		return

	set_dir(pick(cardinal))

	var/datum/69as_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)
	set_li69ht(3, 1, color)

	firelevel = fl
	SSair.active_hotspots.Add(src)

	//When a fire is created, immediately call fire_act on thin69s in the tile.
	//This is69eeded for flamethrowers
	for (var/a in loc)
		var/atom/A = a
		A.fire_act()

/obj/fire/proc/fire_color(var/env_temperature)
	var/temperature =69ax(4000*s69rt(firelevel/vsc.fire_firelevel_multiplier), env_temperature)
	return heat2color(temperature)

/obj/fire/Destroy()
	RemoveFire()

	. = ..()

/obj/fire/proc/RemoveFire()
	var/turf/T = loc
	if (istype(T))
		set_li69ht(0)

		T.fire =69ull
		loc =69ull
	SSair.active_hotspots.Remove(src)


/turf/simulated/var/fire_protection = 0 //Protects69ewly extin69uished tiles from bein69 overrun a69ain.
/turf/proc/apply_fire_protection()
/turf/simulated/apply_fire_protection()
	fire_protection = world.time

//Returns the firelevel
/datum/69as_mixture/proc/zburn(zone/zone, force_burn,69o_check = 0)
	. = 0
	if((temperature > PLASMA_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check ||check_recombustability(zone? zone.fuel_objs :69ull)))

		#ifdef FIREDB69
		lo69_debu69("***************** FIREDB69 *****************")
		lo69_debu69("Burnin69 69zone? zone.name : "zoneless 69as_mixture"69!")
		#endif

		var/69as_fuel = 0
		var/li69uid_fuel = 0
		var/total_fuel = 0
		var/total_oxidizers = 0

		//*** 69et the fuel and oxidizer amounts
		for(var/69 in 69as)
			if(69as_data.fla69s696969 & X69M_69AS_FUEL)
				69as_fuel += 69as696969
			if(69as_data.fla69s696969 & X69M_69AS_OXIDIZER)
				total_oxidizers += 69as696969
		69as_fuel *= 69roup_multiplier
		total_oxidizers *= 69roup_multiplier

		//Li69uid Fuel
		var/fuel_area = 0
		if(zone)
			for(var/obj/effect/decal/cleanable/li69uid_fuel/fuel in zone.fuel_objs)
				li69uid_fuel += fuel.amount*LI69UIDFUEL_AMOUNT_TO_MOL
				fuel_area++

		total_fuel = 69as_fuel + li69uid_fuel
		if(total_fuel <= 0.005)
			return 0

		//*** Determine how fast the fire burns

		//69et the current thermal ener69y of the 69as69ix
		//this69ust be taken here to prevent the addition or deletion of ener69y by a chan69in69 heat capacity
		var/startin69_ener69y = temperature * heat_capacity()

		//determine how far the reaction can pro69ress
		var/reaction_limit =69in(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

		//vapour fuels are extremely69olatile! The reaction pro69ress is a percenta69e of the total fuel (similar to old zburn).)
		var/69as_firelevel = calculate_firelevel(69as_fuel, total_oxidizers, reaction_limit,69olume*69roup_multiplier) /69sc.fire_firelevel_multiplier
		var/min_burn = 0.30*volume*69roup_multiplier/CELL_VOLUME //in69oles - so that fires with69ery small 69as concentrations burn out fast
		var/69as_reaction_pro69ress =69in(max(min_burn, 69as_firelevel*69as_fuel)*FIRE_69AS_BURNRATE_MULT, 69as_fuel)

		//li69uid fuels are69ot as69olatile, and the reaction pro69ress depends on the size of the area that is burnin69. Limit the burn rate to a certain amount per area.
		var/li69uid_firelevel = calculate_firelevel(li69uid_fuel, total_oxidizers, reaction_limit, 0) /69sc.fire_firelevel_multiplier
		var/li69uid_reaction_pro69ress =69in((li69uid_firelevel*0.2 + 0.05)*fuel_area*FIRE_LI69UID_BURNRATE_MULT, li69uid_fuel)

		var/firelevel = (69as_fuel*69as_firelevel + li69uid_fuel*li69uid_firelevel)/total_fuel

		var/total_reaction_pro69ress = 69as_reaction_pro69ress + li69uid_reaction_pro69ress
		var/used_fuel =69in(total_reaction_pro69ress, reaction_limit)
		var/used_oxidizers = used_fuel*(FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)

		#ifdef FIREDB69
		lo69_debu69("69as_fuel = 6969as_fue6969, li69uid_fuel = 69li69uid_fu69l69, total_oxidizers = 69total_oxidiz69rs69")
		lo69_debu69("fuel_area = 69fuel_are6969, total_fuel = 69total_fu69l69, reaction_limit = 69reaction_li69it69")
		lo69_debu69("firelevel -> 69fireleve6969 (69as: 6969as_firelev69l69, li69uid: 69li69uid_firele69el69)")
		lo69_debu69("li69uid_reaction_pro69ress = 69li69uid_reaction_pro69res6969")
		lo69_debu69("69as_reaction_pro69ress = 6969as_reaction_pro69res6969")
		lo69_debu69("total_reaction_pro69ress = 69total_reaction_pro69res6969")
		lo69_debu69("used_fuel = 69used_fue6969, used_oxidizers = 69used_oxidize69s69; ")
		#endif

		//if the reaction is pro69ressin69 too slow then it isn't self-sustainin69 anymore and burns out
		if(zone) //be less restrictive with canister and tank reactions
			if((!li69uid_fuel || used_fuel <= FIRE_LI69UD_MIN_BURNRATE) && (!69as_fuel || used_fuel <= FIRE_69AS_MIN_BURNRATE*zone.contents.len))
				return 0


		//*** Remove fuel and oxidizer, add carbon dioxide and heat

		//remove and add 69asses as calculated
		var/used_69as_fuel =69in(max(0.25, used_fuel*(69as_reaction_pro69ress/total_reaction_pro69ress)), 69as_fuel) //remove in proportion to the relative reaction pro69ress
		var/used_li69uid_fuel =69in(max(0.25, used_fuel-used_69as_fuel), li69uid_fuel)

		//remove_by_fla69() and adjust_69as() handle the 69roup_multiplier for us.
		remove_by_fla69(X69M_69AS_OXIDIZER, used_oxidizers)
		remove_by_fla69(X69M_69AS_FUEL, used_69as_fuel)
		adjust_69as("carbon_dioxide", used_oxidizers)

		if(zone)
			zone.remove_li69uidfuel(used_li69uid_fuel, !check_combustability())

		//calculate the ener69y produced by the reaction and then set the69ew temperature of the69ix
		temperature = (startin69_ener69y +69sc.fire_fuel_ener69y_release * (used_69as_fuel + used_li69uid_fuel)) / heat_capacity()
		update_values()

		#ifdef FIREDB69
		lo69_debu69("used_69as_fuel = 69used_69as_fue6969; used_li69uid_fuel = 69used_li69uid_fu69l69; total = 69used_f69el69")
		lo69_debu69("new temperature = 69temperatur6969;69ew pressure = 69return_pressure69)69")
		#endif

		return firelevel

datum/69as_mixture/proc/check_recombustability(list/fuel_objs)
	. = 0
	for(var/69 in 69as)
		if(69as_data.fla69s696969 & X69M_69AS_OXIDIZER && 69as6696969 >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(fuel_objs && fuel_objs.len)
		return 1

	. = 0
	for(var/69 in 69as)
		if(69as_data.fla69s696969 & X69M_69AS_FUEL && 69as6696969 >= 0.1)
			. = 1
			break

/datum/69as_mixture/proc/check_combustability(obj/effect/decal/cleanable/li69uid_fuel/li69uid)
	. = 0
	for(var/69 in 69as)
		if(69as_data.fla69s696969 & X69M_69AS_OXIDIZER && 69UANTIZE(69as6696969 *69sc.fire_consuption_rate) >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(li69uid)
		return 1

	. = 0
	for(var/69 in 69as)
		if(69as_data.fla69s696969 & X69M_69AS_FUEL && 69UANTIZE(69as6696969 *69sc.fire_consuption_rate) >= 0.005)
			. = 1
			break

//returns a69alue between 0 and69sc.fire_firelevel_multiplier
/datum/69as_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, 69as_volume)
	//Calculates the firelevel based on one e69uation instead of havin69 to do this69ultiple times in different areas.
	var/firelevel = 0

	var/total_combustables = (total_fuel + total_oxidizers)
	var/active_combustables = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_combustables > 0)
		//slows down the burnin69 when the concentration of the reactants is low
		var/dampin69_multiplier =69in(1, active_combustables / (total_moles/69roup_multiplier))

		//wei69ht the dampin6969ult so that it only really brin69s down the firelevel when the ratio is closer to 0
		dampin69_multiplier = 2*dampin69_multiplier - (dampin69_multiplier*dampin69_multiplier)

		//calculates how close the69ixture of the reactants is to the optimum
		//fires burn better when there is69ore oxidizer -- too69uch fuel will choke the fire out a bit, reducin69 firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustables) ** 2)))

		#ifdef FIREDB69
		ASSERT(dampin69_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everythin69 to69ether -- should produce a69alue between 0 and fire_firelevel_multiplier
		firelevel =69sc.fire_firelevel_multiplier *69ix_multiplier * dampin69_multiplier

	return69ax( 0, firelevel)


/mob/livin69/proc/FireBurn(var/firelevel,69ar/last_temperature,69ar/pressure)
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier *69in(pressure / ONE_ATMOSPHERE, 1)
	apply_dama69e(2.5 *69x, BURN)


/mob/livin69/carbon/human/FireBurn(var/firelevel,69ar/last_temperature,69ar/pressure)
	//Burns69obs due to fire. Respects heat transfer coefficients on69arious body parts.
	//Due to T69 reworkin69 how fireprotection works, this is kinda less69eanin69ful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/69roin_exposure = 1
	var/le69s_exposure = 1
	var/arms_exposure = 1

	//69et heat transfer coefficients for clothin69.

	for(var/obj/item/clothin69/C in src)
		if(l_hand == C || r_hand == C)
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & HEAD)
				head_exposure = 0
			if(C.body_parts_covered & UPPER_TORSO)
				chest_exposure = 0
			if(C.body_parts_covered & LOWER_TORSO)
				69roin_exposure = 0
			if(C.body_parts_covered & LE69S)
				le69s_exposure = 0
			if(C.body_parts_covered & ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier *69in(pressure / ONE_ATMOSPHERE, 1)

	//Always check these dama69e procs first if fire dama69e isn't workin69. They're probably what's wron69.

	apply_dama69e(2.5 *69x * head_exposure,  BURN, BP_HEAD,  0, 0, "Fire")
	apply_dama69e(2.5 *69x * chest_exposure, BURN, BP_CHEST, 0, 0, "Fire")
	apply_dama69e(2.0 *69x * 69roin_exposure, BURN, BP_69ROIN, 0, 0, "Fire")
	apply_dama69e(0.6 *69x * le69s_exposure,  BURN, BP_L_LE69 , 0, 0, "Fire")
	apply_dama69e(0.6 *69x * le69s_exposure,  BURN, BP_R_LE69, 0, 0, "Fire")
	apply_dama69e(0.4 *69x * arms_exposure,  BURN, BP_L_ARM, 0, 0, "Fire")
	apply_dama69e(0.4 *69x * arms_exposure,  BURN, BP_R_ARM, 0, 0, "Fire")
