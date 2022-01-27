/obj/item/modular_computer/console/preset
	bad_type = /obj/item/modular_computer/console/preset

/obj/item/modular_computer/console/preset/install_default_hardware()
	..()
	processor_unit =69ew/obj/item/computer_hardware/processor_unit(src)
	tesla_link =69ew/obj/item/computer_hardware/tesla_link(src)
	hard_drive =69ew/obj/item/computer_hardware/hard_drive/advanced(src)
	network_card =69ew/obj/item/computer_hardware/network_card/wired(src)
	scanner =69ew /obj/item/computer_hardware/scanner/paper(src)

// Engineering
/obj/item/modular_computer/console/preset/engineering/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/power_monitor())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/atmos_control())
	hard_drive.store_file(new/datum/computer_file/program/rcon_console())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())

// Engineering alarm69onitor
/obj/item/modular_computer/console/preset/engineering/alarms/install_default_programs()
	..()
	set_autorun("alarmmonitor")

// Engineering supermatter69onitor
/obj/item/modular_computer/console/preset/engineering/supermatter/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/supermatter_monitor())
	set_autorun("supmon")

// Engineering RCON control
/obj/item/modular_computer/console/preset/engineering/rcon/install_default_programs()
	..()
	set_autorun("rconconsole")

// Engineering shield control
/obj/item/modular_computer/console/preset/engineering/shield/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/shield_control())
	set_autorun("shieldcontrol")

// Engineering power69onitor
/obj/item/modular_computer/console/preset/engineering/power/install_default_programs()
	..()
	set_autorun("powermonitor")

// Engineering atmos control
/obj/item/modular_computer/console/preset/engineering/atmos/install_default_programs()
	..()
	set_autorun("atmoscontrol")

//69edical
/obj/item/modular_computer/console/preset/medical/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)

/obj/item/modular_computer/console/preset/medical/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors())

//69edical records
/obj/item/modular_computer/console/preset/medical/records/install_default_programs()
	..()
	set_autorun("crewrecords")

//69edical crew69onitor
/obj/item/modular_computer/console/preset/medical/monitor/install_default_programs()
	..()
	set_autorun("sensormonitor")

// Research
/obj/item/modular_computer/console/preset/research/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)

/obj/item/modular_computer/console/preset/research/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())


// TODO: enable after baymed AI
// Research robotics (placeholder for future)
/*
/obj/item/modular_computer/console/preset/research/silicon/install_default_hardware()
	..()
	ai_slot =69ew/obj/item/computer_hardware/ai_slot(src)

/obj/item/modular_computer/console/preset/research/silicon/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/aidiag())
*/
// Research administrator
/obj/item/modular_computer/console/preset/research/sysadmin/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/ntnetmonitor())
	hard_drive.store_file(new/datum/computer_file/program/email_administration())

// Command
/obj/item/modular_computer/console/preset/command/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)
	card_slot =69ew/obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/command/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/reports())
	hard_drive.store_file(new/datum/computer_file/program/comm())
	hard_drive.store_file(new/datum/computer_file/program/card_mod())

//First Officer
/obj/item/modular_computer/console/preset/command/access/install_default_programs()
	..()
	set_autorun("cardmod")

// Security
/obj/item/modular_computer/console/preset/security/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)

/obj/item/modular_computer/console/preset/security/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/digitalwarrant())
	hard_drive.store_file(new/datum/computer_file/program/audio())


// Security cameras
/obj/item/modular_computer/console/preset/security/camera/install_default_programs()
	..()
	set_autorun("cammon")

// Security records
/obj/item/modular_computer/console/preset/security/records/install_default_programs()
	..()
	set_autorun("crewrecords")

// Civilian
/obj/item/modular_computer/console/preset/civilian/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/crew_manifest())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	//hard_drive.store_file(new/datum/computer_file/program/supply())


// Civilian Offices
/obj/item/modular_computer/console/preset/civilian/professional/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)

/obj/item/modular_computer/console/preset/civilian/professional/install_default_programs()
	..()
	var/datum/computer_file/program/crew_manifest/CM = locate(/datum/computer_file/program/crew_manifest) in hard_drive.stored_files
	hard_drive.remove_file(CM)
	hard_drive.store_file(new/datum/computer_file/program/records())

// Civilian Library
/obj/item/modular_computer/console/preset/civilian/professional/library/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/library())

// Trade Console
/obj/item/modular_computer/console/preset/trade/install_default_hardware()
	..()
	card_slot =69ew/obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/trade/install_default_programs()
	..()
	hard_drive.store_file(new /datum/computer_file/program/trade())
	set_autorun("trade")

//Dock control
/*
/obj/item/modular_computer/console/preset/dock/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)

/obj/item/modular_computer/console/preset/dock/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	//hard_drive.store_file(new/datum/computer_file/program/supply())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	//hard_drive.store_file(new/datum/computer_file/program/docking())

// Crew-facing supply ordering computer
/obj/item/modular_computer/console/preset/supply/install_default_hardware()
	..()
	printer =69ew/obj/item/computer_hardware/printer(src)

/obj/item/modular_computer/console/preset/supply/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/supply())
	set_autorun("supply")

// ERT
/obj/item/modular_computer/console/preset/ert/install_default_hardware()
	..()
	ai_slot =69ew/obj/item/computer_hardware/ai_slot(src)
	printer =69ew/obj/item/computer_hardware/printer(src)
	card_slot =69ew/obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/ert/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/ert())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/comm())
	//hard_drive.store_file(new/datum/computer_file/program/aidiag())
	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())

//69ercenary
/obj/item/modular_computer/console/preset/mercenary/
	computer_emagged = TRUE

/obj/item/modular_computer/console/preset/mercenary/install_default_hardware()
	..()
	ai_slot =69ew/obj/item/computer_hardware/ai_slot(src)
	printer =69ew/obj/item/computer_hardware/printer(src)
	card_slot =69ew/obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/mercenary/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/hacked())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	//hard_drive.store_file(new/datum/computer_file/program/aidiag())

//69erchant
/obj/item/modular_computer/console/preset/merchant/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/merchant())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
*/

