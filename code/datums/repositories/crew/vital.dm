/* Vital */
/crew_sensor_modifier/vital/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	crew_data["true_pulse"] = -1
	crew_data["pulse"] = "N/A"
	crew_data["pulse_span"] = "neutral"

	if(!H.isSynthetic() && H.should_have_process(OP_HEART))
		var/obj/item/organ/internal/heart/O = H.random_organ_by_process(OP_HEART)
		if (!O || !BP_IS_ROBOTIC(O)) // Don't make medical freak out over prosthetic hearts
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
		else if(BP_IS_ROBOTIC(O))
			crew_data["pulse_span"] = "highlight"
			crew_data["pulse"] = "synthetic"
	else
		crew_data["pulse_span"] = "highlight"
		crew_data["pulse"] = "synthetic"

	crew_data["pressure"] = "N/A"
	crew_data["true_oxygenation"] = -1
	crew_data["oxygenation"] = ""
	crew_data["oxygenation_span"] = ""
	if(!H.isSynthetic() && H.should_have_process(OP_HEART))
		crew_data["pressure"] = H.get_blood_pressure()
		crew_data["true_oxygenation"] = H.getOxyLoss()
		switch (crew_data["true_oxygenation"])
			if(40 to INFINITY)
				crew_data["alert"] = TRUE
				crew_data["oxygenation"] = "extremely low"
				crew_data["oxygenation_span"] = "bad"
			if(20 to 40)
				crew_data["alert"] = TRUE
				crew_data["oxygenation"] = "very low"
				crew_data["oxygenation_span"] = "bad"
			if(10 to 20)
				crew_data["oxygenation"] = "low"
				crew_data["oxygenation_span"] = "average"
			if(0 to 10)
				crew_data["oxygenation"] = "normal"
				crew_data["oxygenation_span"] = "good"

	crew_data["bodytemp"] = H.bodytemperature - T0C
	return ..()

/crew_sensor_modifier/vital/proc/set_healthy(var/list/crew_data)
	crew_data["alert"] = FALSE
	if(crew_data["true_pulse"] != -1)
		crew_data["true_pulse"] = PULSE_NORM
		crew_data["pulse"] = rand(60, 90)
		crew_data["pulse_span"] = "good"

	if(crew_data["true_oxygenation"] != -1)
		crew_data["pressure"] = "[FLOOR(120+rand(-5,5), 1)]/[FLOOR(80+rand(-5,5), 1)]"
		crew_data["true_oxygenation"] = 100
		crew_data["oxygenation"] = "normal"
		crew_data["oxygenation_span"] = "good"

/crew_sensor_modifier/vital/proc/set_dead(var/list/crew_data)
	crew_data["alert"] = TRUE
	if(crew_data["true_pulse"] != -1)
		crew_data["true_pulse"] = PULSE_NONE
		crew_data["pulse"] = 0
		crew_data["pulse_span"] = "bad"

	if(crew_data["true_oxygenation"] != -1)
		crew_data["pressure"] = "[FLOOR((120+rand(-5,5))*0.25, 1)]/[FLOOR((80+rand(-5,5))*0.25, 1)]"
		crew_data["true_oxygenation"] = 25
		crew_data["oxygenation"] = "extremely low"
		crew_data["oxygenation_span"] = "bad"

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
