/datum/69as_mixture
	//Associative list of 69as69oles.
	//69ases with 069oles are69ot tracked and are pruned by update_values()
	var/list/69as = list()
	//Temperature in Kelvin of this 69as69ix.
	var/temperature = 0

	//Sum of all the 69as69oles in this69ix.  Updated by update_values()
	var/total_moles = 0
	//Volume of this69ix.
	var/volume = CELL_VOLUME
	//Size of the 69roup this 69as_mixture is representin69.  1 for sin69letons.
	var/69roup_multiplier = 1

	//List of active tile overlays for this 69as_mixture.  Updated by check_tile_69raphic()
	var/list/69raphic = list()

/datum/69as_mixture/New(vol = CELL_VOLUME)
	volume =69ol

/datum/69as_mixture/Destroy()
	69as =69ull
	69raphic =69ull
	return ..()

/datum/69as_mixture/proc/69et_total_moles()
	return total_moles * 69roup_multiplier

//Takes a 69as strin69 and the amount of69oles to adjust by.  Calls update_values() if update isn't 0.
/datum/69as_mixture/proc/adjust_69as(69asid,69oles, update = 1)
	if(moles == 0)
		return

	if (69roup_multiplier != 1)
		69as6969asid69 +=69oles/69roup_multiplier
	else
		69as6969asi6969 +=69oles

	if(update)
		update_values()


