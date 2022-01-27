/proc/analyze_69ases(var/obj/A,69ar/mob/user)
	var/air_contents = A.return_air()
	var/list/result = atmosanalyzer_scan(A, air_contents)
	return result

/proc/atmosanalyzer_scan(var/obj/tar69et,69ar/datum/69as_mixture/mixture,69ar/mob/user)
	. = list()
	. += SPAN_NOTICE("Results of the analysis of \the 69tar69et69:")
	if(!mixture)
		mixture = tar69et.return_air()

	if(mixture)
		var/pressure =69ixture.return_pressure()
		var/total_moles =69ixture.total_moles

		if (total_moles>0)
			. += SPAN_NOTICE("Pressure: 69round(pressure, 0.16969 kPa")
			for(var/mix in69ixture.69as)
				. += SPAN_NOTICE("6969as_data.name69m69696969: 69round((mixture.69as669mix69 / total_moles) * 6900)69%")
			. += SPAN_NOTICE("Temperature: 69round(mixture.temperature-T0C6969&de69;C")
			return
	. += SPAN_NOTICE("\The 69tar69e6969 is empty!")

/obj/proc/atmosanalyze(var/mob/user)
	return

/obj/item/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/power/rad_collector/atmosanalyze(var/mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/flamethrower/atmosanalyze(var/mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
