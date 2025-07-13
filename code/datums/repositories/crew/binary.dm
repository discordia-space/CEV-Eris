/* Binary */
/datum/crew_sensor_modifier/binary/process_crew_data(mob/living/carbon/human/H, obj/item/clothing/under/C, turf/pos, list/crew_data)
	crew_data["alert"] = FALSE
	crew_data["muted"] = FALSE
	if(H.name in GLOB.ignore_health_alerts_from)
		crew_data["muted"] = TRUE
	if(!H.isSynthetic())
		var/obj/item/organ/internal/vital/heart/O = H.random_organ_by_process(OP_HEART)
		if(O && BP_IS_ORGANIC(O))
			var/pulse = H.pulse()
			if(pulse == PULSE_NONE || pulse == PULSE_THREADY)
				crew_data["alert"] = TRUE
		if(H.getOxyLoss() >= 20)
			crew_data["alert"] = TRUE
		if(H.getBruteLoss() >= 100)
			crew_data["alert"] = TRUE
		if(H.getFireLoss() >= 100)
			crew_data["alert"] = TRUE
		if(H.getToxLoss() >= 100)
			crew_data["alert"] = TRUE
	return ..()

/* Jamming */
/datum/crew_sensor_modifier/binary/jamming
	priority = 5

/datum/crew_sensor_modifier/binary/jamming/alive/process_crew_data(mob/living/carbon/human/H, obj/item/clothing/under/C, turf/pos, list/crew_data)
	crew_data["alert"] = FALSE
	return MOD_SUIT_SENSORS_HANDLED

/datum/crew_sensor_modifier/binary/jamming/dead/process_crew_data(mob/living/carbon/human/H, obj/item/clothing/under/C, turf/pos, list/crew_data)
	crew_data["alert"] = TRUE
	return MOD_SUIT_SENSORS_HANDLED

/* Random */
/datum/crew_sensor_modifier/binary/jamming/random
	var/error_prob = 25

/datum/crew_sensor_modifier/binary/jamming/random/moderate
	error_prob = 50

/datum/crew_sensor_modifier/binary/jamming/random/major
	error_prob = 100

/datum/crew_sensor_modifier/binary/jamming/random/process_crew_data(mob/living/carbon/human/H, obj/item/clothing/under/C, turf/pos, list/crew_data)
	. = ..()
	if(prob(error_prob))
		crew_data["alert"] = pick(TRUE, FALSE)
