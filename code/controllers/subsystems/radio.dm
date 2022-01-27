SUBSYSTEM_DEF(radio)
	name = "Radio"
	flags = SS_NO_FIRE|SS_NO_INIT

	var/list/datum/radio_frequency/frequencies = list()

/datum/controller/subsystem/radio/proc/add_object(obj/device, new_frequency as num, filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies69f_text69

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies69f_text69 = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/subsystem/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies69f_text69

	if(frequency)
		frequency.remove_listener(device)

		if(frequency.devices.len == 0)
			qdel(frequency)
			frequencies -= f_text

	return TRUE

/datum/controller/subsystem/radio/proc/return_frequency(new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies69f_text69

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies69f_text69 = frequency

	return frequency
