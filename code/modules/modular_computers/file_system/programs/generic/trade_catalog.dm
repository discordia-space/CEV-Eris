/datum/computer_file/program/trade/catalog
	filename = "trade_catalog"
	filedesc = "Trade Catalog and Order Requests"
	nanomodule_path = /datum/nano_module/program/trade/catalog
	extended_desc = "Electronic handbook containing inventory information about discovered trade beacons. Trade orders can be requested using this."
	size = 2
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL

	program_type = "ordering"	// master, slave, ordering

/datum/nano_module/program/trade/catalog
	name = "Trade Catalog and Order Requests"
