// Approved69anifest.
// +200 credits flat.
/datum/export/manifest_correct
	cost = 200
	unit_name = "approved69anifest"
	export_types = list(/obj/item/paper/manifest)

/datum/export/manifest_correct/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/manifest/M = O
	if(M.is_approved() && !M.errors)
		return TRUE
	return FALSE

// Correctly denied69anifest.
// Refunds the package cost69inus the cost of crate.
/datum/export/manifest_error_denied
	cost = -500
	unit_name = "correctly denied69anifest"
	export_types = list(/obj/item/paper/manifest)

/datum/export/manifest_error_denied/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/manifest/M = O
	if(M.is_denied() &&69.errors)
		return TRUE
	return FALSE

/datum/export/manifest_error_denied/get_cost(obj/O)
	var/obj/item/paper/manifest/M = O
	return ..() +69.order_cost


// Erroneously approved69anifest.
// Substracts the package cost.
/datum/export/manifest_error
	unit_name = "erroneously approved69anifest"
	export_types = list(/obj/item/paper/manifest)

/datum/export/manifest_error/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/manifest/M = O
	if(M.is_approved() &&69.errors)
		return TRUE
	return FALSE

/datum/export/manifest_error/get_cost(obj/O)
	var/obj/item/paper/manifest/M = O
	return -M.order_cost


// Erroneously denied69anifest.
// Substracts the package cost69inus the cost of crate.
/datum/export/manifest_correct_denied
	cost = 500
	unit_name = "erroneously denied69anifest"
	export_types = list(/obj/item/paper/manifest)

/datum/export/manifest_correct_denied/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/manifest/M = O
	if(M.is_denied() && !M.errors)
		return TRUE
	return FALSE

/datum/export/manifest_correct_denied/get_cost(obj/O)
	var/obj/item/paper/manifest/M = O
	return ..() -69.order_cost
