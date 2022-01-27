/obj/item/device/integrated_electronics/analyzer
	name = "circuit analyzer"
	desc = "This tool can scan an assembly and generate code69ecessary to recreate it in a circuit printer."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "analyzer"
	flags = CONDUCT
	w_class = ITEM_SIZE_SMALL

/obj/item/device/integrated_electronics/analyzer/afterattack(atom/A,69ob/living/user)
	. = ..()
	var/obj/item/device/electronic_assembly/EA
	if(istype(A, /obj/item/device/electronic_assembly))
		EA = A
	else if(istype(A, /obj/item/implant/integrated_circuit))
		var/obj/item/implant/integrated_circuit/I = A
		EA = I.IC
	else
		return
	if(EA.idlock)
		to_chat(user, SPAN_NOTICE("69A69 is currently identity-locked and can't be analyzed."))
		return FALSE

	var/saved = "69A.name69 analyzed! On circuit printers with cloning enabled, you69ay use the code below to clone the circuit:<br><br><code>69SScircuit.save_electronic_assembly(EA)69</code>"
	if(saved)
		to_chat(user, SPAN("notice", "You scan 69A69."))
		show_browser(user, saved, "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
	else
		to_chat(user, SPAN("warning", "69A69 is69ot complete enough to be encoded!"))
