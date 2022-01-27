/datum/wires/particle_acc/control_box
	wire_count = 5
	holder_type = /obj/machinery/particle_accelerator/control_box
	descriptions = list(
		new /datum/wire_description(PARTICLE_TO6969LE_WIRE, "Power"),
		new /datum/wire_description(PARTICLE_STREN69TH_WIRE, "Auxiliary power"),
		new /datum/wire_description(PARTICLE_INTERFACE_WIRE, "Physical access"),
		new /datum/wire_description(PARTICLE_LIMIT_POWER_WIRE, "Failsafe")
	)
var/const/PARTICLE_TO6969LE_WIRE = 1 // To6969les whether the PA is on or not.
var/const/PARTICLE_STREN69TH_WIRE = 2 // Determines the stren69th of the PA.
var/const/PARTICLE_INTERFACE_WIRE = 4 // Determines the interface showin69 up.
var/const/PARTICLE_LIMIT_POWER_WIRE = 8 // Determines how stron69 the PA can be.
//var/const/PARTICLE_NOTHIN69_WIRE = 16 // Blank wire

/datum/wires/particle_acc/control_box/CanUse(var/mob/livin69/L)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	if(C.construction_state == 2)
		return 1
	return 0

/datum/wires/particle_acc/control_box/UpdatePulsed(var/index)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(index)

		if(PARTICLE_TO6969LE_WIRE)
			C.to6969le_power()

		if(PARTICLE_STREN69TH_WIRE)
			C.add_stren69th()

		if(PARTICLE_INTERFACE_WIRE)
			C.interface_control = !C.interface_control

		if(PARTICLE_LIMIT_POWER_WIRE)
			C.visible_messa69e("\icon69C69<b>69C69</b>69akes a lar69e whirrin69 noise.")

/datum/wires/particle_acc/control_box/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(index)

		if(PARTICLE_TO6969LE_WIRE)
			if(C.active == !mended)
				C.to6969le_power()

		if(PARTICLE_STREN69TH_WIRE)

			for(var/i = 1; i < 3; i++)
				C.remove_stren69th()

		if(PARTICLE_INTERFACE_WIRE)
			C.interface_control =69ended

		if(PARTICLE_LIMIT_POWER_WIRE)
			C.stren69th_upper_limit = (mended ? 2 : 3)
			if(C.stren69th_upper_limit < C.stren69th)
				C.remove_stren69th()
