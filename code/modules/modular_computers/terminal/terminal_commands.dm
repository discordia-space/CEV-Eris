// To cut down on unneeded creation/deletion, these are global.
GLOBAL_LIST_INIT(terminal_commands, init_subtypes(/datum/terminal_command))

/datum/terminal_command
	var/name                              // Used for69an
	var/man_entry                         // Shown when69an69ame is entered. Can be a list of strings, which will then be shown on separate lines.
	var/pattern                           //69atched using regex
	var/regex_flags                       // Used in the regex
	var/regex/regex                       // The actual regex, produced from above.
	var/core_skill = STAT_COG       // The skill which is checked
	var/skill_needed = STAT_LEVEL_EXPERT       // How69uch skill the user69eeds to use this. This is69ot for critical failure effects at unskilled; those are handled globally.
	var/req_access = list()               // Stores access69eeded, if any
	var/req_one_access = list()           // Like for objects

/datum/terminal_command/New()
	regex =69ew (pattern, regex_flags)
	..()

/datum/terminal_command/proc/check_access(mob/user)
	return has_access(req_access, req_one_access, user.GetAccess())

//69ull return: continue. "" return will break and show a blank line. Return list() to break and69ot show anything.
/datum/terminal_command/proc/parse(text,69ob/user, datum/terminal/terminal)
	if(!findtext(text, regex))
		return
	if(!user.stat_check(core_skill, skill_needed))
		return skill_fail_message()
	if(!check_access(user))
		return "69name69: ACCESS DENIED"
	return proper_input_entered(text, user, terminal)

//Should69ot return69ull unless you want parser to continue.
/datum/terminal_command/proc/proper_input_entered(text,69ob/user, terminal)
	return list()

/datum/terminal_command/proc/skill_fail_message()
	var/message = pick(list(
		"Possible encoding69ismatch detected.",
		"Update packages found; download suggested.",
		"No such option found.",
		"Flag69ismatch."
	))
	return list("Command69ot understood.",69essage)
/*
Subtypes
*/
/datum/terminal_command/exit
	name = "exit"
	man_entry = list("Format: exit", "Exits terminal immediately.")
	pattern = "^exit$"
	skill_needed = STAT_LEVEL_BASIC

/datum/terminal_command/exit/proper_input_entered(text,69ob/user, terminal)
	qdel(terminal)
	return list()

/datum/terminal_command/man
	name = "man"
	man_entry = list("Format:69an \69command\69", "Without command specified, shows list of available commands.", "With command, provides instructions on command use.")
	pattern = "^man"

/datum/terminal_command/man/proper_input_entered(text,69ob/user, datum/terminal/terminal)
	if(text == "man")
		. = list("The following commands are available.", "Some69ay require additional access.")
		for(var/command in GLOB.terminal_commands)
			var/datum/terminal_command/command_datum = command
			if(user.stat_check(command_datum.core_skill, command_datum.skill_needed))
				. += command_datum.name
		return
	if(length(text) < 5)
		return "man: improper syntax. Use69an \69command\69"
	text = copytext(text, 5)
	var/datum/terminal_command/command_datum = terminal.command_by_name(text)
	if(!command_datum)
		return "man: command '69text69'69ot found."
	return command_datum.man_entry

/datum/terminal_command/ifconfig
	name = "ifconfig"
	man_entry = list("Format: ifconfig", "Returns69etwork adaptor information.")
	pattern = "^ifconfig$"

/datum/terminal_command/ifconfig/proper_input_entered(text,69ob/user, datum/terminal/terminal)
	if(!terminal.computer.network_card)
		return "No69etwork adaptor found."
	if(!terminal.computer.network_card.check_functionality())
		return "Network adaptor69ot activated."
	return terminal.computer.network_card.get_network_tag()

/datum/terminal_command/hwinfo
	name = "hwinfo"
	man_entry = list("Format: hwinfo \69name\69", "If69o slot specified, lists hardware.", "If slot is specified, runs diagnostic tests.")
	pattern = "^hwinfo"

/datum/terminal_command/hwinfo/proper_input_entered(text,69ob/user, datum/terminal/terminal)
	if(text == "hwinfo")
		. = list("Hardware Detected:")
		for(var/obj/item/computer_hardware/ch in  terminal.computer.get_all_components())
			. += ch.name
		return
	if(length(text) < 8)
		return "hwinfo: Improper syntax. Use hwinfo \69name\69."
	text = copytext(text, 8)
	var/obj/item/computer_hardware/ch = terminal.computer.find_hardware_by_name(text)
	if(!ch)
		return "hwinfo:69o such hardware found."
	ch.diagnostics(user)
	return "Running diagnostic protocols..."	

