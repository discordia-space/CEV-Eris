/obj/item/computer_hardware/hard_drive/portable/advanced/setup
	rarity_value = 25
	bad_type = /obj/item/computer_hardware/hard_drive/portable/advanced/setup
	spawn_tags = SPAWN_TAG_PROGRAM
	max_capacity = 128
	price_tag = 35 // based on price of 25 with fee of 40% for programs

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/install_default_files()
	. = ..()
	read_only = TRUE // in exchange for doubled capacity, these disks have their files burned in.

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/engineering
	name = "engineering setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up an engineering console."
	default_files = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/shield
	name = "shielding setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a shield console."
	default_files = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shield_control
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/medical
	name = "medical setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a medical console."
	default_files = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/suit_sensors
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/research
	name = "research setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a research console."
	default_files = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/nttransfer,
		/datum/computer_file/program/camera_monitor
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/genetics
	name = "genetic setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a genetics console."
	default_files = list(/datum/computer_file/program/dna)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/sysadmin
	name = "sysadmins setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a sysadmins console."
	default_files = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/nttransfer,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/ntnetmonitor,
		/datum/computer_file/program/email_administration
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/command
	name = "command setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a command console."
	default_files = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/nttransfer,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/comm,
		/datum/computer_file/program/card_mod
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/security
	name = "security setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a security console."
	default_files = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/audio
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/civilian
	name = "civilian setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a civilian console."
	default_files = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/nttransfer,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/camera_monitor
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/professional
	name = "professional setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a professional console."
	default_files = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/nttransfer,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/library
	name = "libraric setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a library console."
	default_files = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/newsbrowser,
		/datum/computer_file/program/nttransfer,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/records,
		/datum/computer_file/program/library
	)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/trade
	name = "trade setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up a trade console."
	default_files = list(/datum/computer_file/program/trade)

/obj/item/computer_hardware/hard_drive/portable/advanced/setup/trade_orders
	name = "order setup disk"
	desc = "A removable disk used to store large amounts of data.\nThis one contains all the files necessary to set up an order console."
	default_files = list(/datum/computer_file/program/trade/order)

