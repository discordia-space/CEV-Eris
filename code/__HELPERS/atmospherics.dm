/obj/proc/analyze_gases(var/obj/A, var/mob/user)
	if(src != A)
		user.visible_message(SPAN_NOTICE("\The [user] has used \an [src] on \the [A]"))
	A.add_fingerprint(user)

	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, SPAN_WARNING("Your [src] flashes a red light as it fails to analyze \the [A]."))
		return 0

	var/list/result = atmosanalyzer_scan(A, air_contents)
	print_atmos_analysis(user, result)
	return 1

/proc/print_atmos_analysis(user, var/list/result)
	for(var/line in result)
		to_chat(user, SPAN_NOTICE("[line]"))

/proc/atmosanalyzer_scan(var/obj/target, var/datum/gas_mixture/mixture, var/mob/user)
	. = list()
	. += SPAN_NOTICE("Results of the analysis of \the [target]:")
	if(!mixture)
		mixture = target.return_air()

	if(mixture)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles

		if (total_moles>0)
			. += SPAN_NOTICE("Pressure: [round(pressure, 0.1)] kPa")
			for(var/mix in mixture.gas)
				. += SPAN_NOTICE("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]%")
			. += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C)]&deg;C")
			return
	. += SPAN_NOTICE("\The [target] is empty!")

/obj/proc/atmosanalyze(var/mob/user)
	return

/obj/item/weapon/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.parent.air, user)

/obj/machinery/power/rad_collector/atmosanalyze(var/mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/weapon/flamethrower/atmosanalyze(var/mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