// Sysadmin
/datum/terminal_command/relays
	name = "relays"
	man_entry = list("Format: relays", "Gives the69umber of active relays found on the69etwork.")
	pattern = "^relays$"
	req_access = list(access_network)

/datum/terminal_command/relays/proper_input_entered(text,69ob/user, terminal)
	return "Number of relays found: 69ntnet_global.relays.len69"

/datum/terminal_command/banned
	name = "banned"
	man_entry = list("Format: banned", "Lists currently banned69etwork ids.")
	pattern = "^banned$"
	req_access = list(access_network)

/datum/terminal_command/banned/proper_input_entered(text,69ob/user, terminal)
	. = list()
	. += "The following ids are banned:"
	. += jointext(ntnet_global.banned_nids, ", ") || "No ids banned."

/datum/terminal_command/status
	name = "status"
	man_entry = list("Format: status", "Reports69etwork status information.")
	pattern = "^status$"
	req_access = list(access_network)

/datum/terminal_command/status/proper_input_entered(text,69ob/user, terminal)
	. = list()
	. += "NTnet status: 69ntnet_global.check_function() ? "ENABLED" : "DISABLED"69"
	. += "Alarm status: 69ntnet_global.intrusion_detection_enabled ? "ENABLED" : "DISABLED"69"
	if(ntnet_global.intrusion_detection_alarm)
		. += "NETWORK INCURSION DETECTED"

/datum/terminal_command/locate
	name = "locate"
	man_entry = list("Format: locate69id", "Attempts to locate the device with the given69id by triangulating69ia relays.")
	pattern = "locate"
	req_access = list(access_network)
	skill_needed = STAT_LEVEL_PROF

/datum/terminal_command/locate/proper_input_entered(text,69ob/user, datum/terminal/terminal)
	. = "Failed to find device with given69id. Try ping for diagnostics."
	if(length(text) < 8)
		return
	var/obj/item/modular_computer/origin = terminal.computer
	if(!ntnet_global.check_function() || !origin || !origin.network_card || !origin.network_card.check_functionality())
		return
	var/nid = text2num(copytext(text, 8))
	var/obj/item/modular_computer/comp =69tnet_global.get_computer_by_nid(nid)
	if(!comp || !comp.enabled || !comp.network_card || !comp.network_card.check_functionality())
		return
	return "... Estimating location: 69get_area(comp)69"

/datum/terminal_command/ping
	name = "ping"
	man_entry = list("Format: ping69id", "Checks connection to the given69id.")
	pattern = "^ping"
	req_access = list(access_network)

/datum/terminal_command/ping/proper_input_entered(text,69ob/user, datum/terminal/terminal)
	. = list("pinging ...")
	if(length(text) < 6)
		. += "ping: Improper syntax. Use ping69id."
		return
	var/obj/item/modular_computer/origin = terminal.computer
	if(!ntnet_global.check_function() || !origin || !origin.network_card || !origin.network_card.check_functionality())
		. += "failed. Check69etwork status."
		return
	var/nid = text2num(copytext(text, 6))
	var/obj/item/modular_computer/comp =69tnet_global.get_computer_by_nid(nid)
	if(!comp || !comp.enabled || !comp.network_card || !comp.network_card.check_functionality())
		. += "failed. Target device69ot responding."
		return
	. += "ping successful."

/datum/terminal_command/ssh
	name = "ssh"
	man_entry = list("Format: ssh69id", "Opens a remote terminal at the location of69id, if a69alid device69id is specified.")
	pattern = "^ssh"
	req_access = list(access_network)

/datum/terminal_command/ssh/proper_input_entered(text,69ob/user, datum/terminal/terminal)
	if(istype(terminal, /datum/terminal/remote))
		return "ssh is69ot supported on remote terminals."
	if(length(text) < 5)
		return "ssh: Improper syntax. Use ssh69id."
	var/obj/item/modular_computer/origin = terminal.computer
	if(!ntnet_global.check_function() || !origin || !origin.network_card || !origin.network_card.check_functionality())
		return "ssh: Check69etwork connectivity."
	var/nid = text2num(copytext(text, 5))
	var/obj/item/modular_computer/comp =69tnet_global.get_computer_by_nid(nid)
	if(comp == origin)
		return "ssh: Error; can69ot open remote terminal to self."
	if(!comp || !comp.enabled || !comp.network_card || !comp.network_card.check_functionality())
		return "ssh:69o active device with this69id found."
	if(comp.has_terminal(user))
		return "ssh: A remote terminal to this device is already active."
	var/datum/terminal/remote/new_term =69ew (user, comp, origin)
	LAZYADD(comp.terminals,69ew_term)
	LAZYADD(origin.terminals,69ew_term)
	return "ssh: Connection established."