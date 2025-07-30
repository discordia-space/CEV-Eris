///List of all vars that will not be copied over when using duplicate_object()
GLOBAL_LIST_INIT(duplicate_forbidden_vars, list(
	"tag",
	"_datum_components",
	"area",
	"type",
	"loc",
	"locs",
	"vars",
	"parent",
	"parent_type",
	"verbs",
	"ckey",
	"key",
	"contents",
	"reagents",
	"stat",
	"x",
	"y",
	"z",
	"_listen_lookup",
	"bodyparts",
	"internal_organs",
	"hand_bodyparts",
	"overlays_standing",
	"hud_list",
	"computer_id",
	"lastKnownIP",
	"WIRE_RECEIVE",
	"WIRE_PULSE",
	"WIRE_PULSE_SPECIAL",
	"WIRE_RADIO_RECEIVE",
	"WIRE_RADIO_PULSE",
	"FREQ_LISTENING",
	"deffont",
	"signfont",
	"crayonfont",
	"hud_actions",
	"hidden_uplink",
	"gc_destroyed",
	"is_processing",
	"signal_procs",
	"signal_enabled"
))
GLOBAL_PROTECT(duplicate_forbidden_vars)


/**
 * # duplicate_object
 *
 * Makes a copy of an item and transfers most vars over, barring GLOB.duplicate_forbidden_vars
 * Args:
 * original - Atom being duplicated
 * spawning_location - Turf where the duplicated atom will be spawned at.
 */
/proc/duplicate_object(atom/original, turf/spawning_location)
	RETURN_TYPE(original.type)
	if(!original)
		return

	var/atom/made_copy = new original.type(spawning_location)

	for(var/atom_vars in original.vars - GLOB.duplicate_forbidden_vars)
		if(islist(original.vars[atom_vars]))
			var/list/var_list = original.vars[atom_vars]
			made_copy.vars[atom_vars] = var_list.Copy()
			continue
		else if(istype(original.vars[atom_vars], /datum) || ismob(original.vars[atom_vars]))
			continue // this would reference the original's object, that will break when it is used or deleted.
		made_copy.vars[atom_vars] = original.vars[atom_vars]

	return made_copy



/proc/DuplicateObject_old(atom/original, perfectcopy = TRUE, sameloc, atom/newloc)
	RETURN_TYPE(original.type)
	if(!original)
		return

	var/atom/O

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(newloc)

	if(perfectcopy && O && original)
		var/list/all_vars = duplicate_vars(original)
		for(var/V in all_vars)
			O.vars[V] = all_vars[V]
	return O


/proc/duplicate_vars(atom/original)
	RETURN_TYPE(/list)
	var/list/all_vars = list()
	for(var/V in original.vars - GLOB.duplicate_forbidden_vars)
		if(islist(original.vars[V]))
			var/list/L = original.vars[V]
			all_vars[V] = L.Copy()
		else if(istype(original.vars[V], /datum) || ismob(original.vars[V]) || isHUDobj(original.vars[V]) || isobj(original.vars[V]))
			continue	// this would reference the original's object, that will break when it is used or deleted.
		else
			all_vars[V] = original.vars[V]
	return all_vars
