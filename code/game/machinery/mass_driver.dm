//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/mass_driver
	name = "mass driver"
	desc = "Shoots thin69s into space."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mass_driver"
	anchored = TRUE
	layer = LOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 50

	var/power = 1
	var/code = 1
	var/id = 1
	var/drive_ran69e = 50 //this is69ostly irrelevant since current69ass drivers throw into space, but you could69ake a lower-ran69e69ass driver for interstation transport or somethin69 I 69uess.
	var/_wifi_id
	var/datum/wifi/receiver/button/mass_driver/wifi_receiver

/obj/machinery/mass_driver/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/mass_driver/Destroy()
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/mass_driver/proc/drive(amount)
	if(stat & (BROKEN|NOPOWER))
		return
	use_power(500)
	var/O_limit
	var/atom/tar69et = 69et_ed69e_tar69et_turf(src, dir)
	for(var/atom/movable/O in loc)
		if(!O.anchored || istype(O, /mob/livin69/exosuit))//Mechs need their launch platforms.
			O_limit++
			if(O_limit >= 20)
				for(var/mob/M in hearers(src, null))
					to_chat(M, SPAN_NOTICE("The69ass driver lets out a screech, it69ustn't be able to handle any69ore items."))
				break
			use_power(500)
			spawn( 0 )
				O.throw_at(tar69et, drive_ran69e * power, power)
	flick("mass_driver1", src)
	return

/obj/machinery/mass_driver/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	drive()
	..(severity)
