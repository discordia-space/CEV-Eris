/datum/CyberSpaceAvatar/interactable/firewall/HackingTry(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	. = ..()
	for(var/obj/machinery/cyber_security_server/S in get_area(Owner))
		. = . && !S.PreventAPCHack(user, user_avatar, params)
		if(!.)
			to_chat(user, SPAN_WARNING("There is security servers preventing to hack this."))
			return

	var/obj/machinery/power/apc/A = Owner
	var/stages_of_hacking = 4
	var/timingOfStage = 40/stages_of_hacking SECONDS
	for(var/i in 1 to 4)
		var/code = A.CyberAccessCode
		var/code_len = length(code)
		. = . && do_after(user, timingOfStage, Owner,\
			needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE,\
			target_allowed_to_move = TRUE, move_range = 4)
		var/part_of_code_to_reveal = round(code_len*(i/stages_of_hacking))
		var/string_to_show = copytext(code, 1, part_of_code_to_reveal + 1)
		for(var/j in 1 to (length(code) - part_of_code_to_reveal))
			string_to_show += "*"
		to_chat(user, string_to_show)

/datum/CyberSpaceAvatar/interactable/firewall/Hacked(mob/observer/cyberspace_eye/user, datum/CyberSpaceAvatar/user_avatar, params)
	var/obj/machinery/power/apc/A = Owner
	user.AccessCodes += A.CyberAccessCode
