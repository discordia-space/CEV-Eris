/* Vital */
/crew_sensor_modifier/vital/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["true_pulse"] = -1
	crew_data["pulse"] = "N/A"
	crew_data["pulse_span"] = "neutral"

	if(!H.isSynthetic() && H.should_have_process(OP_HEART))
		var/obj/item/organ/internal/vital/heart/O = H.random_organ_by_process(OP_HEART)
		if(O && BP_IS_ORGANIC(O)) // Don't make medical freak out over prosthetic hearts
			crew_data["true_pulse"] = H.pulse()
			crew_data["pulse"] = H.get_pulse(1)
			switch(crew_data["true_pulse"])
				if(PULSE_NONE)
					crew_data["alert"] = TRUE
					crew_data["pulse_span"] = "bad"
				if(PULSE_SLOW)
					crew_data["pulse_span"] = "average"
				if(PULSE_NORM)
					crew_data["pulse_span"] = "good"
				if(PULSE_FAST)
					crew_data["pulse_span"] = "highlight"
				if(PULSE_2FAST)
					crew_data["pulse_span"] = "average"
				if(PULSE_THREADY)
					crew_data["alert"] = TRUE
					crew_data["pulse_span"] = "bad"
	else
		crew_data["pulse_span"] = "highlight"
		crew_data["pulse"] = "synthetic"

	if(!H.isSynthetic() && H.should_have_process(OP_HEART))
//		crew_data["pressure"] = H.get_blood_pressure()
		crew_data["suffocation"] = round(H.getOxyLoss())
		crew_data["burns"] = round(H.getFireLoss())
		crew_data["trauma"] = round(H.getBruteLoss())
		crew_data["poisoning"] = round(H.getToxLoss())

		if(H.getOxyLoss() >= 10)
			crew_data["alert"] = TRUE
		if(H.getBruteLoss() >= 50)
			crew_data["alert"] = TRUE
		if(H.getFireLoss() >= 50)
			crew_data["alert"] = TRUE
		if(H.getToxLoss() >= 50)
			crew_data["alert"] = TRUE

	crew_data["bodytemp"] = H.bodytemperature - T0C
	return ..()

/crew_sensor_modifier/vital/proc/set_healthy(var/list/crew_data)
	crew_data["alert"] = FALSE
	if(crew_data["true_pulse"] != -1)
		crew_data["true_pulse"] = PULSE_NORM
		crew_data["pulse"] = rand(60, 90)
		crew_data["pulse_span"] = "good"

	crew_data["suffocation"] = 0
	crew_data["burns"] = 0
	crew_data["trauma"] = 0
	crew_data["poisoning"] = 0

/crew_sensor_modifier/vital/proc/set_dead(var/list/crew_data)
	crew_data["alert"] = TRUE
	if(crew_data["true_pulse"] != -1)
		crew_data["true_pulse"] = PULSE_NONE
		crew_data["pulse"] = 0
		crew_data["pulse_span"] = "bad"

	crew_data["suffocation"] = rand(10, 300)
	crew_data["burns"] = rand(10, 300)
	crew_data["trauma"] = rand(10, 300)
	crew_data["poisoning"] = rand(10, 300)

/* Jamming */
/crew_sensor_modifier/vital/jamming
	priority = 5

/crew_sensor_modifier/vital/jamming/healthy/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	set_healthy(crew_data)
	return MOD_SUIT_SENSORS_HANDLED

/crew_sensor_modifier/vital/jamming/dead/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	set_dead(crew_data)
	return MOD_SUIT_SENSORS_HANDLED

/* Random */
/crew_sensor_modifier/vital/jamming/random
	var/error_prob = 25

/crew_sensor_modifier/vital/jamming/random/moderate
	error_prob = 50

/crew_sensor_modifier/vital/jamming/random/major
	error_prob = 100

/crew_sensor_modifier/vital/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	. = ..()
	if(prob(error_prob))
		pick(set_healthy(crew_data), set_dead(crew_data))
