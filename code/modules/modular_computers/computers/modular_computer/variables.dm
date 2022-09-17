// This is the base type that handles everything. Subtypes can be easily created by tweaking variables in this file to your liking.
#define MODCOMP_PROCESSOR "processor"
#define MODCOMP_HARDDRIVE "storage"
#define MODCOMP_NETCARD "network"
#define MODCOMP_IDSLOT "idslot"
#define MODCOMP_PRINTER "printer"
#define MODCOMP_DISK "diskslot"
#define MODCOMP_AISLOT "aislot"
#define MODCOMP_POWERPROVIDER "powerprovider"
#define MODCOMP_SCANNER "scanner"
#define MODCOMP_GPS "gps"
#define MODCOMP_LIGHT "light"
#define MODCOMP_ALL_COMPONENTS list(MODCOMP_PROCESSOR,MODCOMP_HARDDRIVE,MODCOMP_NETCARD,MODCOMP_IDSLOT,MODCOMP_PRINTER,MODCOMP_DISK,MODCOMP_AISLOT,MODCOMP_POWERPROVIDER,MODCOMP_SCANNER,MODCOMP_GPS,MODCOMP_LIGHT)
#define MODCOMP_SIZE_SMALL 1 // PDA's
#define MODCOMP_SIZE_MEDIUM 2 // Tablets
#define MODCOMP_SIZE_LARGE 3 // Laptops / Computers
#define MODCOMP_SIZE_HUGE 4 // Stationary computers
#define MODCOMP_SIZE_GIGANTIC 5 // server-racks

/obj/item/modular_computer
	name = "Modular Computer"
	desc = "A modular computer. You shouldn't see this."
	description_info = "Can have its components or batteries switched with a screwdriver."
	description_antag = "Can be emagged for acces to illegal applications."
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
	var/emagged = FALSE							// Whether the computer is emagged.
	var/base_active_power_usage = 50						// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_idle_power_usage = 5							// Power usage when the computer is idle and screen is off (currently only applies to laptops)
	var/bsod = FALSE										// Error screen displayed
	var/ambience_last_played								// Last time sound was played

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = null												// This thing isn't meant to be used on it's own. Subtypes should supply their own icon.
	icon_state = null
	center_of_mass = null									// No pixelshifting by placing on tables, etc.
	randpixel = 0											// And no random pixelshifting on-creation either.
	var/icon_state_menu = "menu"							// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/icon_state_screensaver = "standby"
	var/max_hardware_size = 0								// Maximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/steel_sheet_cost = 5								// Amount of steel sheets refunded when disassembling an empty frame of this computer.
	var/screen_light_strength = 0							// Intensity of light this computer emits. Comparable to numbers light fixtures use.
	var/screen_light_range = 2								// Intensity of light this computer emits. Comparable to numbers light fixtures use.
	var/list/all_threads = list()							// All running programs, including the ones running in background

	// Damage of the chassis. If the chassis takes too much damage it will break apart.
	var/damage = 0				// Current damage level
	var/broken_damage = 50		// Damage level at which the computer ceases to operate
	var/max_damage = 100		// Damage level at which the computer breaks apart.
	var/list/terminals          // List of open terminal datums.
	var/list/obj/item/computer_hardware/attached_components = list()
	var/component_space = 5 // our component space , each one occupies a different amount

	var/modifiable = TRUE	// can't be modified or damaged if false

	var/stores_pen = FALSE
	var/obj/item/pen/stored_pen
