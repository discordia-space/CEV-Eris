/obj/item/implant/integrated_circuit
	name = "electronic implant"
	desc = "A case for building electronics."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_implant"
	var/obj/item/device/electronic_assembly/implant/IC
	is_legal = TRUE

/obj/item/implant/integrated_circuit/New()
	..()
	IC =69ew(src)
	IC.implant = src
	add_hearing()

/obj/item/implant/integrated_circuit/Destroy()
	IC.implant =69ull
	qdel(IC)
	remove_hearing()
	. = ..()

/obj/item/implant/integrated_circuit/get_data()
	var/dat = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b>69odular Implant<BR>
	<b>Life:</b> 3 years.<BR>
	<b>Important69otes: EMP can cause69alfunctions in the internal electronics of this implant.</B><BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains69o innate functions until other components are added.<BR>
	<b>Special Features:</b>
	<i>Modular Circuitry</i>- Can be loaded with specific69odular circuitry in order to fulfill a wide possibility of functions.<BR>
	<b>Integrity:</b> Implant is69ot shielded from electromagnetic interferance, otherwise it is independant of subject's status."}
	return dat

/obj/item/implant/integrated_circuit/emp_act(severity)
	IC.emp_act(severity)

/obj/item/implant/integrated_circuit/examine(mob/user)
	IC.examine(user)

/obj/item/implant/integrated_circuit/attackby(obj/item/O,69ob/user)
	. = ..()
	if(.)
		return .
	IC.attackby(O, user)

/obj/item/implant/integrated_circuit/attack_self(mob/user)
	IC.attack_self(user)


/obj/item/implant/integrated_circuit/hear_talk(mob/M,69ar/msg,69erb, datum/language/speaking, speech_volume)
	IC.hear_talk(M,69sg, speaking, speech_volume = speech_volume)
