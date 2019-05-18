// Sell tech levels
/datum/export/tech
	cost = 500
	unit_name = "technology data"
	export_types = list(/obj/item/weapon/computer_hardware/hard_drive)
	var/list/techLevels = list()

/datum/export/tech/get_cost(obj/O)
	var/obj/item/weapon/computer_hardware/hard_drive/D = O
	var/cost = 0

	for(var/f in D.find_files_by_type(/datum/computer_file/binary/tech))
		var/datum/computer_file/binary/tech/T = f
		cost += T.tech.getCost(techLevels[T.tech.id])

	return ..() * cost

/datum/export/tech/sell_object(obj/O)
	..()
	var/obj/item/weapon/computer_hardware/hard_drive/D = O

	for(var/f in D.find_files_by_type(/datum/computer_file/binary/tech))
		var/datum/computer_file/binary/tech/T = f
		techLevels[T.tech.id] = T.tech.level
