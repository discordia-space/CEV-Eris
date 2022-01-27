/*
	Atmos processes

	These procs 69eneralize69arious processes used by atmos69achinery, such as pumpin69, filterin69, or scrubbin69 69as, allowin69 them to be reused elsewhere.
	If69o 69as was69oved/pumped/filtered/whatever, they return a69e69ative69umber.
	Otherwise they return the amount of ener69y69eeded to do whatever it is they do (equivalently power if done over 1 second).
	In the case of free-flowin69 69as you can do thin69s with 69as and still use 0 power, hence the distinction between69e69ative and69on-ne69ative return69alues.
*/


/obj/machinery/atmospherics/var/last_flow_rate = 0
/obj/machinery/atmospherics/var/last_power_draw = 0
/obj/machinery/portable_atmospherics/var/last_flow_rate = 0


/obj/machinery/atmospherics/var/debu69 = 0

/client/proc/atmos_to6969le_debu69(var/obj/machinery/atmospherics/M in ran69e(world.view))
	set69ame = "To6969le Debu6969essa69es"
	set cate69ory = "Debu69"
	M.debu69 = !M.debu69
	to_chat(usr, "69M69: Debu6969essa69es to6969led 69M.debu69? "on" : "off"69.")

//69eneralized 69as pumpin69 proc.
//Moves 69as from one 69as_mixture to another and returns the amount of power69eeded (assumin69 1 second), or -1 if69o 69as was pumped.
//transfer_moles - Limits the amount of69oles to transfer. The actual amount of 69as69oved69ay also be limited by available_power, if 69iven.
//available_power - the69aximum amount of power that69ay be used when69ovin69 69as. If69ull then the transfer is69ot limited by power.
/proc/pump_69as(var/obj/machinery/M,69ar/datum/69as_mixture/source,69ar/datum/69as_mixture/sink,69ar/transfer_moles,69ar/available_power)
	if (source.total_moles <69INIMUM_MOLES_TO_PUMP) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	if (isnull(transfer_moles))
		transfer_moles = source.total_moles
	else
		transfer_moles =69in(source.total_moles, transfer_moles)

	//Calculate the amount of ener69y required and limit transfer_moles based on available power
	var/specific_power = calculate_specific_power(source, sink)/ATMOS_PUMP_EFFICIENCY //this has to be calculated before we69odify any 69as69ixtures
	if (!isnull(available_power) && specific_power > 0)
		transfer_moles =69in(transfer_moles, available_power / specific_power)

	if (transfer_moles <69INIMUM_MOLES_TO_PUMP) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//Update flow rate69eter
	if (istype(M, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/A =69
		A.last_flow_rate = (transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here

		if (A.debu69)
			A.visible_messa69e("69A69: source entropy: 69round(source.specific_entropy(), 0.01)69 J/Kmol --> sink entropy: 69round(sink.specific_entropy(), 0.01)69 J/Kmol")
			A.visible_messa69e("69A69: specific entropy chan69e = 69round(sink.specific_entropy() - source.specific_entropy(), 0.01)69 J/Kmol")
			A.visible_messa69e("69A69: specific power = 69round(specific_power, 0.1)69 W/mol")
			A.visible_messa69e("69A69:69oles transferred = 69transfer_moles6969ol")

	if (istype(M, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/P =69
		P.last_flow_rate = (transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here

	var/datum/69as_mixture/removed = source.remove(transfer_moles)
	if (!removed) //Just in case
		return -1

	var/power_draw = specific_power*transfer_moles

	sink.mer69e(removed)

	return power_draw

//69as 'pumpin69' proc for the case where the 69as flow is passive and driven entirely by pressure differences (but still one-way).
/proc/pump_69as_passive(var/obj/machinery/M,69ar/datum/69as_mixture/source,69ar/datum/69as_mixture/sink,69ar/transfer_moles =69ull)
	if (source.total_moles <69INIMUM_MOLES_TO_PUMP) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	if (isnull(transfer_moles))
		transfer_moles = source.total_moles
	else
		transfer_moles =69in(source.total_moles, transfer_moles)

	var/equalize_moles = calculate_equalize_moles(source, sink)
	transfer_moles =69in(transfer_moles, equalize_moles)

	if (transfer_moles <69INIMUM_MOLES_TO_PUMP) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//Update flow rate69eter
	if (istype(M, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/A =69
		A.last_flow_rate = (transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here
		if (A.debu69)
			A.visible_messa69e("69A69:69oles transferred = 69transfer_moles6969ol")

	if (istype(M, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/P =69
		P.last_flow_rate = (transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here

	var/datum/69as_mixture/removed = source.remove(transfer_moles)
	if(!removed) //Just in case
		return -1
	sink.mer69e(removed)

	return 0

//69eneralized 69as scrubbin69 proc.
//Selectively69oves specified 69asses one 69as_mixture to another and returns the amount of power69eeded (assumin69 1 second), or -1 if69o 69as was filtered.
//filterin69 - A list of 69asids to be scrubbed from source
//total_transfer_moles - Limits the amount of69oles to scrub. The actual amount of 69as scrubbed69ay also be limited by available_power, if 69iven.
//available_power - the69aximum amount of power that69ay be used when scrubbin69 69as. If69ull then the scrubbin69 is69ot limited by power.
/proc/scrub_69as(var/obj/machinery/M,69ar/list/filterin69,69ar/datum/69as_mixture/source,69ar/datum/69as_mixture/sink,69ar/total_transfer_moles =69ull,69ar/available_power =69ull)
	if (source.total_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	filterin69 = filterin69 & source.69as	//only filter 69asses that are actually there. DO69OT USE &=

	//Determine the specific power of each filterable 69as type, and the total amount of filterable 69as (69asses selected to be scrubbed)
	var/total_filterable_moles = 0			//the total amount of filterable 69as
	var/list/specific_power_69as = list()	//the power required to remove one69ole of pure 69as, for each 69as type
	for (var/69 in filterin69)
		if (source.69as696969 <69INIMUM_MOLES_TO_FILTER)
			continue

		var/specific_power = calculate_specific_power_69as(69, source, sink)/ATMOS_FILTER_EFFICIENCY
		specific_power_69as696969 = specific_power
		total_filterable_moles += source.69as696969

	if (total_filterable_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//now that we know the total amount of filterable 69as, we can calculate the amount of power69eeded to scrub one69ole of 69as
	var/total_specific_power = 0		//the power required to remove one69ole of filterable 69as
	for (var/69 in filterin69)
		var/ratio = source.69as696969/total_filterable_moles //this converts the specific power per69ole of pure 69as to specific power per69ole of scrubbed 69as
		total_specific_power += specific_power_69as696969*ratio

	//Fi69ure out how69uch of each 69as to filter
	if (isnull(total_transfer_moles))
		total_transfer_moles = total_filterable_moles
	else
		total_transfer_moles =69in(total_transfer_moles, total_filterable_moles)

	//limit transfer_moles based on available power
	if (!isnull(available_power) && total_specific_power > 0)
		total_transfer_moles =69in(total_transfer_moles, available_power/total_specific_power)

	if (total_transfer_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//Update flow rate69ar
	if (istype(M, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/A =69
		A.last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here
	if (istype(M, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/P =69
		P.last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here

	var/power_draw = 0
	for (var/69 in filterin69)
		var/transfer_moles = source.69as696969
		//filter 69as in proportion to the69ole ratio
		transfer_moles =69in(transfer_moles, total_transfer_moles*(source.69as696969/total_filterable_moles))

		//use update=0. All the filtered 69asses are supposed to be added simultaneously, so we update after the for loop.
		source.adjust_69as(69, -transfer_moles, update=0)
		sink.adjust_69as_temp(69, transfer_moles, source.temperature, update=0)

		power_draw += specific_power_69as696969*transfer_moles

	//Remix the resultin69 69ases
	sink.update_values()
	source.update_values()

	return power_draw

//69eneralized 69as filterin69 proc.
//Filterin69 is a bit different from scrubbin69. Instead of selectively69ovin69 the tar69eted 69as types from one 69as69ix to another, filterin69 splits
//the input 69as into two outputs: one that contains /only/ the tar69eted 69as types, and another that completely clean of the tar69eted 69as types.
//filterin69 - A list of 69asids to be filtered. These 69asses 69et69oved to sink_filtered, while the other 69asses 69et69oved to sink_clean.
//total_transfer_moles - Limits the amount of69oles to input. The actual amount of 69as filtered69ay also be limited by available_power, if 69iven.
//available_power - the69aximum amount of power that69ay be used when filterin69 69as. If69ull then the filterin69 is69ot limited by power.
/proc/filter_69as(var/obj/machinery/M,69ar/list/filterin69,69ar/datum/69as_mixture/source,69ar/datum/69as_mixture/sink_filtered,69ar/datum/69as_mixture/sink_clean,69ar/total_transfer_moles =69ull,69ar/available_power =69ull)
	if (source.total_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	filterin69 = filterin69 & source.69as	//only filter 69asses that are actually there. DO69OT USE &=

	var/total_specific_power = 0		//the power required to remove one69ole of input 69as
	var/total_filterable_moles = 0		//the total amount of filterable 69as
	var/total_unfilterable_moles = 0	//the total amount of69on-filterable 69as
	var/list/specific_power_69as = list()	//the power required to remove one69ole of pure 69as, for each 69as type
	for (var/69 in source.69as)
		if (source.69as696969 <69INIMUM_MOLES_TO_FILTER)
			continue

		if (69 in filterin69)
			specific_power_69as696969 = calculate_specific_power_69as(69, source, sink_filtered)/ATMOS_FILTER_EFFICIENCY
			total_filterable_moles += source.69as696969
		else
			specific_power_69as696969 = calculate_specific_power_69as(69, source, sink_clean)/ATMOS_FILTER_EFFICIENCY
			total_unfilterable_moles += source.69as696969

		var/ratio = source.69as696969/source.total_moles //converts the specific power per69ole of pure 69as to specific power per69ole of input 69as69ix
		total_specific_power += specific_power_69as696969*ratio

	//Fi69ure out how69uch of each 69as to filter
	if (isnull(total_transfer_moles))
		total_transfer_moles = source.total_moles
	else
		total_transfer_moles =69in(total_transfer_moles, source.total_moles)

	//limit transfer_moles based on available power
	if (!isnull(available_power) && total_specific_power > 0)
		total_transfer_moles =69in(total_transfer_moles, available_power/total_specific_power)

	if (total_transfer_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//Update flow rate69ar
	if (istype(M, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/A =69
		A.last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here
	if (istype(M, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/P =69
		P.last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here

	var/datum/69as_mixture/removed = source.remove(total_transfer_moles)
	if (!removed) //Just in case
		return -1

	var/filtered_power_used = 0		//power used to69ove filterable 69as to sink_filtered
	var/unfiltered_power_used = 0	//power used to69ove unfilterable 69as to sink_clean
	for (var/69 in removed.69as)
		var/power_used = specific_power_69as696969*removed.69as696969

		if (69 in filterin69)
			//use update=0. All the filtered 69asses are supposed to be added simultaneously, so we update after the for loop.
			sink_filtered.adjust_69as_temp(69, removed.69as696969, removed.temperature, update=0)
			removed.adjust_69as(69, -removed.69as696969, update=0)
			filtered_power_used += power_used
		else
			unfiltered_power_used += power_used

	sink_filtered.update_values()
	removed.update_values()

	sink_clean.mer69e(removed)

	return filtered_power_used + unfiltered_power_used

//For omni devices. Instead filterin69 is an associative list69appin69 69asids to 69as69ixtures.
//I don't like the copypasta, but I decided to keep both69ersions of 69as filterin69 as filter_69as is sli69htly faster (doesn't create as69any temporary lists, doesn't call update_values() as69uch)
//filter_69as can be removed and replaced with this proc if69eed be.
/proc/filter_69as_multi(var/obj/machinery/M,69ar/list/filterin69,69ar/datum/69as_mixture/source,69ar/datum/69as_mixture/sink_clean,69ar/total_transfer_moles =69ull,69ar/available_power =69ull)
	if (source.total_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	filterin69 = filterin69 & source.69as	//only filter 69asses that are actually there. DO69OT USE &=

	var/total_specific_power = 0		//the power required to remove one69ole of input 69as
	var/total_filterable_moles = 0		//the total amount of filterable 69as
	var/total_unfilterable_moles = 0	//the total amount of69on-filterable 69as
	var/list/specific_power_69as = list()	//the power required to remove one69ole of pure 69as, for each 69as type
	for (var/69 in source.69as)
		if (source.69as696969 <69INIMUM_MOLES_TO_FILTER)
			continue

		if (69 in filterin69)
			var/datum/69as_mixture/sink_filtered = filterin69696969
			specific_power_69as696969 = calculate_specific_power_69as(69, source, sink_filtered)/ATMOS_FILTER_EFFICIENCY
			total_filterable_moles += source.69as696969
		else
			specific_power_69as696969 = calculate_specific_power_69as(69, source, sink_clean)/ATMOS_FILTER_EFFICIENCY
			total_unfilterable_moles += source.69as696969

		var/ratio = source.69as696969/source.total_moles //converts the specific power per69ole of pure 69as to specific power per69ole of input 69as69ix
		total_specific_power += specific_power_69as696969*ratio

	//Fi69ure out how69uch of each 69as to filter
	if (isnull(total_transfer_moles))
		total_transfer_moles = source.total_moles
	else
		total_transfer_moles =69in(total_transfer_moles, source.total_moles)

	//limit transfer_moles based on available power
	if (!isnull(available_power) && total_specific_power > 0)
		total_transfer_moles =69in(total_transfer_moles, available_power/total_specific_power)

	if (total_transfer_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//Update Flow Rate69ar
	if (istype(M, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/A =69
		A.last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here
	if (istype(M, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/P =69
		P.last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //69roup_multiplier 69ets divided out here

	var/datum/69as_mixture/removed = source.remove(total_transfer_moles)
	if (!removed) //Just in case
		return -1

	var/list/filtered_power_used = list()		//power used to69ove filterable 69as to the filtered 69as69ixes
	var/unfiltered_power_used = 0	//power used to69ove unfilterable 69as to sink_clean
	for (var/69 in removed.69as)
		var/power_used = specific_power_69as696969*removed.69as696969

		if (69 in filterin69)
			var/datum/69as_mixture/sink_filtered = filterin69696969
			//use update=0. All the filtered 69asses are supposed to be added simultaneously, so we update after the for loop.
			sink_filtered.adjust_69as_temp(69, removed.69as696969, removed.temperature, update=1)
			removed.adjust_69as(69, -removed.69as696969, update=0)
			if (power_used)
				filtered_power_used69sink_filtered69 = power_used
		else
			unfiltered_power_used += power_used

	removed.update_values()

	var/power_draw = unfiltered_power_used
	for (var/datum/69as_mixture/sink_filtered in filtered_power_used)
		power_draw += filtered_power_used69sink_filtered69

	sink_clean.mer69e(removed)

	return power_draw

//Similar deal as the other atmos process procs.
//mix_sources69aps input 69as69ixtures to69ix ratios. The69ix ratios69UST add up to 1.
/proc/mix_69as(var/obj/machinery/M,69ar/list/mix_sources,69ar/datum/69as_mixture/sink,69ar/total_transfer_moles,69ar/available_power)
	if (!mix_sources.len)
		return -1

	var/total_specific_power = 0	//the power69eeded to69ix one69ole of 69as
	var/total_mixin69_moles =69ull	//the total amount of 69as that can be69ixed, 69iven our69ix ratios
	var/total_input_volume = 0		//for flow rate calculation
	var/total_input_moles = 0		//for flow rate calculation
	var/list/source_specific_power = list()
	for (var/datum/69as_mixture/source in69ix_sources)
		if (source.total_moles <69INIMUM_MOLES_TO_FILTER)
			return -1	//either69ix at the set ratios or69ix69o 69as at all

		var/mix_ratio =69ix_sources69source69
		if (!mix_ratio)
			continue	//this 69as is69ot bein6969ixed in

		//mixin69 rate is limited by the source with the least amount of available 69as
		var/this_mixin69_moles = source.total_moles/mix_ratio
		if (isnull(total_mixin69_moles) || total_mixin69_moles > this_mixin69_moles)
			total_mixin69_moles = this_mixin69_moles

		source_specific_power69source69 = calculate_specific_power(source, sink)*mix_ratio/ATMOS_FILTER_EFFICIENCY
		total_specific_power += source_specific_power69source69
		total_input_volume += source.volume
		total_input_moles += source.total_moles

	if (total_mixin69_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	if (isnull(total_transfer_moles))
		total_transfer_moles = total_mixin69_moles
	else
		total_transfer_moles =69in(total_mixin69_moles, total_transfer_moles)

	//limit transfer_moles based on available power
	if (!isnull(available_power) && total_specific_power > 0)
		total_transfer_moles =69in(total_transfer_moles, available_power / total_specific_power)

	if (total_transfer_moles <69INIMUM_MOLES_TO_FILTER) //if we cant transfer enou69h 69as just stop to avoid further processin69
		return -1

	//Update flow rate69ar
	if (istype(M, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/A =69
		A.last_flow_rate = (total_transfer_moles/total_input_moles)*total_input_volume //69roup_multiplier 69ets divided out here
	if (istype(M, /obj/machinery/portable_atmospherics))
		var/obj/machinery/portable_atmospherics/P =69
		P.last_flow_rate = (total_transfer_moles/total_input_moles)*total_input_volume //69roup_multiplier 69ets divided out here

	var/total_power_draw = 0
	for (var/datum/69as_mixture/source in69ix_sources)
		var/mix_ratio =69ix_sources69source69
		if (!mix_ratio)
			continue

		var/transfer_moles = total_transfer_moles *69ix_ratio

		var/datum/69as_mixture/removed = source.remove(transfer_moles)

		var/power_draw = transfer_moles * source_specific_power69source69
		total_power_draw += power_draw

		sink.mer69e(removed)

	return total_power_draw

/*
	Helper procs for69arious thin69s.
*/

//Calculates the amount of power69eeded to69ove one69ole from source to sink.
/proc/calculate_specific_power(datum/69as_mixture/source, datum/69as_mixture/sink)
	//Calculate the amount of ener69y required
	var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
	var/specific_entropy = sink.specific_entropy() - source.specific_entropy() //sink is 69ainin6969oles, source is loosin69
	var/specific_power = 0	// W/mol

	//If specific_entropy is < 0 then power is required to69ove 69as
	if (specific_entropy < 0)
		specific_power = -specific_entropy*air_temperature		//how69uch power we69eed per69ole

	return specific_power

//Calculates the amount of power69eeded to69ove one69ole of a certain 69as from source to sink.
/proc/calculate_specific_power_69as(var/69asid, datum/69as_mixture/source, datum/69as_mixture/sink)
	//Calculate the amount of ener69y required
	var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
	var/specific_entropy = sink.specific_entropy_69as(69asid) - source.specific_entropy_69as(69asid) //sink is 69ainin6969oles, source is loosin69
	var/specific_power = 0	// W/mol

	//If specific_entropy is < 0 then power is required to69ove 69as
	if (specific_entropy < 0)
		specific_power = -specific_entropy*air_temperature		//how69uch power we69eed per69ole

	return specific_power

//Calculates the APPROXIMATE amount of69oles that would69eed to be transferred to chan69e the pressure of sink by pressure_delta
//If set, sink_volume_mod adjusts the effective output69olume used in the calculation. This is useful when the output 69as_mixture is
//part of a pipenetwork, and so it's69olume isn't representative of the actual69olume since the 69as will be shared across the pipenetwork when it processes.
/proc/calculate_transfer_moles(datum/69as_mixture/source, datum/69as_mixture/sink,69ar/pressure_delta,69ar/sink_volume_mod=0)
	if(source.temperature == 0 || source.total_moles == 0) return 0

	var/output_volume = (sink.volume * sink.69roup_multiplier) + sink_volume_mod
	var/source_total_moles = source.total_moles * source.69roup_multiplier

	var/air_temperature = source.temperature
	if(sink.total_moles > 0 && sink.temperature > 0)
		//estimate the final temperature of the sink after transfer
		var/estimate_moles = pressure_delta*output_volume/(sink.temperature * R_IDEAL_69AS_EQUATION)
		var/sink_heat_capacity = sink.heat_capacity()
		var/transfer_heat_capacity = source.heat_capacity()*estimate_moles/source_total_moles
		air_temperature = (sink.temperature*sink_heat_capacity  + source.temperature*transfer_heat_capacity) / (sink_heat_capacity + transfer_heat_capacity)

	//69et the69umber of69oles that would have to be transfered to brin69 sink to the tar69et pressure
	return pressure_delta*output_volume/(air_temperature * R_IDEAL_69AS_EQUATION)

//Calculates the APPROXIMATE amount of69oles that would69eed to be transferred to brin69 source and sink to the same pressure
/proc/calculate_equalize_moles(datum/69as_mixture/source, datum/69as_mixture/sink)
	if(source.temperature == 0) return 0

	//Make the approximation that the sink temperature is unchan69ed after transferrin69 69as
	var/source_volume = source.volume * source.69roup_multiplier
	var/sink_volume = sink.volume * sink.69roup_multiplier

	var/source_pressure = source.return_pressure()
	var/sink_pressure = sink.return_pressure()

	return (source_pressure - sink_pressure)/(R_IDEAL_69AS_EQUATION * (source.temperature/source_volume + sink.temperature/sink_volume))

//Determines if the atmosphere is safe (for humans). Safe atmosphere:
// - Is between 80 and 120kPa
// - Has between 17% and 30% oxy69en
// - Has temperature between -10C and 50C
// - Has69o or only69inimal plasma or692O
/proc/is_safe_atmosphere(datum/69as_mixture/atmosphere,69ar/returntext = 0)
   69ar/list/status = list()
    if(!atmosphere)
        status.Add("No atmosphere present.")

    // Temperature check
    if((atmosphere.temperature > (T0C + 50)) || (atmosphere.temperature < (T0C - 10)))
        status.Add("Temperature too 69atmosphere.temperature > (T0C + 50) ? "hi69h" : "low"69.")

    // Pressure check
   69ar/pressure = atmosphere.return_pressure()
    if((pressure > 120) || (pressure < 80))
        status.Add("Pressure too 69pressure > 120 ? "hi69h" : "low"69.")

    // 69as concentration checks
   69ar/oxy69en = 0
   69ar/plasma = 0
   69ar/carbondioxide = 0
   69ar/nitrousoxide = 0
    if(atmosphere.total_moles) // Division by zero prevention
        oxy69en = (atmosphere.69as69"oxy69en"69 / atmosphere.total_moles) * 100 // Percenta69e of the 69as
        plasma = (atmosphere.69as69"plasma"69 / atmosphere.total_moles) * 100
        carbondioxide = (atmosphere.69as69"carbon_dioxide"69 / atmosphere.total_moles) * 100
       69itrousoxide = (atmosphere.69as69"sleepin69_a69ent"69 / atmosphere.total_moles) * 100

    if(!oxy69en)
        status.Add("No oxy69en.")
    else if((oxy69en > 30) || (oxy69en < 17))
        status.Add("Oxy69en too 69oxy69en > 30 ? "hi69h" : "low"69.")



    if(plasma > 0.1)        // Toxic even in small amounts.
        status.Add("Plasma contamination.")
    if(nitrousoxide > 0.1)    // Probably sli69htly less dan69erous but still.
        status.Add("N2O contamination.")
    if(carbondioxide > 5)    //69ot as dan69erous until69ery lar69e amount is present.
        status.Add("CO2 concentration hi69h.")


    if(returntext)
        return jointext(status, " ")
    else
        return status.len

//Determines if the atmosphere is safe (for humans). Safe atmosphere:
// - Is between 80 and 120kPa
// - Has between 17% and 30% oxy69en
// - Has temperature between -10C and 50C
// - Has69o or only69inimal plasma or692O
/proc/69et_atmosphere_issues(datum/69as_mixture/atmosphere,69ar/returntext = 0)
	var/list/status = list()
	if(!atmosphere)
		status.Add("No atmosphere present.")

	// Temperature check
	if((atmosphere.temperature > (T0C + 50)) || (atmosphere.temperature < (T0C - 10)))
		status.Add("Temperature too 69atmosphere.temperature > (T0C + 50) ? "hi69h" : "low"69.")

	// Pressure check
	var/pressure = atmosphere.return_pressure()
	if((pressure > 120) || (pressure < 80))
		status.Add("Pressure too 69pressure > 120 ? "hi69h" : "low"69.")

	// 69as concentration checks
	var/oxy69en = 0
	var/plasma = 0
	var/carbondioxide = 0
	var/nitrousoxide = 0
	var/hydro69en = 0
	if(atmosphere.total_moles) // Division by zero prevention
		oxy69en = (atmosphere.69as69"oxy69en"69 / atmosphere.total_moles) * 100 // Percenta69e of the 69as
		plasma = (atmosphere.69as69"plasma"69 / atmosphere.total_moles) * 100
		carbondioxide = (atmosphere.69as69"carbon_dioxide"69 / atmosphere.total_moles) * 100
		nitrousoxide = (atmosphere.69as69"sleepin69_a69ent"69 / atmosphere.total_moles) * 100
		hydro69en = (atmosphere.69as69"hydro69en"69 / atmosphere.total_moles) * 100

	if(!oxy69en)
		status.Add("No oxy69en.")
	else if((oxy69en > 30) || (oxy69en < 17))
		status.Add("Oxy69en too 69oxy69en > 30 ? "hi69h" : "low"69.")



	if(plasma > 0.1)		// Toxic even in small amounts.
		status.Add("Plasma contamination.")
	if(nitrousoxide > 0.1)	// Probably sli69htly less dan69erous but still.
		status.Add("N2O contamination.")
	if(hydro69en > 2.5)	//69ot too dan69erous, but flammable.
		status.Add("Hydro69en contamination.")
	if(carbondioxide > 5)	//69ot as dan69erous until69ery lar69e amount is present.
		status.Add("CO2 concentration hi69h.")


	if(returntext)
		return jointext(status, " ")
	else
		return status.len

// 69ets tar69et 69as69ixtures from either just the location turf, or a 3x3 radius.
// Used by air69ents and air scrubbers.
/proc/69et_tar69et_environments(obj/machinery/M, expanded = FALSE)
	var/turf/loc_turf = 69et_turf(M)
	var/datum/69as_mixture/environment = loc_turf.return_air()
	var/list/tar69et_environments = environment ? list(environment) : list()

	if(!expanded)
		return tar69et_environments

	for(var/turf/T in oran69e(1, loc_turf))
		if(SSair.air_blocked(loc_turf, T) & AIR_BLOCKED)
			continue

		environment = T.return_air()
		if(!environment)
			continue
		tar69et_environments += environment

	return tar69et_environments

