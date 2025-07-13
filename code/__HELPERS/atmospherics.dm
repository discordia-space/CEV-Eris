/proc/analyze_gases(obj/A, mob/user)
	var/air_contents = A.return_air()
	var/list/result = atmosanalyzer_scan(A, air_contents)
	return result

/proc/atmosanalyzer_scan(obj/target, datum/gas_mixture/mixture, mob/user)
	. = list()
	. += span_notice("Results of the analysis of \the [target]:")
	if(!mixture)
		mixture = target.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles

		if (total_moles>0)
			. += span_notice("Pressure: [round(pressure, 0.1)] kPa")
			for(var/mix in mixture.gas)
				. += span_notice("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%")
			. += span_notice("Temperature: [round(mixture.temperature-T0C)]&deg;C")
			return
	. += span_notice("\The [target] is empty!")

/obj/proc/atmosanalyze(mob/user)
	return

/obj/item/tank/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/power/rad_collector/atmosanalyze(mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/flamethrower/atmosanalyze(mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
