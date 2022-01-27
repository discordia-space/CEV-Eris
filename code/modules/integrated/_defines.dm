var/list/all_integrated_circuits = list()

/proc/initialize_integrated_circuits_list()
	for(var/thing in subtypesof(/obj/item/integrated_circuit))
		all_integrated_circuits +=69ew thing()

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "A tiny chip!  This one doesn't seem to do69uch, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = ITEM_SIZE_TINY
	var/obj/item/device/electronic_assembly/assembly =69ull // Reference to the assembly holding this circuit, if any.
	var/extended_desc =69ull
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/next_use = 0 //Uses world.time
	var/complexity = 1 				//This acts as a limitation on building69achines,69ore resource-intensive components cost69ore 'space'.
	var/cooldown_per_use = 1 SECONDS // Circuits are limited in how69any times they can be work()'d by this69ariable.
	var/power_draw_per_use = 0 		// How69uch power is drawn when work()'d.
	var/power_draw_idle = 0			// How69uch power is drawn when doing69othing.
	var/spawn_flags =69ull			// Used for world initializing, see the #defines above.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/autopulse = -1 				// When input is received, the circuit will pulse itself if set to 1.  069eans it won't. -169eans it is permanently off.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.
