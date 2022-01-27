/datum/wires/nuclearbomb
	holder_type = /obj/machinery/nuclearbomb
	wire_count = 7
	descriptions = list(
		new /datum/wire_description(NUCLEARBOMB_WIRE_LIGHT, "Light"),
		new /datum/wire_description(NUCLEARBOMB_WIRE_TIMING, "Timer"),
		new /datum/wire_description(NUCLEARBOMB_WIRE_SAFETY, "Safety")
	)

var/const/NUCLEARBOMB_WIRE_LIGHT		= 1
var/const/NUCLEARBOMB_WIRE_TIMING		= 2
var/const/NUCLEARBOMB_WIRE_SAFETY		= 4

/datum/wires/nuclearbomb/CanUse(var/mob/living/L)
	var/obj/machinery/nuclearbomb/N = holder
	return N.panel_open

/datum/wires/nuclearbomb/GetInteractWindow(mob/living/user)
	var/obj/machinery/nuclearbomb/N = holder
	. += ..(user)
	. += "<BR>The device is 69N.timing ? "shaking!" : "still."69<BR>"
	. += "The device is is 69N.safety ? "quiet" : "whirring"69.<BR>"
	. += "The lights are 69N.lighthack ? "static" : "functional"69.<BR>"

/datum/wires/nuclearbomb/UpdatePulsed(var/index)
	var/obj/machinery/nuclearbomb/N = holder
	switch(index)
		if(NUCLEARBOMB_WIRE_LIGHT)
			N.lighthack = !N.lighthack
			N.update_icon()
			spawn(100)
				N.lighthack = !N.lighthack
				N.update_icon()
		if(NUCLEARBOMB_WIRE_TIMING)
			if(N.timing)
				spawn
					log_and_message_admins("pulsed a nuclear bomb's detonation wire, causing it to explode.")
					N.explode()
		if(NUCLEARBOMB_WIRE_SAFETY)
			N.safety = !N.safety
			spawn(100)
				N.safety = !N.safety
				if(N.safety == 1)
					N.visible_message(SPAN_NOTICE("\The 69N69 quiets down."))
					N.secure_device()
				else
					N.visible_message(SPAN_NOTICE("\The 69N69 emits a quiet whirling noise!"))

/datum/wires/nuclearbomb/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/nuclearbomb/N = holder
	switch(index)
		if(NUCLEARBOMB_WIRE_SAFETY)
			N.safety =69ended
			if(N.timing)
				spawn
					log_and_message_admins("cut a nuclear bomb's timing wire, causing it to explode.")
					N.explode()
		if(NUCLEARBOMB_WIRE_TIMING)
			N.secure_device()
		if(NUCLEARBOMB_WIRE_LIGHT)
			N.lighthack = !mended
			N.update_icon()