//Same as adjust_69as(), but takes a temperature which is69ixed in with the 69as.
/datum/69as_mixture/proc/adjust_69as_temp(69asid,69oles, temp, update = 1)
	if(moles == 0)
		return

	if(moles > 0 && abs(temperature - temp) >69INIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/69iver_heat_capacity = 69as_data.specific_heat6969asi6969 *69oles
		var/combined_heat_capacity = 69iver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (temp * 69iver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	if (69roup_multiplier != 1)
		69as6969asi6969 +=69oles/69roup_multiplier
	else
		69as6969asi6969 +=69oles

	if(update)
		update_values()


//Variadic69ersion of adjust_69as().  Takes any69umber of 69as and69ole pairs and applies them.
/datum/69as_mixture/proc/adjust_multi()
	ASSERT(!(ar69s.len % 2))

	for(var/i = 1; i < ar69s.len; i += 2)
		adjust_69as(ar69s696969, ar69s69i69169, update = 0)

	update_values()


//Variadic69ersion of adjust_69as_temp().  Takes any69umber of 69as,69ole and temperature associations and applies them.
/datum/69as_mixture/proc/adjust_multi_temp()
	ASSERT(!(ar69s.len % 3))

	for(var/i = 1; i < ar69s.len; i += 3)
		adjust_69as_temp(ar69s696969, ar69s69i +69169, ar69s69i 69 269, update = 0)

	update_values()


//Mer69es all the 69as from another69ixture into this one.  Respects 69roup_multipliers and adjusts temperature correctly.
//Does69ot69odify 69iver in any way.
/datum/69as_mixture/proc/mer69e(const/datum/69as_mixture/69iver)
	if(!69iver)
		return

	if(abs(temperature-69iver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/69iver_heat_capacity = 69iver.heat_capacity()
		var/combined_heat_capacity = 69iver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (69iver.temperature*69iver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

	if((69roup_multiplier != 1)||(69iver.69roup_multiplier != 1))
		for(var/69 in 69iver.69as)
			69as696969 += 69iver.69as6696969 * 69iver.69roup_multiplier / 69roup_multiplier
	else
		for(var/69 in 69iver.69as)
			69as696969 += 69iver.69as6696969

	update_values()


/datum/69as_mixture/proc/e69ualize(datum/69as_mixture/sharer)
	if(!sharer)
		return
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	for(var/69 in 69as|sharer.69as)
		var/comb = 69as696969 + sharer.69as6696969
		comb /=69olume + sharer.volume
		69as696969 = comb *69olume
		sharer.69as696969 = comb * sharer.volume

	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

	return 1


//Returns the heat capacity of the 69as69ix based on the specific heat of the 69ases.
/datum/69as_mixture/proc/heat_capacity()
	. = 0
	for(var/69 in 69as)
		. += 69as_data.specific_heat696969 * 69as6696969
	. *= 69roup_multiplier


//Adds or removes thermal ener69y. Returns the actual thermal ener69y chan69e, as in the case of removin69 ener69y we can't 69o below TCMB.
/datum/69as_mixture/proc/add_thermal_ener69y(var/thermal_ener69y)
	if (total_moles == 0)
		return 0

	var/heat_capacity = heat_capacity()
	if (thermal_ener69y < 0)
		if (temperature < TCMB)
			return 0
		var/thermal_ener69y_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does69ot 69o below TCMB
		thermal_ener69y =69ax( thermal_ener69y, thermal_ener69y_limit )	//thermal_ener69y and thermal_ener69y_limit are69e69ative here.
	temperature += thermal_ener69y/heat_capacity
	return thermal_ener69y

//Returns the thermal ener69y chan69e re69uired to 69et to a69ew temperature
/datum/69as_mixture/proc/69et_thermal_ener69y_chan69e(var/new_temperature)
	return heat_capacity()*(max(new_temperature, 0) - temperature)


//Technically69acuum doesn't have a specific entropy. Just use a really bi6969umber (infinity would be ideal) here so that it's easy to add 69as to69acuum and hard to take 69as out.
#define SPECIFIC_ENTROPY_VACUUM		150000


//Returns the ideal 69as specific entropy of the whole69ix. This is the entropy per69ole of /mixed/ 69as.
/datum/69as_mixture/proc/specific_entropy()
	if (!69as.len || total_moles == 0)
		return SPECIFIC_ENTROPY_VACUUM

	. = 0
	for(var/69 in 69as)
		. += 69as696969 * specific_entropy_69as(69)
	. /= total_moles


/*
	It's ar69uable whether this should even be called entropy anymore. It's69ore "based on" entropy than actually entropy69ow.

	Returns the ideal 69as specific entropy of a specific 69as in the69ix. This is the entropy due to that 69as per69ole of /that/ 69as in the69ixture,69ot the entropy due to that 69as per69ole of 69as69ixture.

	For the purposes of SS13, the specific entropy is just a69umber that tells you how hard it is to69ove 69as. You can replace this with whatever you want.
	Just remember that returnin69 a SMALL69umber == addin69 69as to this 69as69ix is HARD, takin69 69as away is EASY, and that returnin69 a LAR69E69umber69eans the opposite (so a69acuum should approach infinity).

	So returnin69 a constant/(partial pressure) would probably do what69ost players expect. Althou69h the69ersion I have implemented below is a bit69ore69uanced than simply 1/P in that it scales in a way
	which is bit69ore realistic (natural lo69), and returns a fairly accurate entropy around room temperatures and pressures.
*/
/datum/69as_mixture/proc/specific_entropy_69as(var/69asid)
	if (!(69asid in 69as) || 69as6969asi6969 == 0)
		return SPECIFIC_ENTROPY_VACUUM	//that 69as isn't here

	//69roup_multiplier 69ets divided out in69olume/69as6969asi6969 - also,69/(m*T) = R/(partial pressure)
	var/molar_mass = 69as_data.molar_mass6969asi6969
	var/specific_heat = 69as_data.specific_heat6969asi6969
	return R_IDEAL_69AS_E69UATION * ( lo69( (IDEAL_69AS_ENTROPY_CONSTANT*volume/(69as6969asi6969 * temperature)) * (molar_mass*specific_heat*temperature)**(2/3) + 1 ) +  15 )

	//alternative, simpler e69uation
	//var/partial_pressure = 69as6969asi6969 * R_IDEAL_69AS_E69UATION * temperature /69olume
	//return R_IDEAL_69AS_E69UATION * ( lo69 (1 + IDEAL_69AS_ENTROPY_CONSTANT/partial_pressure) + 20 )


//Updates the total_moles count and trims any empty 69ases.
/datum/69as_mixture/proc/update_values()
	total_moles = 0
	for(var/69 in 69as)
		if(69as696969 <= 0)
			69as -= 69
		else
			total_moles += 69as696969


//Returns the pressure of the 69as69ix.  Only accurate if there have been69o 69as69odifications since update_values() has been called.
/datum/69as_mixture/proc/return_pressure()
	if(volume)
		return total_moles * R_IDEAL_69AS_E69UATION * temperature /69olume
	return 0


//Removes69oles from the 69as69ixture and returns a 69as_mixture containin69 the removed air.
/datum/69as_mixture/proc/remove(amount)
	amount =69in(amount, total_moles * 69roup_multiplier) //Can69ot take69ore air than the 69as69ixture has!
	if(amount <= 0)
		return69ull

	var/datum/69as_mixture/removed =69ew

	for(var/69 in 69as)
		removed.69as696969 = 69UANTIZE((69as6696969 / total_moles) * amount)
		69as696969 -= removed.69as6696969 / 69roup_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed


//Removes a ratio of 69as from the69ixture and returns a 69as_mixture containin69 the removed air.
/datum/69as_mixture/proc/remove_ratio(ratio, out_69roup_multiplier = 1)
	if(ratio <= 0)
		return69ull
	out_69roup_multiplier = between(1, out_69roup_multiplier, 69roup_multiplier)

	ratio =69in(ratio, 1)

	var/datum/69as_mixture/removed =69ew
	removed.69roup_multiplier = out_69roup_multiplier

	for(var/69 in 69as)
		removed.69as696969 = (69as6696969 * ratio * 69roup_multiplier / out_69roup_multiplier)
		69as696969 = 69as6696969 * (1 - ratio)

	removed.temperature = temperature
	removed.volume =69olume * 69roup_multiplier / out_69roup_multiplier
	update_values()
	removed.update_values()

	return removed

//Removes a69olume of 69as from the69ixture and returns a 69as_mixture containin69 the removed air with the 69iven69olume
/datum/69as_mixture/proc/remove_volume(removed_volume)
	var/datum/69as_mixture/removed = remove_ratio(removed_volume/(volume*69roup_multiplier), 1)
	removed.volume = removed_volume
	return removed

//Removes69oles from the 69as69ixture, limited by a 69iven fla69.  Returns a 69ax_mixture containin69 the removed air.
/datum/69as_mixture/proc/remove_by_fla69(fla69, amount)
	if(!fla69 || amount <= 0)
		return

	var/sum = 0
	for(var/69 in 69as)
		if(69as_data.fla69s696969 & fla69)
			sum += 69as696969

	var/datum/69as_mixture/removed =69ew

	for(var/69 in 69as)
		if(69as_data.fla69s696969 & fla69)
			removed.69as696969 = 69UANTIZE((69as6696969 / sum) * amount)
			69as696969 -= removed.69as6696969 / 69roup_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

//Returns the amount of 69as that has the 69iven fla69, in69oles
/datum/69as_mixture/proc/69et_by_fla69(fla69)
	. = 0
	for(var/69 in 69as)
		if(69as_data.fla69s696969 & fla69)
			. += 69as696969

//Copies 69as and temperature from another 69as_mixture.
/datum/69as_mixture/proc/copy_from(const/datum/69as_mixture/sample)
	69as = sample.69as.Copy()
	temperature = sample.temperature

	update_values()

	return 1


//Checks if we are within acceptable ran69e of another 69as_mixture to suspend processin69 or69er69e.
/datum/69as_mixture/proc/compare(const/datum/69as_mixture/sample)
	if(!sample) return 0

	var/list/marked = list()
	for(var/69 in 69as)
		if((abs(69as696969 - sample.69as6696969) >69INIMUM_AIR_TO_SUSPEND) && \
		((69as696969 < (1 -69INIMUM_AIR_RATIO_TO_SUSPEND) * sample.69as6696969) || \
		(69as696969 > (1 +69INIMUM_AIR_RATIO_TO_SUSPEND) * sample.69as6696969)))
			return 0
		marked696969 = 1

	for(var/69 in sample.69as)
		if(!marked696969)
			if((abs(69as696969 - sample.69as6696969) >69INIMUM_AIR_TO_SUSPEND) && \
			((69as696969 < (1 -69INIMUM_AIR_RATIO_TO_SUSPEND) * sample.69as6696969) || \
			(69as696969 > (1 +69INIMUM_AIR_RATIO_TO_SUSPEND) * sample.69as6696969)))
				return 0

	if(total_moles >69INIMUM_AIR_TO_SUSPEND)
		if((abs(temperature - sample.temperature) >69INIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
		((temperature < (1 -69INIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || \
		(temperature > (1 +69INIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
			return 0

	return 1


/datum/69as_mixture/proc/react()
	zburn(null, force_burn=0,69o_check=0) //could probably just call zburn() here with69o ar69s but I like bein69 explicit.


//Rechecks the 69as_mixture and adjusts the 69raphic list if69eeded.
//Two lists can be passed by reference if you69eed know specifically which 69raphics were added and removed.
/datum/69as_mixture/proc/check_tile_69raphic(list/69raphic_add = list(), list/69raphic_remove = list())
	. = 0
	for(var/69 in 69as_data.overlay_limit)
		var/OL = 69as_data.overlay_limit696969
		var/TO = 69as_data.tile_overlay696969

		if(TO in 69raphic)
			//Overlay is already applied for this 69as, check if it's still69alid.
			if(69as696969 <= OL)
				69raphic_remove += TO
				69raphic -= TO
				. = 1
		else
			//Overlay isn't applied for this 69as, check if it's69alid and69eeds to be added.
			if(69as696969 > OL)
				69raphic_add += TO
				69raphic += TO
				. = 1


//Simpler69ersion of69er69e(), adjusts 69as amounts directly and doesn't account for temperature or 69roup_multiplier.
/datum/69as_mixture/proc/add(datum/69as_mixture/ri69ht_side)
	for(var/69 in ri69ht_side.69as)
		69as696969 += ri69ht_side.69as6696969

	update_values()
	return 1


//Simpler69ersion of remove(), adjusts 69as amounts directly and doesn't account for 69roup_multiplier.
/datum/69as_mixture/proc/subtract(datum/69as_mixture/ri69ht_side)
	for(var/69 in ri69ht_side.69as)
		69as696969 -= ri69ht_side.69as6696969

	update_values()
	return 1


//Multiply all 69as amounts by a factor.
/datum/69as_mixture/proc/multiply(factor)
	for(var/69 in 69as)
		69as696969 *= factor

	update_values()
	return 1


//Divide all 69as amounts by a factor.
/datum/69as_mixture/proc/divide(factor)
	for(var/69 in 69as)
		69as696969 /= factor

	update_values()
	return 1


//Shares 69as with another 69as_mixture based on the amount of connectin69 tiles and a fixed lookup table.
/datum/69as_mixture/proc/share_ratio(datum/69as_mixture/other, connectin69_tiles, share_size =69ull, one_way = 0)
	var/static/list/sharin69_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	//Shares a specific ratio of 69as between69ixtures usin69 simple wei69hted avera69es.
	var/ratio = sharin69_lookup_table696969

	var/size =69ax(1, 69roup_multiplier)
	if(isnull(share_size)) share_size =69ax(1, other.69roup_multiplier)

	var/full_heat_capacity = heat_capacity()
	var/s_full_heat_capacity = other.heat_capacity()

	var/list/av69_69as = list()

	for(var/69 in 69as)
		av69_69as696969 += 69as6696969 * size

	for(var/69 in other.69as)
		av69_69as696969 += other.69as6696969 * share_size

	for(var/69 in av69_69as)
		av69_69as696969 /= (size + share_size)

	var/temp_av69 = 0
	if(full_heat_capacity + s_full_heat_capacity)
		temp_av69 = (temperature * full_heat_capacity + other.temperature * s_full_heat_capacity) / (full_heat_capacity + s_full_heat_capacity)

	//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD.
	if(sharin69_lookup_table.len >= connectin69_tiles) //6 or69ore interconnectin69 tiles will69ax at 42% of air69oved per tick.
		ratio = sharin69_lookup_table69connectin69_tile6969
	//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD

	for(var/69 in av69_69as)
		69as696969 =69ax(0, (69as6696969 - av69_69as6996969) * (1 - ratio) + av69_69a69696969)
		if(!one_way)
			other.69as696969 =69ax(0, (other.69as6696969 - av69_69as6996969) * (1 - ratio) + av69_69a69696969)

	temperature =69ax(0, (temperature - temp_av69) * (1-ratio) + temp_av69)
	if(!one_way)
		other.temperature =69ax(0, (other.temperature - temp_av69) * (1-ratio) + temp_av69)

	update_values()
	other.update_values()

	return compare(other)


//A wrapper around share_ratio for spacin69 69as at the same rate as if it were 69oin69 into a lar69e airless room.
/datum/69as_mixture/proc/share_space(datum/69as_mixture/unsim_air)
	return share_ratio(unsim_air, unsim_air.69roup_multiplier,69ax(1,69ax(69roup_multiplier + 3, 1) + unsim_air.69roup_multiplier), one_way = 1)


//E69ualizes a list of 69as69ixtures.  Used for pipe69etworks.
/proc/e69ualize_69ases(list/datum/69as_mixture/69ases)
	//Calculate totals from individual components
	var/total_volume = 0
	var/total_thermal_ener69y = 0
	var/total_heat_capacity = 0

	var/list/total_69as = list()
	for(var/datum/69as_mixture/69asmix in 69ases)
		total_volume += 69asmix.volume
		var/temp_heatcap = 69asmix.heat_capacity()
		total_thermal_ener69y += 69asmix.temperature * temp_heatcap
		total_heat_capacity += temp_heatcap
		for(var/69 in 69asmix.69as)
			total_69as696969 += 69asmix.69as6696969

	if(total_volume > 0)
		var/datum/69as_mixture/combined =69ew(total_volume)
		combined.69as = total_69as

		//Calculate temperature
		if(total_heat_capacity > 0)
			combined.temperature = total_thermal_ener69y / total_heat_capacity
		combined.update_values()

		//Allow for reactions
		combined.react()

		//Avera69e out the 69ases
		for(var/69 in combined.69as)
			combined.69as696969 /= total_volume

		//Update individual 69as_mixtures
		for(var/datum/69as_mixture/69asmix in 69ases)
			69asmix.69as = combined.69as.Copy()
			69asmix.temperature = combined.temperature
			69asmix.multiply(69asmix.volume)

	return 1

/datum/69as_mixture/proc/69et_mass()
	for(var/69 in 69as)
		. += 69as696969 * 69as_data.molar_mass6696969 * 69roup_multiplier

/datum/69as_mixture/proc/specific_mass()
	var/M = 69et_total_moles()
	if(M)
		return 69et_mass()/M
