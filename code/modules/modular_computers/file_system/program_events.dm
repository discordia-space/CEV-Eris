// Events are sent to the program by the computer.
// Always include a parent call when overriding an event.

// Called when the ID card is removed from computer. ID is removed AFTER this proc.
/datum/computer_file/program/proc/event_id_removed()
	return

// Called when the file containing this program is removed from the disk. File is removed AFTER this proc.
/datum/computer_file/program/proc/event_file_removed()
	kill_program(forced=TRUE)

// Called when the disk containing this program is removed from computer. Disk is removed AFTER this proc.
/datum/computer_file/program/proc/event_disk_removed()
	kill_program(forced=TRUE)

// Called when the computer fails due to power loss. Override when program wants to specifically react to power loss.
/datum/computer_file/program/proc/event_power_failure()
	kill_program(forced=TRUE)

// Called when the69etwork connectivity fails. Computer does69ecessary checks and only calls this when requires_ntnet_feature and similar69ariables are69ot69et.
/datum/computer_file/program/proc/event_network_failure()
	kill_program(forced=TRUE)
	if(program_state == PROGRAM_STATE_BACKGROUND)
		computer.visible_message("<span class='warning'>\The 69computer69's screen displays an error: \"Network connectivity lost - process 69filename69.69filetype69 (PID 69rand(100,999)69) terminated.\"</span>", range = 1)
	else
		computer.visible_message("<span class='warning'>\The 69computer69's screen briefly freezes and then shows: \"FATAL69ETWORK ERROR -69TNet connection lost. Please try again later. If problem persists, please contact your system administrator.\"</span>", range = 1)
		computer.update_icon()