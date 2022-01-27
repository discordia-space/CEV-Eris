ADMIN_VERB_ADD(/client/proc/roll_dices, R_FUN, FALSE)
/client/proc/roll_dices()
	set category = "Fun"
	set name = "Roll Dice"
	if(!check_rights(R_FUN))
		return

	var/sum = input("How69any times should we throw?") as num
	var/side = input("Select the number of sides.") as num
	if(!side)
		side = 6
	if(!sum)
		sum = 2

	var/dice = num2text(sum) + "d" + num2text(side)

	if(alert("Do you want to inform the world about your game?",,"Yes", "No") == "Yes")
		to_chat(world, "<h2 style=\"color:#A50400\">The dice have been rolled by Gods!</h2>")

	var/result = roll(dice)

	if(alert("Do you want to inform the world about the result?",,"Yes", "No") == "Yes")
		to_chat(world, "<h2 style=\"color:#A50400\">Gods rolled 69dice69, result is 69result69</h2>")

	message_admins("69key_name_admin(src)69 rolled dice 69dice69, result is 69result69", 1)