/*69ital */
/crew_sensor_modifier/vital/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	crew_data69"true_pulse"69 = -1
	crew_data69"pulse"69 = "N/A"
	crew_data69"pulse_span"69 = "neutral"

	if(!H.isSynthetic() && H.should_have_process(OP_HEART))
		var/obj/item/organ/internal/heart/O = H.random_organ_by_process(OP_HEART)
		if(O && BP_IS_ORGANIC(O)) // Don't69ake69edical freak out over prosthetic hearts
			crew_data69"true_pulse"69 = H.pulse()
			crew_data69"pulse"69 = H.get_pulse(1)
			switch(crew_data69"true_pulse"69)
				if(PULSE_NONE)
					crew_data69"alert"69 = TRUE
					crew_data69"pulse_span"69 = "bad"
				if(PULSE_SLOW)
					crew_data69"pulse_span"69 = "average"
				if(PULSE_NORM)
					crew_data69"pulse_span"69 = "good"
				if(PULSE_FAST)
					crew_data69"pulse_span"69 = "highlight"
				if(PULSE_2FAST)
					crew_data69"pulse_span"69 = "average"
				if(PULSE_THREADY)
					crew_data69"alert"69 = TRUE
					crew_data69"pulse_span"69 = "bad"
	else
		crew_data69"pulse_span"69 = "highlight"
		crew_data69"pulse"69 = "synthetic"

	if(!H.isSynthetic() && H.should_have_process(OP_HEART))
//		crew_data69"pressure"69 = H.get_blood_pressure()
		crew_data69"suffocation"69 = round(H.getOxyLoss())
		crew_data69"burns"69 = round(H.getFireLoss())
		crew_data69"trauma"69 = round(H.getBruteLoss())
		crew_data69"poisoning"69 = round(H.getToxLoss())

		if(H.getOxyLoss() >= 10)
			crew_data69"alert"69 = TRUE
		if(H.getBruteLoss() >= 50)
			crew_data69"alert"69 = TRUE
		if(H.getFireLoss() >= 50)
			crew_data69"alert"69 = TRUE
		if(H.getToxLoss() >= 50)
			crew_data69"alert"69 = TRUE

	crew_data69"bodytemp"69 = H.bodytemperature - T0C
	return ..()

/crew_sensor_modifier/vital/proc/set_healthy(var/list/crew_data)
	crew_data69"alert"69 = FALSE
	if(crew_data69"true_pulse"69 != -1)
		crew_data69"true_pulse"69 = PULSE_NORM
		crew_data69"pulse"69 = rand(60, 90)
		crew_data69"pulse_span"69 = "good"

	crew_data69"suffocation"69 = 0
	crew_data69"burns"69 = 0
	crew_data69"trauma"69 = 0
	crew_data69"poisoning"69 = 0

/crew_sensor_modifier/vital/proc/set_dead(var/list/crew_data)
	crew_data69"alert"69 = TRUE
	if(crew_data69"true_pulse"69 != -1)
		crew_data69"true_pulse"69 = PULSE_NONE
		crew_data69"pulse"69 = 0
		crew_data69"pulse_span"69 = "bad"

	crew_data69"suffocation"69 = rand(10, 300)
	crew_data69"burns"69 = rand(10, 300)
	crew_data69"trauma"69 = rand(10, 300)
	crew_data69"poisoning"69 = rand(10, 300)

/* Jamming */
/crew_sensor_modifier/vital/jamming
	priority = 5

/crew_sensor_modifier/vital/jamming/healthy/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	set_healthy(crew_data)
	return69OD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/vital/jamming/dead/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	set_dead(crew_data)
	return69OD_SUIT_SENSORS_HANDLED

/* Random */
/crew_sensor_modifier/vital/jamming/random
	var/error_prob = 25

/crew_sensor_modifier/vital/jamming/random/moderate
	error_prob = 50

/crew_sensor_modifier/vital/jamming/random/major
	error_prob = 100

/crew_sensor_modifier/vital/jamming/random/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	if(prob(error_prob))
		pick(set_healthy(crew_data), set_dead(crew_data))
