/datum/trade_station/computers
	name_pool = list(
		"MTB \'Macro Rim\'" = "Moebius Trade Beacon \'Macro Rim\': Connection with the Moebius computer surplus network established."
	)
	icon_states = list("moe_frigate", "ship")
	uid = "med_comp"
	tree_x = 0.34
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("moe_adv")
	recommendations_needed = 0
	inventory = list(
		"Design Disks" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/computer = good_data("Moebius Computer Parts", list(1, 10), 500)
		),
		"Computer Frames" = list(
			/obj/item/modular_computer/pda,
			/obj/item/modular_computer/tablet,
			/obj/item/modular_computer/laptop
		),
		"Data Disks" = list(
			/obj/item/computer_hardware/hard_drive/portable/basic,
			/obj/item/computer_hardware/hard_drive/portable
		),
		"Hard Drives" = list(
			/obj/item/computer_hardware/hard_drive/micro,
			/obj/item/computer_hardware/hard_drive/small,
			/obj/item/computer_hardware/hard_drive,
			/obj/item/computer_hardware/hard_drive/advanced
		),
		"Network Cards" = list(
			/obj/item/computer_hardware/network_card,
			/obj/item/computer_hardware/network_card/advanced,
			/obj/item/computer_hardware/network_card/wired
		),
		"Processors" = list(
			/obj/item/computer_hardware/processor_unit,
			/obj/item/computer_hardware/processor_unit/small,
			/obj/item/computer_hardware/processor_unit/adv,
			/obj/item/computer_hardware/processor_unit/adv/small
		),
		"Hardware Modules" = list(
			/obj/item/computer_hardware/card_slot,
			/obj/item/computer_hardware/printer,
			/obj/item/computer_hardware/tesla_link,
			/obj/item/computer_hardware/led,
			/obj/item/computer_hardware/led/adv,
			/obj/item/computer_hardware/gps_sensor,
			/obj/item/computer_hardware/scanner/paper,
			/obj/item/computer_hardware/scanner/atmos,
			/obj/item/computer_hardware/scanner/reagent,
			/obj/item/computer_hardware/scanner/medical,
			/obj/item/computer_hardware/scanner/price
		)
	)
	offer_types = list(
		/obj/item/oddity/common/disk = offer_data("broken design disk", 500, 1),
		/obj/item/oddity/common/device = offer_data("odd device", 500, 1),
		/obj/item/oddity/common/old_pda = offer_data("broken pda", 500, 1),
		/obj/item/computer_hardware/hard_drive/portable/research_points = offer_data("research data disk", 1000, 2),
		/obj/item/computer_hardware/hard_drive/portable/advanced/shady = offer_data("design disk - 'warez'", 1200, 2),
		/obj/item/computer_hardware/hard_drive/portable/advanced/nuke = offer_data("design disk - 'nuke'", 1200, 2),
		/obj/item/stock_parts/capacitor/one_star = offer_data("one star capacitor", 1000, 3),
		/obj/item/stock_parts/scanning_module/one_star = offer_data("one star scanning module", 1000, 3),
		/obj/item/stock_parts/manipulator/one_star = offer_data("one star manipulator", 1000, 3),
		/obj/item/stock_parts/micro_laser/one_star = offer_data("one star micro-laser", 1000, 3),
		/obj/item/stock_parts/matter_bin/one_star = offer_data("one star matter bin", 1000, 3)
	)
