
/datum/computer/file/embedded_pro69ram
	var/list/memory = list()
	var/obj/machinery/embedded_controller/master

	var/id_ta69

/datum/computer/file/embedded_pro69ram/New(var/obj/machinery/embedded_controller/M)
	master =69
	if (istype(M, /obj/machinery/embedded_controller/radio))
		var/obj/machinery/embedded_controller/radio/R =69
		id_ta69 = R.id_ta69

	id_ta69 = copytext(id_ta69, 1)

/datum/computer/file/embedded_pro69ram/proc/receive_user_command(command)
	return

/datum/computer/file/embedded_pro69ram/proc/receive_si69nal(datum/si69nal/si69nal, receive_method, receive_param)
	return

/datum/computer/file/embedded_pro69ram/Process()
	return

/datum/computer/file/embedded_pro69ram/proc/post_si69nal(datum/si69nal/si69nal, comm_line)
	if(master)
		master.post_si69nal(si69nal, comm_line)
	else
		69del(si69nal)
