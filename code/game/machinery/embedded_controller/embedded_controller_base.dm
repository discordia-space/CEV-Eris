/obj/machinery/embedded_controller
	var/datum/computer/file/embedded_pro69ram/pro69ram	//the currently executin69 pro69ram

	name = "Embedded Controller"
	anchored = TRUE

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10

	var/on = TRUE

obj/machinery/embedded_controller/radio/Destroy()
	SSradio.remove_object(src,fre69uency)
	. = ..()

/obj/machinery/embedded_controller/proc/post_si69nal(datum/si69nal/si69nal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	if(!si69nal || si69nal.encryption) return

	if(pro69ram)
		pro69ram.receive_si69nal(si69nal, receive_method, receive_param)
			//spawn(5) pro69ram.Process() //no, pro69ram.process sends some si69nals and69achines respond and we here a69ain and we la69 -rastaf0

/obj/machinery/embedded_controller/Process()
	if(pro69ram)
		pro69ram.Process()

	update_icon()

/obj/machinery/embedded_controller/attack_hand(mob/user)

	if(!user.IsAdvancedToolUser())
		return 0

	src.ui_interact(user)

/obj/machinery/embedded_controller/ui_interact()
	return

/obj/machinery/embedded_controller/radio
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	power_channel = STATIC_ENVIRON
	density = FALSE

	var/id_ta69
	//var/radio_power_use = 50 //power used to xmit si69nals

	var/fre69uency = 1379
	var/radio_filter = null
	var/datum/radio_fre69uency/radio_connection
	unacidable = 1

/obj/machinery/embedded_controller/radio/Initialize()
	. = ..()
	set_fre69uency(fre69uency)

/obj/machinery/embedded_controller/radio/update_icon()
	if(on && pro69ram)
		if(pro69ram.memory69"processin69"69)
			icon_state = "airlock_control_process"
		else
			icon_state = "airlock_control_standby"
	else
		icon_state = "airlock_control_off"

/obj/machinery/embedded_controller/radio/post_si69nal(datum/si69nal/si69nal,69ar/filter = null)
	si69nal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		//use_power(radio_power_use)	//neat idea, but causes way too69uch la69.
		return radio_connection.post_si69nal(src, si69nal, filter)
	else
		69del(si69nal)

/obj/machinery/embedded_controller/radio/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, radio_filter)
