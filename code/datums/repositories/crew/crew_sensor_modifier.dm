/crew_sensor_modifier
	var/priority = 1
	var/atom/holder
	var/may_process_proc

/crew_sensor_modifier/New(var/atom/holder,69ar/may_process_proc)
	..()
	src.holder = holder
	src.may_process_proc =69ay_process_proc

/crew_sensor_modifier/Destroy()
	holder = null
	may_process_proc = null
	. = ..()

/crew_sensor_modifier/proc/may_process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos)
	return holder &&69ay_process_proc ? call(holder,69ay_process_proc)(H, C, pos) : TRUE

/crew_sensor_modifier/proc/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	return69OD_SUIT_SENSORS_HANDLED
