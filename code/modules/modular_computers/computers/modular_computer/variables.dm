// This is the base type that handles everything. Subtypes can be easily created by tweaking69ariables in this file to your liking.

/obj/item/modular_computer
	name = "Modular Computer"
	desc = "A69odular computer. You shouldn't see this."
	spawn_blacklisted = TRUE
	bad_type = /obj/item/modular_computer
	var/enabled = 0											// Whether the computer is turned on.
	var/screen_on = 1										// Whether the computer is active/opened/it's screen is on.
	var/datum/computer_file/program/active_program			// A currently active program running on the computer.
	var/hardware_flag = 0									// A flag that describes this device type
	var/last_power_usage = 0								// Last tick power usage of this computer
	var/last_battery_percent = 0							// Used for deciding if battery percentage has chandged
	var/last_world_time = "00:00"
	var/list/last_header_icons
	var/computer_emagged = FALSE							// Whether the computer is emagged.
	var/apc_powered = FALSE									// Set automatically. Whether the computer used APC power last tick.
	var/base_active_power_usage = 50						// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_idle_power_usage = 5							// Power usage when the computer is idle and screen is off (currently only applies to laptops)
	var/bsod = FALSE										// Error screen displayed
	var/ambience_last_played								// Last time sound was played

	//69odular computers can run on69arious devices. Each DEVICE (Laptop, Console, Tablet,..)
	//69ust have it's own DMI file. Icon states69ust be called exactly the same in all files, but69ay look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon =69ull												// This thing isn't69eant to be used on it's own. Subtypes should supply their own icon.
	icon_state =69ull
	center_of_mass =69ull									//69o pixelshifting by placing on tables, etc.
	randpixel = 0											// And69o random pixelshifting on-creation either.
	var/icon_state_menu = "menu"							// Icon state overlay when the computer is turned on, but69o program is loaded that would override the screen.
	var/icon_state_screensaver = "standby"
	var/max_hardware_size = 0								//69aximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/steel_sheet_cost = 5								// Amount of steel sheets refunded when disassembling an empty frame of this computer.
	var/screen_light_strength = 0							// Intensity of light this computer emits. Comparable to69umbers light fixtures use.
	var/screen_light_range = 2								// Intensity of light this computer emits. Comparable to69umbers light fixtures use.
	var/list/all_threads = list()							// All running programs, including the ones running in background

	// Damage of the chassis. If the chassis takes too69uch damage it will break apart.
	var/damage = 0				// Current damage level
	var/broken_damage = 50		// Damage level at which the computer ceases to operate
	var/max_damage = 100		// Damage level at which the computer breaks apart.
	var/list/terminals          // List of open terminal datums.

	// Important hardware (must be installed for computer to work)
	var/obj/item/computer_hardware/processor_unit/processor_unit				// CPU. Without it the computer won't run. Better CPUs can run69ore programs at once.
	var/obj/item/computer_hardware/network_card/network_card					//69etwork Card component of this computer. Allows connection to69TNet
	var/obj/item/computer_hardware/hard_drive/hard_drive						// Hard Drive component of this computer. Stores programs and files.

	// Optional hardware (improves functionality, but is69ot critical for computer to work in69ost cases)
	var/obj/item/cell/cell													// An internal power source for this computer. Can be recharged.
	var/suitable_cell = /obj/item/cell/medium								//What type of battery do we take?
	var/obj/item/computer_hardware/card_slot/card_slot						// ID Card slot component of this computer.69ostly for HoP69odification console that69eeds ID slot for69odification.
	var/obj/item/computer_hardware/printer/printer							// Printer component of this computer, for your everyday paperwork69eeds.
	var/obj/item/computer_hardware/hard_drive/portable/portable_drive		// Portable data storage
	var/obj/item/computer_hardware/ai_slot/ai_slot							// AI slot, an intellicard housing that allows69odifications of AIs.
	var/obj/item/computer_hardware/tesla_link/tesla_link						// Tesla Link, Allows remote charging from69earest APC.
	var/obj/item/computer_hardware/scanner/scanner							// One of several optional scanner attachments.
	var/obj/item/computer_hardware/gps_sensor/gps_sensor						// GPS sensor used to track device
	var/obj/item/computer_hardware/led/led									// Light Emitting Diode, used for flashlight functionality in PDAs


	var/modifiable = TRUE	// can't be69odified or damaged if false

	var/stores_pen = FALSE
	var/obj/item/pen/stored_pen
