var/list/all_integrated_circuits = list()

/proc/initialize_integrated_circuits_list()
	for(var/thing in subtypesof(/obj/item/integrated_circuit))
		all_integrated_circuits += new thing()

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = ITEM_SIZE_TINY
	var/obj/item/device/electronic_assembly/assembly = null // Reference to the assembly holding this circuit, if any.
	var/extended_desc = null
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/next_use = 0 //Uses world.time
	var/complexity = 1 				//This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/cooldown_per_use = 1 SECONDS // Circuits are limited in how many times they can be work()'d by this variable.
	var/power_draw_per_use = 0 		// How much power is drawn when work()'d.
	var/power_draw_idle = 0			// How much power is drawn when doing nothing.
	var/spawn_flags = null			// Used for world initializing, see the #defines above.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/autopulse = -1 				// When input is received, the circuit will pulse itself if set to 1.  0 means it won't. -1 means it is permanently off.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.
