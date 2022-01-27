/* General */
/crew_sensor_modifier/general/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	crew_data69"name"69 = H.get_authentification_name(if_no_id="Unknown")
	crew_data69"rank"69 = H.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
	crew_data69"assignment"69 = H.get_assignment(if_no_id="Unknown", if_no_job="No Job")

	var/datum/computer_file/report/crew_record/CR = get_crewmember_record(crew_data69"name"69)		
	if(CR)
		if(CR.get_criminalStatus() == "*Arrest*" || CR.get_criminalStatus() == "Incarcerated")
			crew_data69"isCriminal"69 = TRUE
	return ..()

/* Jamming */
/crew_sensor_modifier/general/jamming
	priority = 5

/crew_sensor_modifier/general/jamming/off/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	// This works only because general is checked first and crew_data69"sensor_type"69 is used to check if whether any additional data should be included.
	crew_data69"sensor_type"69 = SUIT_SENSOR_OFF
	return69OD_SUIT_SENSORS_REJECTED

/crew_sensor_modifier/general/jamming/binary/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	crew_data69"sensor_type"69 = SUIT_SENSOR_BINARY

/crew_sensor_modifier/general/jamming/vital/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	crew_data69"sensor_type"69 = SUIT_SENSOR_VITAL

/crew_sensor_modifier/general/jamming/tracking/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	crew_data69"sensor_type"69 = SUIT_SENSOR_TRACKING

/* Random */
/crew_sensor_modifier/general/jamming/random
	var/random_sensor_type_prob = 15
	var/random_assignment_prob = 10

/crew_sensor_modifier/general/jamming/random/moderate
	random_sensor_type_prob = 30
	random_assignment_prob = 20

/crew_sensor_modifier/general/jamming/random/major
	random_sensor_type_prob = 60
	random_assignment_prob = 40

/crew_sensor_modifier/general/jamming/random/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	. = ..()
	if(prob(random_sensor_type_prob))
		crew_data69"sensor_type"69 = pick(SUIT_SENSOR_OFF, SUIT_SENSOR_BINARY, SUIT_SENSOR_VITAL, SUIT_SENSOR_TRACKING)
	if(prob(random_assignment_prob))
		crew_data69"assignment"69 = pick("Agent", "Infiltrator", "Passenger", "Crewman", "Unknown")
