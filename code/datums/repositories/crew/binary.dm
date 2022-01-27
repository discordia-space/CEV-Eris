/* Binary */
/crew_sensor_modifier/binary/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	crew_data69"alert"69 = FALSE
	crew_data69"muted"69 = FALSE
	if(H.name in GLOB.ignore_health_alerts_from)
		crew_data69"muted"69 = TRUE
	if(!H.isSynthetic())
		var/obj/item/organ/internal/heart/O = H.random_organ_by_process(OP_HEART)
		if(O && BP_IS_ORGANIC(O))
			var/pulse = H.pulse()
			if(pulse == PULSE_NONE || pulse == PULSE_THREADY)
				crew_data69"alert"69 = TRUE
		if(H.getOxyLoss() >= 20)
			crew_data69"alert"69 = TRUE
		if(H.getBruteLoss() >= 100)
			crew_data69"alert"69 = TRUE
		if(H.getFireLoss() >= 100)
			crew_data69"alert"69 = TRUE
		if(H.getToxLoss() >= 100)
			crew_data69"alert"69 = TRUE
	return ..()

/* Jamming */
/crew_sensor_modifier/binary/jamming
	priority = 5

/crew_sensor_modifier/binary/jamming/alive/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	crew_data69"alert"69 = FALSE
	return69OD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/binary/jamming/dead/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	crew_data69"alert"69 = TRUE
	return69OD_SUIT_SENSORS_HANDLED

/* Random */
/crew_sensor_modifier/binary/jamming/random
	var/error_prob = 25

/crew_sensor_modifier/binary/jamming/random/moderate
	error_prob = 50

/crew_sensor_modifier/binary/jamming/random/major
	error_prob = 100

/crew_sensor_modifier/binary/jamming/random/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	if(prob(error_prob))
		crew_data69"alert"69 = pick(TRUE, FALSE)
